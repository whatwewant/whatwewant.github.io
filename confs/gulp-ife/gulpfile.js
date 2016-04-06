/****************************************************
  > File Name    : gulpfile.js
  > Author       : Cole Smith
  > Mail         : tobewhatwewant@gmail.com
  > Github       : whatwewant
  > Created Time : 2016年03月31日 星期四 15时19分35秒
 ****************************************************/

var path = require('path');
// get browser path
var indexPage = (function () {
  var args = (function () {
    return process.env.npm_config_argv ? JSON.parse(process.env.npm_config_argv).original : null;
  })() || process.argv;

  for (i in args) {
    if (args[i] === '--index' && args[parseInt(i) + 1]) {
      var indexString = args[parseInt(i) + 1];
      if (typeof indexString != 'string') {
        console.error("Error: ", "IndexPage  Must be A String");
        process.exit();
      }
      if (! indexString.endsWith(".html")) {
        // console.error("Error: ", "Parameter " + indexString + " Must Use .html postfix！");
        indexString += ".html";
        // process.exit();
      }

      return indexString;
    }
  }
})() || 'index.html';

var gulp = require('gulp'),
    sass = require('gulp-ruby-sass'), // build sass
    // sass = require('gulp-sass'), //
    jshint = require('gulp-jshint'), // check js syntax
    concat = require('gulp-concat'), // concat js
    uglify = require('gulp-uglify'), // compress js
    autoprefixer = require('gulp-autoprefixer'), //
    concatCss = require('gulp-concat-css'), // concat css
    cleanCss = require('gulp-clean-css'), // compress css
    sourcemaps = require('gulp-sourcemaps'), // js blank
    imagemin = require('gulp-imagemin'), // compress images
    notify = require('gulp-notify'), // notify info
    // watch = require('gulp-watch'), //
    livereload = require('gulp-livereload'), // livereload
    webserver = require('gulp-webserver'); // webserver

var MODE = process.env.npm_lifecycle_event;
var SOURCE_DIR = './src',
    BUILD_DIR = './build';

/**
 * Compile With file
 *    file type: {type: 'changed|added', path: filePATH}
 */
var Compile = function (file) {
      // basic config
      var config = {
        loaders: [
          {test: /\.scss$/, loader: 'sass'},
          {test: /\.css$/, loader: 'css'},
          {test: /\.js$/, loader: 'js'},
          {test: /\.(png|jpg)$/, loader: 'image'},
          {test: /\.html$/, loader: 'html'},
          {test: /\.(eot|woff|ttf|svg)$/, loader: 'fonts'},
        ],

        deals: {
          sass: function compileSass (filePath, buildPath) {
            return sass(filePath, {style: 'expanded'})
                   .on('error', sass.logError)
                   .pipe(gulp.dest(path.join(buildPath || SOURCE_DIR, 'css')));
          },
          css: function compileCss (filePath, buildPath) {
            if (MODE === 'build') {
                gulp.src(filePath)
                    .pipe(autoprefixer('last 2 version'))
                    .pipe(sourcemaps.init())
                    .pipe(cleanCss())
                    .pipe(sourcemaps.write())
                    .pipe(gulp.dest(path.join(buildPath || BUILD_DIR, 'css')))
                    .pipe(livereload());
            } else {
                gulp.src(filePath)
                    .pipe(autoprefixer('last 2 version'))
                    .pipe(gulp.dest(path.join(buildPath || BUILD_DIR, 'css')))
                    .pipe(livereload());
            }
          },
          js: function compileJs (filePath, buildPath) {
            if (MODE === 'build') {
                gulp.src(filePath)
                    .pipe(jshint())
                    .pipe(jshint.reporter('default'))
                    .pipe(sourcemaps.init())
                    .pipe(uglify())
                    .pipe(sourcemaps.write())
                    .pipe(gulp.dest(path.join(buildPath || BUILD_DIR, 'js')))
                    .pipe(livereload());
            } else {
                gulp.src(filePath)
                    .pipe(gulp.dest(path.join(buildPath || BUILD_DIR, 'js')))
                    .pipe(livereload());
            }
          },
          image: function compileImage (filePath, buildPath) {
            gulp.src(filePath)
                .pipe(imagemin({ optimizationLevel: 5, progressive: true, interlaced: true}))
                .pipe(gulp.dest(path.join(buildPath || BUILD_DIR, 'images')))
                .pipe(livereload());
          },
          fonts: function copyFonts (filePath, buildPath) {
            gulp.src(filePath)
                .pipe(gulp.dest(path.join(buildPath || BUILD_DIR, 'images')))
                .pipe(livereload());
          },
          html: function copyHtml (filePath, buildPath) {
            gulp.src(filePath)
                .pipe(gulp.dest(path.join(__dirname, buildPath || BUILD_DIR)))
                .pipe(livereload());
          },
        },
      };

      // deal with file
      for (var index in config.loaders) {
        if (config.loaders[index].test.test(file.path)) {
          // console.log(file.path + ' is ' + config.loaders[index].loader);
          config.deals[config.loaders[index].loader](file.path);
        }
      }
  };


