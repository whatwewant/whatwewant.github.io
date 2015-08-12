/* 
 * gulp
 * */
var gulp = require('gulp');
var gutil = require('gulp-util'); // 字体颜色
var uglify = require('gulp-uglify'); // 压缩js
var minifyCss = require('gulp-minify-css'); // 压缩css
var less = require('gulp-less'); // 编译 less
var sass = require('gulp-ruby-sass'); // 编译 sass
var livereload = require('gulp-livereload'); // 自动更新浏览器
var autoprefixer = require('gulp-autoprefixer'); // 加人各浏览器前缀
var imagemin = require('gulp-imagemin'); // 压缩图片
var notify = require('gulp-notify'); // 更新提醒
var jshint = require('gulp-jshint'); // js 代码校验
var concat = require('gulp-concat'); // 合并js
var sourcemaps = require('gulp-sourcemaps'); // js 空白问题帮助
var st = require('st');
var http = require('http');
// var watchPath = require('gulp-watch-path'); // 监测改动

gulp.task('uglify', function () {
    gulp.src('src/js/**/*.js')
        .pipe(jshint())
        .pipe(jshint.reporter('default'))
        // .pipe(concat('main.js'))
        .pipe(uglify())
        .pipe(sourcemaps.write())
        .pipe(gulp.dest('dist/js'))
        .pipe(notify({message: 'Uglify Js Complete.'}));
});

gulp.task('minifyCss', function () {
    gulp.src('src/css/**/*.css')
        .pipe(autoprefixer('last 2 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4'))
        .pipe(minifyCss())
        .pipe(gulp.dest('dist/css'))
        .pipe(notify({message: 'MinifyCss Complete.'}));
});

gulp.task('less', function () {
    gulp.src('src/less/**/*.less')
        .pipe(less())
        .pipe(gulp.dest('dist/less'))
        .pipe(notify({message: 'Less Complete.'}));
});

gulp.task('sass', function () {
    return sass('src/sass/', {style: 'expanded'})
        .on('error', function (err) {
                console.error('Error!', err.message);
            })
        .pipe(autoprefixer('last 2 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4'))
        .pipe(gulp.dest('dist/css'))
        .pipe(notify({message: 'Sass Complete.'}));
});

gulp.task('images', function () {
    gulp.src('src/images/**/*')
        .pipe(imagemin({ optimizationLevel: 5, progressive: true, interlaced: true }))
        .pipe(gulp.dest('dist/images'))
        .pipe(notify({message: 'Images Complete.'}));
});

gulp.task('server', function(done) {
  http.createServer(
    st({ path: __dirname + '', index: 'index.html', cache: false })
  ).listen(8081, done);
});

gulp.task('fonts', function () {
    gulp.src('src/fonts/**/*')
        .pipe(gulp.dest('dist/fonts'));
});

gulp.task('watch', function () {
    gulp.watch('src/**/*.js', ['uglify']);
    gulp.watch('src/**/*.css', ['minifyCss']);
    gulp.watch('src/**/*.less', ['less']);
    gulp.watch('src/**/*.scss', ['sass']);
    gulp.watch('src/images/*', ['images']);
    gulp.watch('src/fonts/*', ['fonts']);

    // listen dist/**
    livereload.listen();
    gulp.watch(['dist/**']).on('change', livereload.changed);
    gulp.watch(['*.html']).on('change', livereload.changed);
});

gulp.task('default', ['watch']);
