/****************************************************
  > File Name    : gulpfile.js
  > Author       : Cole Smith
  > Mail         : tobewhatwewant@gmail.com
  > Github       : whatwewant
  > Created Time : 2016年03月31日 星期四 15时19分35秒
 ****************************************************/

var path = require('path');
var gulp = require('gulp'),
    sass = require('gulp-ruby-sass'), // build sass
    jshint = require('gulp-jshint'), // check js syntax
    concat = require('gulp-concat'), // concat js
    uglify = require('gulp-uglify'), // compress js
    autoprefixer = require('gulp-autoprefixer'), //
    concatCss = require('gulp-concat-css'), // concat css
    cleanCss = require('gulp-clean-css'), // compress css
    sourcemaps = require('gulp-sourcemaps'), // js blank
    imagemin = require('gulp-imagemin'), // compress images
    notify = require('gulp-notify'), // notify info
    livereload = require('gulp-livereload'), // livereload
    webserver = require('gulp-webserver'); // webserver
    
var MODE = process.env.npm_lifecycle_event;
var SOURCE_DIR = './src',
    BUILD_DIR = './build';

gulp.task('webserver', function () {
    if (MODE === 'build') return ;
    gulp.src(BUILD_DIR)
        .pipe(webserver({
            host: '0.0.0.0',
            port: 8090,
            livereload: true,
            open: true,
        }));
});

gulp.task('index', function () {
    gulp.src(path.join(SOURCE_DIR, '*.html'))
        .pipe(gulp.dest(path.join(__dirname, BUILD_DIR)));
})

// common
gulp.task('sass', function () {
    return sass(path.join(SOURCE_DIR, 'sass/**/*.scss'), {style: 'expanded'})
        .on('error', function (err) {
            console.error('Error!', err.message);
        })
        .pipe(gulp.dest(path.join(SOURCE_DIR, 'css')))
        // .pipe(notify({message: 'Sass Build Complete.'}));
});



// build mode: compress js
// develop mode: just copy js
gulp.task('uglify', function () {
    if (MODE === 'build') {
        gulp.src(path.join(SOURCE_DIR, 'js/**/*.js'))
            .pipe(jshint())
            .pipe(jshint.reporter('default'))
            .pipe(concat('app.min.js'))
            .pipe(sourcemaps.init())
            .pipe(uglify())
            .pipe(sourcemaps.write())
            .pipe(gulp.dest(path.join(BUILD_DIR, 'js')))
            .pipe(livereload())
            // .pipe(notify({message: 'Uglify Js Complete.'}));
    } else {
        gulp.src(path.join(SOURCE_DIR, 'js/**/*.js'))
            .pipe(concat('app.min.js'))
            .pipe(gulp.dest(path.join(BUILD_DIR, 'js')))
            .pipe(livereload())
            // .pipe(notify({message: 'Copy Js Complete.'}));
    }
});

// build mode: compress css
// develop mode: copy css
gulp.task('cleanCss', function () {
    if (MODE === 'build') {
        gulp.src(path.join(SOURCE_DIR, 'css/**/*.css'))
            .pipe(autoprefixer('last 2 version'))
            .pipe(concat('app.min.css'))
            .pipe(sourcemaps.init())
            .pipe(cleanCss())
            .pipe(sourcemaps.write())
            .pipe(gulp.dest(path.join(BUILD_DIR, 'css')))
            .pipe(livereload())
            // .pipe(notify({message: 'MinifyCss Complete.'}));
    } else {
        gulp.src(path.join(SOURCE_DIR, 'css/**/*.css'))
            .pipe(autoprefixer('last 2 version'))
            .pipe(concat('app.min.css'))
            .pipe(gulp.dest(path.join(BUILD_DIR, 'css')))
            .pipe(livereload())
            // .pipe(notify({message: 'Copy Css Complete.'}));
    }
});

// build image
gulp.task('imagemin', function () {
    gulp.src(path.join(SOURCE_DIR, 'images/**/*'))
        .pipe(imagemin({ optimizationLevel: 5, progressive: true, interlaced: true}))
        .pipe(gulp.dest(path.join(BUILD_DIR, 'images')))
        .pipe(livereload())
        // .pipe(notify({message: 'Compress Images Complete.'}));
})

gulp.task('fonts', function () {
    gulp.src(path.join(SOURCE_DIR, 'fonts/**/*'))
        .pipe(gulp.dest(path.join(BUILD_DIR, 'images')));
})

gulp.task('watch', function () {
    if (MODE === 'build') return ;

   // gulp.watch(path.join(SOURCE_DIR, 'sass/**/*.scss'), ['sass']);    
   // gulp.watch(path.join(SOURCE_DIR, 'css/**/*.css'), ['cleanCss']);    
   // gulp.watch(path.join(SOURCE_DIR, 'js/**/*.js'), ['uglify']);    
   // gulp.watch(path.join(SOURCE_DIR, 'images/*'), ['imagemin']);    
   // gulp.watch(path.join(SOURCE_DIR, 'fonts/*'), ['fonts']);    
   // gulp.watch(path.join(SOURCE_DIR, 'index.html'), ['index.html']);    
    gulp.watch('sass/**/*.scss', {cwd: SOURCE_DIR}, ['sass']);    
    gulp.watch('css/**/*.css', {cwd: SOURCE_DIR}, ['cleanCss']);    
    gulp.watch('js/**/*.js', {cwd: SOURCE_DIR}, ['uglify']);    
    gulp.watch('images/*', {cwd: SOURCE_DIR}, ['imagemin']);    
    gulp.watch('fonts/*', {cwd: SOURCE_DIR}, ['fonts']);    
    gulp.watch('index.html', {cwd: SOURCE_DIR}, ['index']);    

    livereload.listen();
    gulp.watch([path.join(SOURCE_DIR, 'index.html')]).on('change', livereload.changed)
})

gulp.task('default', [
                'index',
                'sass', 'cleanCss', 'uglify', 
                'imagemin', 'fonts', 
                'watch', 'webserver'])