gulp.task('webserver', function () {
  if (MODE === 'build') return ;

  var stream = gulp.src(BUILD_DIR)
        .pipe(webserver({
            host: '0.0.0.0',
            port: 8090,
            path: '/',
            livereload: true,
            // open: true,
            open: '/' + indexPage,
        }));
  stream.emit('kill');
});

gulp.task('index', function () {
    gulp.src(path.join(SOURCE_DIR, "*.html"))
        .pipe(gulp.dest(path.join(__dirname, BUILD_DIR)));
});


var event = {
  sass: function (file) {
    return sass(file.path, {style: 'expanded'})
           .on('error', sass.logError)
           .pipe(gulp.dest(path.join(SOURCE_DIR, 'css')));
  }
};

// common
gulp.task('sass', function (event) {
    return sass(path.join(SOURCE_DIR, 'sass/**/*.scss'), {style: 'expanded'})
           .on('error', sass.logError)
           .pipe(gulp.dest(path.join(SOURCE_DIR, 'css')));
});


// build mode: compress js
// develop mode: just copy js
gulp.task('uglify', function () {
    if (MODE === 'build') {
        gulp.src(path.join(SOURCE_DIR, 'js/**/*.js'))
            .pipe(jshint())
            .pipe(jshint.reporter('default'))
            .pipe(sourcemaps.init())
            .pipe(uglify())
            .pipe(sourcemaps.write())
            .pipe(gulp.dest(path.join(BUILD_DIR, 'js')))
            .pipe(livereload());
    } else {
        gulp.src(path.join(SOURCE_DIR, 'js/**/*.js'))
            .pipe(gulp.dest(path.join(BUILD_DIR, 'js')))
            .pipe(livereload());
    }
});

// build mode: compress css
// develop mode: copy css
gulp.task('cleanCss', function () {
    if (MODE === 'build') {
        gulp.src(path.join(SOURCE_DIR, 'css/**/*.css'))
            .pipe(autoprefixer('last 2 version'))
            .pipe(sourcemaps.init())
            .pipe(cleanCss())
            .pipe(sourcemaps.write())
            .pipe(gulp.dest(path.join(BUILD_DIR, 'css')))
            .pipe(livereload());
    } else {
        gulp.src(path.join(SOURCE_DIR, 'css/**/*.css'))
            .pipe(autoprefixer('last 2 version'))
            .pipe(gulp.dest(path.join(BUILD_DIR, 'css')))
            .pipe(livereload());
    }
});

// build image
gulp.task('imagemin', function () {
    gulp.src(path.join(SOURCE_DIR, 'images/**/*'))
        .pipe(imagemin({ optimizationLevel: 5, progressive: true, interlaced: true}))
        .pipe(gulp.dest(path.join(BUILD_DIR, 'images')))
        .pipe(livereload());
});

gulp.task('fonts', function () {
    gulp.src(path.join(SOURCE_DIR, 'fonts/**/*'))
        .pipe(gulp.dest(path.join(BUILD_DIR, 'fonts')));
});

gulp.task('watch', function () {
    if (MODE === 'build') return ;

    // gulp.watch(path.join(SOURCE_DIR, 'sass/**/*.scss'), ['sass']);
    // gulp.watch('sass/**/*.scss', {cwd: SOURCE_DIR}, ['sass']);
    // gulp.watch([path.join(SOURCE_DIR, '*.html')], ['index']).on('change', livereload.changed);

    gulp.watch([path.join(SOURCE_DIR, '/**/*')]).on('change', function (file) {
      Compile(file);
    });

    livereload.listen();

});

if (MODE === 'build') {
    gulp.task('default', [
              'index',
              'sass', 'cleanCss', 'uglify',
              'imagemin', 'fonts',
            ]);
} else {
    gulp.task('default', [
              'index',
              'watch', 'webserver'
            ]);
}
