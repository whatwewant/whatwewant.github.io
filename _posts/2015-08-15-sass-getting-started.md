---
layout: post
title: "开始用 SASS 代替 CSS"
keywords: [""]
description: ""
category: FrontEnd
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

### 五、嵌套(Nesting)
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

### 六、`@at-root`
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

```
// sass style
// ****************************************
// 跳出父级元素嵌套
@media print {
    .parent1 {
        color: #f00;
        @at-root .child1 {
            width: 200px;
        }
    }
}

// 跳出media嵌套，父级有效
@media print {
    .parent2 {
        color: #f00;

        @at-root (widthout: media) {
            .child2 {
                width: 200px;
            }
        }
    }
}

// 跳出media和父级
@media print {
    .parent3 {
        color: #f00;

        @at-root (without: all) {
            .child3 {
                width: 200px;
            }
        }
    }
}


// css style
// *******************************
@meida print {
    .parent1 {
        color: #f00;
    }
    .child1 {
        width: 200px;
    }
}

@media print {
    .parent2 {
        color: #f00;
    }
}

.parent2 .child2 {
    width: 200px;
}

@media print {
    .parent3 {
        color: #f00;
    }
}

.child3 {
    width: 200px;
}
```

* `@at-root` 与 `&`配合使用

```
// sass style
// ******************************
.child {
    @at-root .parent & {
        color: #f00;
    }
}

// css style
// ******************************
.parent .child {
    color: #f00;
}
```

* 应用于`@keyframes`

```
// sass style
// ******************************
.demo {
    ...
    animation: motion 3s infinite;

    @at-root {
        @keyframes motion {
            ...
        }
    }
}

// css style
// ********************************
.demo {
    ...
    animation: motion 3s infinite;
}

@keyframes motion {
    ...
}
```

### 七、`混合(mixin)`
* 关于`@mixin`与`@include`
    * sass中使用`@mixin`声明混合，可以传递参数，参数以`$`符号开始，多个参数以逗号分开，也可以给参数设置默认值.
    * 声明`@mixin`通过`@include`来调用
* `无参数mixin`

```
// sass style
// ****************************
@mixin center-block {
    margin-left: auto;
    margin-right: auto;
}

.demo {
    @include center-block;
}

// css style
// ****************************
.demo {
    margin-left: auto;
    margin-right: auto;
}
```

* `有参数mixin`

```
// sass style
// ****************************
@mixin opacity($opacity:50) {
    opacity: $opacity / 100;
    filter: alpha(opacity=$opacity);
}

// sass style
// ****************************
.opacity {
    @include opacity; // 参数使用默认值
}
.opacity-80 {
    @include opacity(80); // 传递参数
}
```

* `多个参数mixin`
    * 调用时可直接传入值。如`@include`传入参数的个数小于`@mixin`定义参数的个数，则按照顺序表示，后面不足的使用默认值，如没有默认值。则报错。
    * 除此之外还可以选择性的传入参数，使用参数名与值同时传入.

```
// sass style
// *******************************
@mixin horizontal-line($border: 1px dashed #ccc, $padding: 10px) {
    border-bottom: $border;
    padding-top: $padding;
    padding-bottom: $padding;
}
.imgtext-h li {
    @include horizontal-line(1px solid #ccc);
}
.imgtext-h--product li {
    @include horizontal-line($padding: 15px);
}

// css style
// *******************************
.imgtext-h li {
    border-bottom: 1px solid #cccccc;
    padding-top: 10px;
    padding-bottom: 10px;
}
.imgtext-h--product li {
    border-bottom: 1px dashed #cccccc;
    padding-top: 15px;
    padding-bottom: 15px;
}
```

* `多组值参数mixin`
    * 如果一个参数可以有多组值。如box-shadow、transition等，那么参数则需要在变量后加三个点表示, 如`$variables...`

