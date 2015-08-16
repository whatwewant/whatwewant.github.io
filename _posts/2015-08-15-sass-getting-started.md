---
layout: post
title: "开始用 SASS 代替 CSS"
keywords: [""]
description: ""
category: 前端
tags: [css, sass]
---
{% include JB/setup %}

### [SASS教程](http://www.w3cplus.com/sassguide)

### 一、文件后缀名
* 1 `.sass`
    * 使用缩进, 不使用分号和大括号
* 2 `.scss`
    * 和css差不多，可以使用嵌套

```
// 1 .sass
body
    background: #eee
    font-size: 12px
p
    background: #0982c1

// 2 .scss

body {
    background: #eee;
    font-size: 12px;

    p {
        background: #0982c1;
    }
}
```

### 二、导入
* Syntax:
    * `@import 'filename.format';`
* 在sass中导入不同文件:
    * 导入`.scss`文件:
        * 编译时只生成一个css文件
        * 可以忽略后缀名: `@import 'a';`
    * 导入`.css`文件:
        * 和css导入样式文件一样，导入的css文件不会合并到编译后的文件，而是以`@import`方式存在
        * 不能忽略后缀名

### 三、注释
* 单行注释: `//`, 不会被转义
* 多行注释: `/* ... */`

### 四、变量
* Syntax:
    * sass变量必须以`$`开头, 后面紧跟`变量名`
    * `变量名`和`变量值`用冒号`:`分开
    * 如果值后面加上`!default`则表示默认值.
* `普通变量`: 定义之后可以在全局范围使用

```
// sass style
// ****************** 
$fontSize: 12px;
body {
    font-size: $fontSize;
}

// css style
// *******************
body {
    font-size: 12px;
}
```

* `默认变量`: sass的默认变量仅需要在后面加上`!default`即可
    * `覆盖默认变量`: 在使用之前重新定义变量即可

```
// sass style
// *********************
$baseLineHeight: 1.5 !default;
body {
    line-height: $baseLineHeight;
}

// css style
// *********************
body {
    line-height: 1.5;
}
```

```
// sass的默认变量一般是用来设置默认值
//  然后根据需要来覆盖的，覆盖方式很简单
// 只需要在默认变量使用之前重新声明变量
// *******************
// sass style
// *******************
$baseLineHeight: 1.5 !default;
$baseLineHeight: 2;
body {
    line-height: $baseLineHeight;
}

// css style
// **************************
body {
    line-height: 2;
}
```

* `特殊变量`
    * 为属性的部分或者特殊情况修啊必须以`#{$variables}`形式使用

```
// sass style
// *******************************
$borderDirection:   top !default;
$baseFontSize:      12px !default;
$baseLineHeight:    1.5 !default;

// 应用于class和属性
.border-#{borderDirection} {
    border-#{borderDirection}: 1px solid #ccc;
}

// 应用于复杂属性值
body {
    font: #{baseFontSize}/#{baseLineHeight};
}


// css style
// ************************
.border-top {
    border-top: 1px; solid #ccc;
}

body {
    font: 12px/1.5;
}
```

