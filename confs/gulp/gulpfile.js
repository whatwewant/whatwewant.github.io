/*
 * gulp
 * 建议使用Google Chrome, 并安装gulp-livereload扩展
 * */
var gulp = require('gulp'),
    gutil = require('gulp-util'), // 字体颜色
    uglify = require('gulp-uglify'), // 压缩js
    minifyCss = require('gulp-minify-css'), // 压缩css
    less = require('gulp-less'), // 编译 less
    sass = require('gulp-ruby-sass'), // 编译 sass
    livereload = require('gulp-livereload'), // 自动更新浏览器
    autoprefixer = require('gulp-autoprefixer'), // 加人各浏览器前缀
    imagemin = require('gulp-imagemin'), // 压缩图片
    notify = require('gulp-notify'), // 更新提醒
    jshint = require('gulp-jshint'), // js 代码校验
    concatCss = require('gulp-concat-css'), // 合并 css
    concat = require('gulp-concat'), // 合并js
    sourcemaps = require('gulp-sourcemaps'), // js 空白问题帮助
    // st = require('st');
    // http = require('http');
    // watchPath = require('gulp-watch-path'); // 监测改动
    react = require('gulp-react'),
    // server
    connect = require('gulp-connect');


gulp.task('sass', function () {
    return sass('src/sass/', {style: 'expanded'})
        .on('error', function (err) {
                console.error('Error!', err.message);
            })
        .pipe(gulp.dest('src/css'))
        .pipe(notify({message: 'Sass Complete.'}));
});

gulp.task('less', function () {
    gulp.src('src/less/**/*.less')
        .pipe(less())
        .pipe(gulp.dest('src/css'))
        .pipe(notify({message: 'Less Complete.'}));
});

gulp.task('checkcss', function () {
    gulp.src('src/css/**/*.css')
        .pipe(concatCss('main.min.css'))
        .pipe(gulp.dest('dist/css'));
});

gulp.task('checkjs', function () {
    gulp.src('src/js/**/*.js')
        .pipe(jshint())
        .pipe(jshint.reporter('default'))
        .pipe(concat('main.min.js'))
        .pipe(gulp.dest('dist/js'));
});

gulp.task('uglify', function () {
  gulp.src('src/js/**/*.js')
    .pipe(concat('main.min.js'))
    .pipe(uglify())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('dist/js'))
    .pipe(notify({message: 'Uglify Js Complete.'}));
});

gulp.task('minifyCss', function () {
  gulp.src('src/css/**/*.css')
    .pipe(autoprefixer('last 2 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4'))
    .pipe(concat('main.min.css'))
    .pipe(minifyCss())
    .pipe(gulp.dest('dist/css'))
    .pipe(notify({message: 'MinifyCss Complete.'}));
});

gulp.task('images', function () {
    gulp.src('src/images/**/*')
        .pipe(imagemin({ optimizationLevel: 5, progressive: true, interlaced: true }))
        .pipe(gulp.dest('dist/images'))
        .pipe(notify({message: 'Images Complete.'}));
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

// gulp.task('server', function(done) {
//     var port = null;
//     for (var i=0; i<config.server_ports.length; ++i) {
//         port = config.server_ports[i];
//         try {
//             http.createServer(
//                 st({ path: __dirname + '', index: 'index.html', cache: false })
//             ).listen(port, done);
// 
//             break;
//         } catch (ex) {
//             console.error("Server Error", ex.message);
//         }
//     }
// 
//     // tips
//     console.log("");
//     console.log("*******************************");
//     console.log("* Visit http://" + config.server + ":" + port+ " *");
//     console.log("*******************************");
//     console.log("");
// });
//

gulp.task('connect', function () {
        connect.server({
            root: '.',
            host: '0.0.0.0',
            port: 8090,
        });
        // connect.serverClose();
    }
);

gulp.task('watch', function () {
    gulp.watch('src/**/*.less', ['less']);
    gulp.watch('src/**/*.scss', ['sass']);
    gulp.watch('src/images/*', ['images']);
    gulp.watch('src/fonts/*', ['fonts']);
    gulp.watch('src/css/**/*.css', ['checkcss']);
    gulp.watch('src/js/**/*.js', ['checkjs']);
    gulp.watch('src/jsx/**/*.js', ['react']);
    
    if (gulp.build) {
        gulp.watch('src/js/**/*.js', ['uglify']);
        gulp.watch('src/**/*.css', ['minifyCss']);
    }

    // listen dist/**
    livereload.listen();
    gulp.watch(['dist/**']).on('change', livereload.changed);
    gulp.watch(['*.html']).on('change', livereload.changed);

});

// Set build Status
gulp.task('setbuild', function () {
   gulp.build = true;
});

// build
gulp.task('build', ['setbuild', 'sass',
                    'react', 'uglify', 'minifyCss']);

// @TODO when it runs server, livereload doesnot work correctly.
// gulp.task('default', ['server', 'watch']);
gulp.task('default', ['sass', 'checkcss', 'checkjs', 'react', 
                      'watch', 'connect']);