```
// sass style
// ********************************
// box-shadow 可以有多组值，所以在变量参数后面添加...
@mix box-shadow ($shadow...) {
    -webkit-box-shadow:$shadow;
    box-shadow: $shadow;
}
.box {
    border: 1px solid #ccc;
    @include box-shadow(0 2px 2px rgba(0, 0, 0, 3), 0 3px 3px rgba(0, 0, 0, .3), 0 4px 4px rgba(0, 0, 0, .3));
}

// css style
// *********************************
.box {
    border: 1px solid #ccc;
    -webkit-box-shadow: 0 2px 2px rgba(0,0,0,.3),0 3px 3px rgba(0,0,0,.3)0 4px 4px rgba(0,0,0,.3);
    box-shadow: 0 2px 2px rgba(0,0,0,.3),0 3px 3px rgba(0,0,0,.3)0 4px 4px rgba(0,0,0,.3);
}
```

* `@content`
    * 可以用来解决css3的@media等带来的问题。
    * 它可以使用`@mixin`接收一整块样式, 接受的样式从`@content`开始.

```
// sass style
// ********************************
@mixin max-screen($res) {
    @media only screen and (max-width: $res) {
        @content;
    }
}

@include max-screen(480px) {
    body {
        color: red;
    }
}

// css style
// **********************************
@media only screen and (max-width: 480px) {
    body { color: red; }
}
```

### 八、继承
* 定义:
    * sass中，选择器继承可以让选择器继承另一个选择器的所有样式, 并联合声明.
    * 使用选择器的继承，要使用关键字`@extend`，后面紧跟需要继承的选择器.

```
// sass style
// **********************************
h1 {
    border: 4px solid #ff9aa9;
}
.speaker {
    @extend h1;
    border-width: 2px;
}

// css style
// **********************************
h1,.speaker {
    border: 4px solid #ff9aa9;
}
.speaker {
    border-width: 2px;
}
```

#### 占位选择器`%`
* 定义:
    * 优势: 如果不调用则不会有任何多余的css文件,避免了以前在一些基础的文件中定义了很多基础的样式，然后在实际应用中不管是否使用了`@extend`去继承相应的样式，都会解析出来所有的样式.
    * 占位选择器以`%`标识定义, 通过`@extend`调用.

```
// sass style
// **************************
%ir {
    color: transparent;
    text-shadow: none;
    background-color: transparent;
    border: 0px;
}
%clearfix {
    @if $lte 7 {
        *zoom: 1;
    }
    &:before,
    &:after {
        content: "";
        display: table;
        font: 0/0 a;
    }
    &:after {
        clear: both;
    }
}
#header {
    h1 {
        @extend %ir;
        width: 300px;
    }
}
.ir {
    @extend %ir;
}

// css style
// ******************
#header h1,
.ir {
    color: transparent;
    text-shadow: none;
    background-color: transparent;
    border: 0;
}
.header h1 {
    width: 300px;
}

// ****************
// 
  如上代码，定义了两个占位选择器%ir和%clearfix, 其中%clearfix并没有调用，所以解析出来的css样式也就没有clearfix部分.
  占位选择器的出现，使得css样式跟腱简练可控，没有多余.
  PS: 在@media中暂时不能使用@extend @media外的代码片段, 也就是站为选择器必须定义在@media内部.
```

