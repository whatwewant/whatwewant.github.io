---
layout: post
title: "gulp 入门"
keywords: [""]
description: ""
category: 前端
tags: [gulp, 前端, nodejs]
---
{% include JB/setup %}

## 参考
* [不错的入门教程](http://www.html-js.com/article/Nimojs--frontend-development-1)
* [Gulp API 文档](http://www.gulpjs.com.cn/docs/api/)

## 一. 安装: gulp 
* ([npm 模块管理器安装](http://javascript.ruanyifeng.com/nodejs/npm.html))
* -g 全局安装

```bash
sudo npm install -g gulp
```

## 二. 实习开始
```js
// 进入或创建项目地址:

// 实验一 begin: 使用gulp入门
// 在项目根目录新建 gulpfile.js 文件
// 获取 gulp
gulp = require('gulp');

// 获取 uglify 模块, 用于压缩JS
// 提前安装: npm install uglify
// 在项目目录下安装即可，不用全局, 会创建node_modules目录存放模块
var uglify = require('gulp-uglify');

// 压缩JS文件
// script 是task的一个参数名, 字符串
// 执行命令: gulp script
// 1. gulp.task(name, fn) - 定义任务，第一个参数是任务名，第二个参数是任务内容
// 2. gulp.src(path) - 选择文件，传入参数是文件路径
// 3. gulp.dest(path) - 输出文件
// 4. gulp.pipe() - 管道，你可以暂时将 pipe 理解为将操作加入执行队列
// 注意: 请确保src指定的目录和文件存在，否则将不执行压缩，即使添加修改新文件
gulp.task('script', function () {
    // 找到文件
    gulp.src('./js/*.js')
        // 压缩文件
        .pipe(uglify())
        // 另存为压缩后的文件
        .pipe(gulp.dest('dist/js'));
});
// 实验一 end

// 实验二 创建监听器,一旦修改, 自动执行 begin
// 新任务: 监听改变
// 执行命令: gulp auto
gulp.task('auto', function () {
    // 监听文件修改，当文件修改则执行 script 任务
    gulp.watch('js/*.js', ['script']);
});
// 实验二 end

// 实验三 启用默认任务 begin
// default 是默认名字
// 执行命令: gulp
gulp.task('default', ['script', 'auto']);
// 实验三 end

// 实验四 压缩 css Begin
// gulp-minify-css 模块,用于压缩 CSS
// 安装: npm install gulp-minify-css
minifyCSS = require('gulp-minify-css');

// 压缩css
// 启动命令: gulp css
gulp.task('css', function () {
    gulp.src('./css/*.css')
        .pipe(minifyCSS())
        .pipe(gulp.dest('dist/css'));
});

// 启动命令: gulp auto
gulp.task('auto', function () {
    gulp.watch('css/*.css', ['css']);
})

// 使用 gulp.task('default')定义默认任务
// 命令: gulp
gulp.task('default', ['auto', 'css']);
// 实验四 end

// 实验五 压缩图片: begin
// 获取压缩图片模块: gulp-imagemin
// 安装: npm install gulp-imagemin
imagemin = require('gulp-imagemin');

// 压缩图片任务: src + 模块 + dest
// 注意: 请确保images目录及文件存在
gulp.task('images', function () {
    gulp.src('images/*.*')
        .pipe(imagemin())
        .pipe(gulp.dest('dist/images'));
});
// auto watch
gulp.task('auto', function () {
    gulp.watch('images/*.*', ['images']);
});
// default task
gulp.task('default', ['auto', 'images']);
// 实验五 end

// 实验六 编译less begin
// 获取 gulp-less 模块
// 安装: npm install gulp-less
var less = require('gulp-less');

// 启动命令: gulp less
gulp.task('less', function () {
    gulp.src('./less/**.less')
        .pipe(less())
        .pipe(gulp.dest('./dist/less'));
});

// 启动命令: gulp auto
gulp.task('auto', function () {
    gulp.watch('./less/**.less', ['less']);
})

// 启动命令: gulp
gulp.task('default', ['less', 'auto']);
// 实验六 end

// 实验七 用 glup 编译 Sass begin
// 用 ruby-sass 编译css
// 安装: npm install gulp-ruby-sass
// 注意: 前提得先安装 ruby 和 sass
// 可参考: https://github.com/nimojs/blog/issues/14
// 安装 ruby: sudo apt-get intsall ruby-dev
// 能翻墙直接: gem install sass
var sass = require('gulp-ruby-sass');

gulp.task('sass', function () {
    return sass('sass/')
    .on('error', function (err) {
        console.error('Error!', err.message);
    })
    .pipe(gulp.dest('dist/css'));
});
gulp.task('auto', function () {
    // sass/**/*.scss 是 glob 语法, node-glob
    gulp.watch('sass/**/*.scss', ['sass']);
});
gulp.task('default', ['sass', 'auto']);
// 实验七 end
```

## 三 [使用gulp构建项目](https://github.com/nimojs/gulp-book/blob/master/chapter7.md)
* 请看 [npm模块管理器](http://javascript.ruanyifeng.com/nodejs/npm.html)
* 1. 生成 package.json:
    * npm init
* 2. 安装依赖:
    * npm install gulp --save-dev
    * (package.json 会多出 devDependencies ... gulp ...)
    * 其他依赖: 
        * npm install gulp-uglify gulp-watch-path stream-combiner2
        * npm install gulp-sourcemaps gulp-minify-css gulp-autoprefixer gulp-less
        * npm install gulp-ruby-sass gulp-imagemin gulp-util --save-dev
    * `当你将这份 gulpfile.js 配置分享给你的朋友时，就不需要将 node_modules/　发送给他，他只需在命令行输入`：
        * npm install 
* 3. 设计目录结构:
    * src : 源码目录:
        * less *.less文件
        * sass *.scss *.sass文件
        * css
        * js
        * fonts
        * images
    * dist : 编译后压缩的版本目录
* 4. 让命令行输出的文字带颜色

```js
var gulp = require('gulp');
var gutil = require('gulp-util');

gulp.task('default', function () {
    gutil.log('message');
    gutil.log(gutil.colors.red('error'));
    gutil.log(gutil.colors.green('message') + 'some');
});
```

* 5. 配置JS压缩任务: gulp-uglify
    * ...
* 6. gulp-watch-path: 只编辑改动js

```js
var watchPath = require('gulp-watch-path');

gulp.task('watchjs', function () {
    gulp.watch('src/js/**/*.js', function (event) {
        // watchPath(event, search, replace[, distExt])
        //  eventgulp.watch 回调函数的 event
        //  search需要被替换的字符串或正则（字符串会被转换为正则 /^src\//）
        //  replace第三个参数是新的的字符串
        //  distExt扩展名(非必填)
        var paths = watchPath(event, 'src/', '/dist');
        /*
          paths 
            {
                srcPath: 'src/js/log.js',
                srcDir: 'src/js/',
                distPath: 'dist/js/',
                srcFilename: 'log.js',
                distFilename: 'log.js'
            }
        */
        gutil.log(gutil.colors.green(event.type) + ' ' + paths.srcPath);
        gutil.log('Dist ' + paths.distPath);

        gulp.src(path.srcPath)
            .pipe(uglify())
            .pipe(gulp.dest(path.distPath));
    });
});

gulp.task('default', ['watchjs']);
```

* 7. stream-combiner2: 用于检测js错误, 一出错, gulp立即终止并报错
* 8. gulp-sourcemaps:
    * 压缩后的代码不存在换行符和空白符，导致出错后很难调试，好在我们可以使用sourcemap 帮助调试 
* 9. 配置CSS任务: gulp-minify-css
* 10. gulp-autoprifixer: 
    * autoprefixer 解析 CSS文件并且添加浏览器前缀到CSS规则里
* 11. 配置 less 任务: gulp-less
* 12. 
