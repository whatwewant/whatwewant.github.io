/* 
 * gulp
 * 建议使用Google Chrome, 并安装gulp-livereload扩展
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
var react = require('gulp-react')

// config parameters
var config = {
    server: '127.0.0.1',
    server_ports: [8000, 8080, 8088, 8888, 
                    4000, 3000, 12345, 2345, 9000]
};

gulp.task('uglify', function () {
    gulp.src('src/js/**/*.js')
        .pipe(jshint())
        .pipe(jshint.reporter('default'))
        // final product
        // .pipe(concat('main.js'))
        .pipe(uglify())
        .pipe(sourcemaps.write())
        .pipe(gulp.dest('dist/js'));
        // .pipe(notify({message: 'Uglify Js Complete.'}));
});

gulp.task('minifyCss', function () {
    gulp.src('src/css/**/*.css')
        .pipe(autoprefixer('last 2 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4'))
        // final product
        // .pipe(concat('main.css'))
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
        // compress css when you enable the follow line
        .pipe(gulp.dest('src/css'))
        // if you don't want to compress css, enable it and disable last line
        // .pipe(gulp.dest('dist/css'))
        .pipe(notify({message: 'Sass Complete.'}));
});

gulp.task('images', function () {
    gulp.src('src/images/**/*')
        .pipe(imagemin({ optimizationLevel: 5, progressive: true, interlaced: true }))
        .pipe(gulp.dest('dist/images'))
        .pipe(notify({message: 'Images Complete.'}));
});

gulp.task('server', function(done) {
    var port = null;
    for (var i=0; i<config.server_ports.length; ++i) {
        port = config.server_ports[i];
        try {
            http.createServer(
                st({ path: __dirname + '', index: 'index.html', cache: false })
            ).listen(port, done);

            break;
        } catch (ex) {
            console.error("Server Error", ex.message);
        }
    }

    // tips
    console.log("");
    console.log("*******************************");
    console.log("* Visit http://" + config.server + ":" + port+ " *");
    console.log("*******************************");
    console.log("");
});

gulp.task('fonts', function () {
    gulp.src('src/fonts/**/*')
        .pipe(gulp.dest('dist/fonts'));
});

gulp.task('react', function () {
    return gulp.src('src/jsx/**/*.js')
        .pipe(sourcemaps.init())
        .pipe(react())
        .pipe(sourcemaps.write('.'))
        .pipe(gulp.dest('src/js'));
});

gulp.task('watch', function () {
    gulp.watch('src/js/**/*.js', ['uglify']);
    gulp.watch('src/jsx/**/*.js', ['react']);
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

gulp.task('default', ['server', 'watch']);