### 九、`函数`
* 定义:
    * sass定义了很多函数可供使用，当然也可以自定义函数.
    * 以`@function`开始, [官方](http://sass-lang.com/documentation/Sass/Script/Functions.html)
    * 实际项目组，我们使用最多的是颜色函数，二颜色函数中又以`lignten`(减淡)和`darken`(加深)最为常用.
    * `lighten($color, $amount)` 和 `darken($color, $amount)`
        * $color: 颜色值
        * $amount: 百分比

```
// sass style
// ************************
$baseFontSize:  10px !default;
$gray:          #ccc !default;

// pixels to rems
@funtion px2Rem($px) {
    @return $px / $baseFontSIze * 1rem;
}

body {
    font-size: $baseFontSIze;
    color: lighten($gray, 10%);
}
.test {
    font-size: px2Rem(16px);
    color: darken($gray, 10%);
}

// css style
// ******************************
body {
    font-size: 10px;
    color: #E6E6E6;
}
.test {
    font-size: 1.6rem;
    color: #B3B3B3;
}
```

### 十、`运算`
* 定义:
    * sass具有运算的特性，可以对数值型的Value(数字、颜色、变量等)进行加减乘除四则运算.
    * 注意: `运算符前后请留一个空格，否则报错.`

```
$baseFontSize:      14px !default;
$baseLineHeight:    1.5 !default;
$baseGap:           $baseFontSize * $baseLineHeight !default;
$halfBaseGap:       $baseGap / 2 !default;
$smallFontSize:     $baseFontSize - 2px !default;

// grid
$_columns:          12 !default;    // Total number of columns
$_column-width:     60px !default;  // Width of a single column
$_gutter:           20px !default;  // Width of the gutter
$_gridsystem-width: $_column * ($_column-width + $_gutter);
```

### 十一、`条件判断及循环`

#### `@if判断`
* `@if`可以一个条件单独使用，也可以和`@else`结合多条件使用

```
// sass style
// ************************************
$lte7: true;
$type: monster;
.ib {
    display: inline-block;
    @if $lte7 {
        *display: inline;
        *zoom: 1;
    }
}
p {
    @if $type == ocean {
        color: blue;
    } @else if $type == matador {
        color: red;
    } @else if $type == monster {
        color: green;
    } @else {
        color: black;
    }
}

// css style
// ***********************
.ib {
    display: inline-block;
    *display: inline;
    *zoom: 1;
}
p {
    color: green;
}
```

#### `三目判断`
* Syntax:
    * `if ($condition, $if_true_value, $if_false_value)`
        * 如果$condition为true, 则值为$if_true_value; 否则为$if_false_value

```
if(true, 1px, 2px) => 1px
if(false, 1px, 2px) => 2px
```

#### `for循环`
* 两种Syntax:
    * `@for $var from <start> through <end> { ... }`
    * `@for $var from <start> to <end> { ... }`
        * $var为变量
        * start为起始值，end为解数值
        * 注意: `throught包含end这个数，即<=; to不包含end, 即<`

```
// sass style
// *************************
@for $i from 1 through 3 {
    .item-#{$i} { width: 2em * $i; }
}

// css style
// *************************
.item-1 {
    width: 2em;
}
.item-2 {
    width: 4em;
}
.item-3 {
    width: 6em;
}
```

#### `@each循环`
* Syntax:
    * `@each $var in <list or map> { ... }`

* 单个字段list数据循环

```
$animal-list: puma, sea-slug;
$each $animal in $animal-list {
    .#{$animal}-icon {
        background-image: url('/images/#{animal}.png');
    }
}

// css style
// **************************
.puma-icon {
    background-image: url('/images/puma.png');
}
.sea-slug-icon {
    background-image: url('/images/sea-slug.png');
}
```

* 多个字段list数据循环

```
// sass style
// *********************************
$animal-data: (puma, black, default), (sea-slug, blue, pointer);
@each $animal, $color, $cursor in $animal-data {
    .#{$animal}-icon {
        background-image: url('/images/#{$animal}.png');
        border: 2px solid $color;
        cursor: $cursor;
    }
}

// css style
// *********************************
.puma-icon {
    background-image: url('/images/puma.png');
    border: 2px solid black;
    cursor: default;
}
.sea-slug-icon {
    background-image: url('/images/sea-slug.png');
    border: 2px solid blue;
    cursor: pointer;
}
```

* 多个字段map数据循环

```
// sass style
// ********************************
$headings: (h1: 2em, h2:1.5em, h3: 1.2em);
@each $header, $size in $headings {
    #{$header} {
        font-size: $size;
    }
}

// css style
// ********************************
h1 { font-size: 2em; }
h2 { font-size: 1.5em; }
h3 { font-size: 1.2em; }
```