* `多值变量`
    * `list类型`: 类似js中的`数组`
        * 定义: 可以用空格，逗号或小括号分隔多值
        * 取值: 可用nth($var, $index)取值
        * 函数: 
            * `length($tist)`
            * `join($list1, $list2, [$separator])`
            * `append($list, $value, [$separator])`
            * [More](http://sass-lang.com/documentation/Sass/Script/Functions.html)
    * `map类型`: 类似js中的`对象`
        * map数据以`key`和`value`成对出现，其中value可以是普通值，也可以是`list`;
        * 格式: `$map: (key1: value1, key2: value2, key3:value3)`;
        * 获得: `map-get($map, $key);`
        * 函数:
            * `map-merge($map1, $map2)`
            * `map-keys($map)`
            * `map-values($map)`
            * [More](http://sass-lang.com/documentation/Sass/Script/Functions.html)


```
// List
// 定义
// 一维数组
/ ********************* begin
$px: 5px 10px 20px 30px;

// 二维数组，相当于js中的二维数组
$px: 5px 10px, 20px 30px;
$px: (5px 10px) (20px 30px);
// ******************** end
```

```
// List 使用
// sass style
// *******************

$linkColor: #08c #333 !default; // 第一个为默认值，第二个为鼠标划过值
a {
    color: nth($linkColor, 1);

    &:hover {
        color: nth($linkColor, 2);
    }
}

// css style
// *****************************
a {
    color: #08c;
}
a:hover {
    color: #333;
}
```

```
// Map 定义
$headings: (h1: 2em, h2:1.5em, h3: 1.2em);
```

```
// Map 使用
// sass style
// *******************************
$headings: (h1: 2em, h2: 1.5em, h3: 1.2em);
@each $header, $size in $headings {
    #($header) {
        font-size: $size;
    }
}

// css style
// *******************************
h1 {
    font-size: 2em;
}
h2 {
    font-size: 1.5em;
}
h3 {
    font-size: 1.2em;
}
```

* `全局变量`
    * 在变量值后面加上`!global`.

* `局部变量`:
    * 在选择器里声明的变量

```
// sass style
// **********************
$fontSize: 12px;
body {
    $fontSize: 14px; // 局部变量
    font-size: $fontSize;
}

p {
    font-size: $fontSize;
}

// css style
// **************************
body {
    font-size: 14px;
}
p {
    font-size: 12px;
}
```

### 嵌套(Nesting)
* 分为选择器嵌套和属性嵌套, 主要指`选择器嵌套`
* `选择器嵌套`:
    * 使用`&`表示父元素选择器

```
// sass style
// ********************************
#top-nav {
    line-height: 40px;
    text-transform: capitalize;
    background-color: #333;

    li {
        float: left;
    }

    a {
        display: block;
        padding: 0 10px;
        color: #fff;

        &:hover {
            color: #ddd;
        }
    }
}

// css style
// **************************
#top-nav {
    line-height: 40px;
    text-transform: capitalize;
    background-color: #333;
}

#top-nav li {
    float: left;
}

#top-nav a {
    display: block;
    padding: 0 10px;
    color: #fff;
}

#top-nav a:hover {
    color: #ddd;
}
```

* `属性嵌套`:
    * 指有些属性拥有同一个开始单词, 如border-width, border-color都是以border开头的单词

```
// sass style
// ****************************
.fakeshadow {
    border: {
        style: solid;
        left: {
            width: 4px;
            color: #888;
        }
        right: {
            width: 2px;
            color: #ccc;
        }
    }
}

// css style
// ****************************
.fakeshadow {
    border-style: solid;
    border-left-width: 4px;
    border-left-color: #888;
    border-right-width: 2px;
    border-right-color: #ccc;
}
```

### `@at-root`
* 用来跳出选择器嵌套.默认所有的嵌套，继承所有上级选择器，但是有了这个就可以跳出所有上级选择器.
* `普通跳出嵌套`

```
// sass style
// ****************
// 没有跳出
.parent-1 {
    color: #f00;
    .child {
        width: 100px;
    }
}

// 单个选择器跳出
.parent-2 {
    color: #f00;
    @at-root .child {
        width: 200px;
    }
}

// 多个选择器跳出
.parent-3 {
    background: #f00;
    @at-root {
        .child1 {
            width: 300px;
        }
        .child2 {
            width: 400px;
        }
    }
}

// css style
// ************************
.parent-1 {
    color: #f00;
}
.parent-1 .child {
    width: 100px;
}

.parent-2 {
    color: #f00;
}
.child {
    width: 200px;
}

.parent-3 {
    background: #f00;
}
.child1 {
    width: 300px;
}
.child2 {
    width: 400px;
}
```

* `at-root (with-out: ...)` 和 `at-root (with: ...)`
    * 默认@at-root只能跳出选择器嵌套，而不能跳出`@media`或`@support`
    * 跳出:
        * `@media`:  `@at-root (without: media)`
        * `support`: `@at-root (without: support)`
    * 四个值:
        * `all`: 表示所有
        * `rule`: 表示常规css, 就是默认情况
            * @at-root == @at-root (with: rule)
        * `media`: 表示media
        * `support`
