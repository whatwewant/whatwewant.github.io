/****************************************************
  > File Name    : gulpfile.js
  > Author       : Cole Smith
  > Mail         : tobewhatwewant@gmail.com
  > Github       : whatwewant
  > Created Time : 2016年06月14日 星期四 15时19分35秒
 ****************************************************/

var path = require('path');
// get browser path
var indexPage = (function () {
  var args = (function () {
    return process.env.npm_config_argv ? JSON.parse(process.env.npm_config_argv).original : null;
  })() || process.argv;

  for (var i in args) {
    if (args[i] === '--index' && args[parseInt(i) + 1]) {
      var indexString = args[parseInt(i) + 1];
      if (typeof indexString != 'string') {
        console.error("Error: ", "IndexPage  Must be A String");
        process.exit();
      }
      if (! indexString.endsWith(".html")) {
        indexString += ".html";
      }

      return indexString;
    }
  }
})() || 'index.html';

var gulp        = require('gulp'),
    htmlmin     = require('gulp-htmlmin'),
    sass        = require('gulp-ruby-sass'), // build sass
    // sass = require('gulp-sass'), //
    jshint      = require('gulp-jshint'), // check js syntax
    concat      = require('gulp-concat'), // concat js
    uglify      = require('gulp-uglify'), // compress js
    autoprefixer= require('gulp-autoprefixer'), //
    concatCss   = require('gulp-concat-css'), // concat css 
    cleanCss    = require('gulp-clean-css'), // compress css
    sourcemaps  = require('gulp-sourcemaps'), // js blank
    imagemin    = require('gulp-imagemin'), // compress images
    babel       = require('gulp-babel'), // es6 -> es5
    notify      = require('gulp-notify'), // notify info
    rename      = require('gulp-rename'),
    // livereload  = require('gulp-livereload'), // livereload
    // webserver   = require('gulp-webserver'); // webserver
    webserver   = require('gulp-server-livereload');

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
                gulp.src(filePath)
                    .pipe(sourcemaps.init())
                    .pipe(autoprefixer('last 2 version'))
                    .pipe(sourcemaps.write())
                    .pipe(rename(function (path) {
                      path.basename += '.min';
                      path.extname = '.css';
                    }))
                    .pipe(gulp.dest(path.join(buildPath || BUILD_DIR, 'css')))
                    // .pipe(livereload());
          },
          js: function compileJs (filePath, buildPath) {
                gulp.src(filePath)
                    .pipe(sourcemaps.init())
                    // .pipe(babel({
                    //     presets: ['es2015']
                    // }))
                    .pipe(babel())
                    .pipe(sourcemaps.write())
                    .pipe(rename(function (path) {
                      path.basename += '.min';
                      path.extname = '.js';
                    }))
                    .pipe(gulp.dest(path.join(buildPath || BUILD_DIR, 'js')))
                    // .pipe(livereload());
          },
          image: function compileImage (filePath, buildPath) {
            gulp.src(filePath)
                .pipe(imagemin({ optimizationLevel: 5, progressive: true, interlaced: true}))
                .pipe(gulp.dest(path.join(buildPath || BUILD_DIR, 'images')))
                // .pipe(livereload());
          },
          fonts: function copyFonts (filePath, buildPath) {
            gulp.src(filePath)
                .pipe(gulp.dest(path.join(buildPath || BUILD_DIR, 'images')))
                // .pipe(livereload());
          },
          html: function copyHtml (filePath, buildPath) {
            gulp.src(filePath)
                .pipe(gulp.dest(path.join(__dirname, buildPath || BUILD_DIR)))
                // .pipe(livereload());
          },
        },
      };

      // deal with file
      for (var index in config.loaders) {
        if (config.loaders[index].test.test(file.path)) {
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
            // path: '/', // gulp-webserver
            // livereload: {
            //   enable: true,
            //   port: 3375,
            //   filter: function (fileName) {
            //     console.log(fileName);
            //     return true;
            //   },
            // },
            livereload: true,
            open: true, // gulp-server-livereload
            defaultFile: indexPage, // gulp-server-livereload
            // open: '/' + indexPage, // gulp-webserver
        }));

  stream.emit('kill');
});

gulp.task('index', function () {
    gulp.src(path.join(SOURCE_DIR, "*.html"))
        .pipe(htmlmin({collapseWhitespace: true}))
        .pipe(gulp.dest(path.join(__dirname, BUILD_DIR)));
});

// common
gulp.task('sass', function (event) {
    return sass(path.join(SOURCE_DIR, 'sass/**/*.scss'), {style: 'expanded'})
           .on('error', sass.logError)
           .pipe(gulp.dest(path.join(SOURCE_DIR, 'css')));
});


// build mode: compress js
gulp.task('uglify', function () {
  gulp.src(path.join(SOURCE_DIR, 'js/**/*.js'))
      .pipe(jshint())
      .pipe(jshint.reporter('default'))
      .pipe(babel({
        presets: ['es2015']
      }))
      .pipe(uglify())
      .pipe(rename(function (path) {
        path.basename += '.min';
        path.extname = '.js';
      }))
      .pipe(gulp.dest(path.join(BUILD_DIR, 'js')));
});

// build mode: compress css
gulp.task('cleanCss', function () {
  gulp.src(path.join(SOURCE_DIR, 'css/**/*.css'))
    .pipe(autoprefixer('last 2 version'))
    .pipe(cleanCss())
    .pipe(gulp.dest(path.join(BUILD_DIR, 'css')));
});

// build image
gulp.task('imagemin', function () {
    gulp.src(path.join(SOURCE_DIR, 'images/**/*'))
        .pipe(imagemin({ optimizationLevel: 5, progressive: true, interlaced: true}))
        .pipe(gulp.dest(path.join(BUILD_DIR, 'images')))
        // .pipe(livereload());
});

gulp.task('fonts', function () {
    gulp.src(path.join(SOURCE_DIR, 'fonts/**/*'))
        .pipe(gulp.dest(path.join(BUILD_DIR, 'fonts')));
});

gulp.task('watch', function () {
    if (MODE === 'build') return ;

    gulp.watch([path.join(SOURCE_DIR, '/**/*')]).on('change', function (file) {
      Compile(file);
    });

    // livereload.listen({
    //   host: '0.0.0.0',
    //   port: 3376,
    //   start: true,
    // });
});


// Develop mode: npm run start  // default start index.html
//               npm run start --index activity // start activity.html
//
// Product mode: npm run build
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
