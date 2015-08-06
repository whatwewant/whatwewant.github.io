---
layout: post
title: "CSS3 基础"
keywords: [""]
description: ""
category: 前端
tags: [css, css3]
---
{% include JB/setup %}

### 一、初识CSS3
* 1.1 在编写CSS3样式时，不同的浏览器可能需要不同的前缀.

|  前缀  |  浏览器  |
|:------:|:--------:|
|  -webkit  |  chrome和safari  |
|  -moz     |  firefox         |
|  -ms      |  IE              |
|  -o       |  opera           |

* 1.2 CSS3 能做: 圆角、图片边框、文字阴影和盒阴影、过渡、动画
    * 选择器: class id tagname ...
    * 圆角效果: border-radius
    * 块阴影与文字阴影
    * 色彩: 新颜色: HSL CMYK HSLA RGBA
    * 渐变效果
    * 个性化字体: @Font-face
    * 多背景图: 一个元素上添加多层背景
    * 边框背景图
    * 变形出路: 对HTML元素进行旋转、缩放、移动、一些JavaScript动画
    * 多栏布局
    * 媒体查询: 针对不同屏幕分辨率，应用不同样式

### 二、边框

* 2.1 圆角效果: border-radius
    * 作用: 向元素添加圆角边框
    * Usage:
        * `border-radius: 10px; /*所有角都使用半径为10px的圆角*/`
        * `border-radius: 5px 4px 3px 2px; /*四个半径分别为左上角、右上角、右下角、左下角，顺时针*/`
        * border-radius的值除了`px`单位，还能用`百分比(%)`或者`em`
            * `border-radius: 水平 / 垂直;`
                * `border-radius: 10px / 20px;`
            * `border-radius: 水平1 水平2 / 垂直1 垂直2`

```
.demo {
    border-radius: 10px 20px 30px 40px;
}

等价于

.demo {
    border-top-left-radius: 10px;
    border-top-right-radius: 20px;
    border-bottom-right-radius: 30px;
    border-bottom-left-radius: 40px;
}
```

```
.demo {
    border-radius: 10px / 20px;
}

等价于

.demo {
    border-top-left-radius: 10px 20px;
    border-top-right-radius: 10px 20px;
    border-bottom-right-radius: 10px 20px;
    border-bottom-left-radius: 10px 20px;
}
```

```
.demo {
    border-radius: 10px 20px / 20px 10px;
}

等价于

.demo {
    border-top-left-radius: 10px 20px;
    border-top-right-radius: 20px 10px;
    border-bottom-right-radius: 10px 20px;
    border-bottom-left-radius: 20px 10px;
}
```

```html
...
<div class="circle"></div><br />
<div class="semi-circle"></div>
...
```

```css
div.circle {
    height: 100px; /*与width设置一致*/
    width: 100px;
    background: #9da;
    /*四个角值都设为宽度Or高度一半*/
    border-radius: 50px;
}

div.semi-circle {
    height: 100px;
    width: 50px;
    background: #9da;
    border-radius: 50px 50px 0 0;
}
```

* 2-2 `阴影 box-shadow`
    * 作用: 向盒子添加阴影，支持添加一个或多个
    * Usage:
        * box-shadow: X轴偏移量 Y轴偏移量 [阴影模糊半径] [阴影扩展半径] [阴影颜色] [投影方式];
        * 解释:
            * X轴偏移量: 必须，水平阴影的位置，允许负值
            * Y轴偏移量: 必须，垂直阴影的位置，允许负值
            * 阴影模糊半径: 可选，模糊的距离
            * 阴影扩展半径: 可选, 阴影的尺寸
            * 阴影颜色: 可选，阴影的颜色，省略默认为黑色
            * 投影方式: 可选，（设置inaset为内部阴影方式，否则省略为外阴影）

```css
/*外阴影*/
.boxshadow-outset {
    width: 100px;
    height: 100px;
    box-shadow: 4px 4px 6px #333;
}

/*内阴影*/
.boxshadow-inset {
    width: 100px;
    height: 100px;
    box-shadow: 4px 4px 6px #666 insert;
}

/*多阴影*/
.boxshadow-multi {
    width: 100px;
    height: 100px;
    box-shadow: 4px 2px 6px #f00, -4px -2px 6px #000, 0px 0px 12px 5px #330 inset;
}
```

* 2-3 `阴影 box-shadow (二)`
    * 1 `阴影模糊半径(blur-radius)` 与 `阴影扩展半径(spread-radius)` 的区别
        * 阴影模糊半径: 参数可选，其值只能为正，如果其值为0时，表示阴影不具有模糊效果，其值越大阴影的边缘月模糊
        * 阴影扩展半径: 参数可选，其值可以是正负值，如果其值为正，整个阴影都延展扩大，反之值为负，则缩小
    * 2 `X轴偏移量(offset-x)` 和 `Y轴偏移量(offset-y)` 可以设置为 `负数`
        * `box-shadow: offset-x offset-y [blur-radius] [spread-radius] [color] [projection-style]`
        * 负值，阴影方向: 边框左边向左，上边向上;
        * 正直, 阴影方向: 边框右边向右，下边向下
        * `当 offset-x 和 offset-y 都为0 时，四个边框都有阴影`

```
.box {
    width: 100px;
    height: 100px;
    box-shadow: 4px 4px 5px -2px #ccc;    
}

<div class="box">
</div>
```

* 2-4 Border-image 边框应用图片
    * Function: 类似background-image, 添加图片
    * Syntax: `border-image: url(IMG_SOURCE) height width repeat-style`
        * height/width 单位可以px也可以百分比
        * repeat-style: repeat(重复) stretch(拉伸) round(平铺)

### 三、颜色Color

* 3-1 颜色之RGBA
    * 含义: R(红) G(绿) B(蓝) A(透明度)
    * Syntax: color: `rgba(R-v, G-v, B-v, Alpha);`

* 3-2 渐变色彩Gradient
    * CSS3 Gradient 分为 `线性渐变(linear-gradient)` 和 `径向渐变(radial-gradient)`
    * Syntax:
        * `linear-gradient(angle | to <side-or-corner>, color-from[, color-stop])`
            * `<side-or-conor> = [left | right] || [top | bottom]`
            * `color-from/stop = <color> [ <percentage> | <length>]?`
            * `color-from 到 color-stop之间可以很多个过渡颜色，不限制个数`
            * `to top == 0 deg` `to bottom == 180 deg` `to top right == 45deg`
            * `颜色后面的percentage表示长度 == length`
    * Example:
        * background: linear-gradient(45deg, blue, red);
        * color: linear-gradient(to left top, rgb(255,255,255), rgb(0, 0, 0))
        * background: linear-gradient(0 deg, blue, green 40%, red);
            * /* A gradient going from the bottom to top, starting blue, being green after 40% and finishing red */

```
.box {
    width: 400px;
    height: 400px;
    line-height: 400px;
    text-align: center;
    color: #000;
    font-size: 24px;
    background-image: linear-gradient(to right top, red, green, blue 30%);
}

<div class="box">
    右下角向左上角的线性渐变背景
</div>
```

### 四、文字与字体

* 4-1 `text-overflow` 与 `word-wrap`
    * Function: 用来设置是否使用一个`省略标记(...)`标示对象内文本的溢出/
    * Syntax: 
        * `text-overflow: clip | ellipsis;`
            * clip: 表示剪切
            * ellipsis: 标示显示省略标记(...)
        * `text-overflow: inherit | initial | unset;` // Global values
    * But careful:
        * `text-overflow` 只是用来说明文字溢出时用什么方式显示，要实现溢出时产生的`省略号`的效果，还必须定义`强制文本在行内显示(white-space: nowrap;)`和`溢出内容为隐藏(overflow: hidden;)`, 只有这样才能实现溢出文本显示省略号的效果.

```
.box {
    /* 以下三条必须一起使用，否则无效*/
    text-overflow: ellipsis; /*显示省略号*/
    white-space: nowrap; /*禁止包含文本，只允许行内显示*/
    overflow: hidden; /*隐藏省略部分*/

    /*只能容下十(..)个字*/
    width: 200px;
    font-size: 20px; 
    background: #ccc;
}

<div class="box">
    一二三四五六七八(此处省略)
</div>
```

* 4-1-2 `word-wrap`
    * Function: 设置文本行为，当前行超过指定容器的边界时是否断开转行.
    * Syntax:
        * `word-wrap: normal | break-word;`
        * normal为默认值, break-word 设置在长单词或URL地址内部进行换行.
    * 用处: 文本编辑textarea 或 contentEditable = "true";

* 4-2 `嵌入字体@font-face`
    * Function: `@font-face`能够加载服务器端的字体文件，让浏览器端可以显示用户电脑里没有安装的字体.
    * Syntax 

```
/* @font-face Syntax*/
@font-face {
    font-family: diyFontName; /* 自定义字体名称; 该字体名称为后面使用*/
    src: 字体文件在服务器上的相对或绝对路径;
}

p {
    font-size: 12px;
    font-family: diyFontName; /* 与 @font-face中的font-family自定义的名字相同*/
}
```

* 4-3 `文本阴影text-shadow`
    * Function: text-shadow用来设置文本的阴影效果
    * Syntax: 
        * `text-shadow: offset-x offset-y blur-radius color;`
        * `text-shadow: color offset-x offset-y blur-radius;`
        * `text-shadow: offset-x offset-y color;`
        * `text-shadow: offset-x offset-y;`
    * Example:
        * text-shadow: 1px 1px 2px black;

```
/* 设置文字阴影*/
.box {
    width: 340px;
    height: 200px;
    line-height: 200px;
    padding: 30px;
    font: bold 55px/100% "微软雅黑";
    text-align: center;
    background: #C5D;
    text-shadow: 2px 2px 4px rgb(255, 255, 0);
}

<div class="box">
    文字阴影
</div>
```

### 五、与背景相关的样式
* 5-1 `background-origin`
    * Function: 设置元素背景的原始位置
    * Syntax:
        * `background-origin: border-box | padding-box | content-box | inherit;`
        * border-box: 边框
        * padding-box: 内边距(默认值)
        * content-box: 内容区域
        * inherit: 继承
    * `Take Care: 背景必须是no-repeat, 否则background-origin失效`

```
/* background-origin 原始起始位置 */
.wrap {
    width: 400px;
    height: 400px;
    border: 20px dashed #000; /* border-box 开始位置 */
    padding: 40px; /* padding-box 开始位置 */
    font-size: 40px;
    font-weight: bold;
    color: #000;
    background: #ccc url(IMG_URL) no-repeat;

    background-origin: content-box;
}

.content {
    width: inherit;
    height: 80px;
    border: 1px solid #333;
}

<div class="wrap">
    <div class="content">内容盒子</div>
</div>
```

* 5-2 `background-clip`
    * Function: 用来将背景图片作适当裁剪以适应实际需求.
    * Syntax:
        * `background-clip: border-box | padding-box | content-box | no-clip | inherit;`
        * 默认值是 border-box

```
/* background-clip 裁剪背景 */
.wrap {
    width: 400px;
    height: 400px;
    border: 20px dashed #000; /* border-box 开始位置 */
    padding: 40px; /* padding-box 开始位置 */
    font-size: 40px;
    font-weight: bold;
    color: #000;
    background: #ccc url(IMG_URL) no-repeat;

    background-origin: border-box;
    background-clip: content-box;
}

.content {
    width: inherit;
    height: 80px;
    border: 1px solid #333;
}

<div class="wrap">
    <div class="content">内容盒子</div>
</div>
```

* 5-3 `background-size`
    * Function: 设置背景图片的大小.
    * Syntax:
        * `background-size: auto | cover | contain | <长度值> | <百分比>;`
            * auto: 默认值，不改变背景图片的原始高度和宽度.
            * cover: 覆盖, 将背景图片等比例缩放以填满整个容器.
            * contain: 容纳，将背景图片等比例缩放至某一边紧贴容器边缘为止.
            * <长度值>: 成对出现100px 50px, 即背景width height; 当只设置一个值时，图片等比例缩放.
            * <百分比>: 只类型为0-100%, 其他同上.
            
```
/* background-size */
.box {
    background: url(IMG_URL) no-repeat;
    width: 500px;
    height: 300px;
    border: 1px solid #999;
    background-size: cover;
}
```

* 5-4 `multiple backgrounds`
    * Function:
        * 多重背景，也就是CSS2里background的属性外加origin、clip和size组成的新background的多次叠加，缩写为用`逗号`隔开的每组值;
        * 用分解写法时，如果有多个背景图片，而其他属性只有一个(例如background-repeat只有一个)，表明所有图片都应用该属性值.
    * Syntax: 以下都必须一起写
        * `background: bg1, bg2, bg3, ...;`
            * bgN : url(IMG_URL);
        * `background-position: bgp1, bgp2, bgp3 ...;`
            * bgpN: offset-x offset-y;
        * `background-repeat: no-repeat, no-repeat, no-repeat ...;`
        * `background-color: color;`
            * 只能一个值
    * `Take Care`:
        * background-color 只能设置一个

```
/* multiple background */
.box {
    width: 400px;
    height: 400px;
    border: 1px solid #999;

    background: url(IMG_1), url(IMG_2), url(IMG_3);
    background-position: left top, 0 200px, 200px 0; /* 具体视图片大小而定 */
    background-repeat: no-repeat, no-repeat, no-repeat;
}
```

* 5-5 导航实例

```
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CSS制作立体导航</title>
    <link rel="stylesheet" href="http://www.w3cplus.com/demo/css3/base.css">
    <style>
        body{
          background: #ebebeb;
        }
        .nav{
          width:560px;
          height: 50px;
          font:bold 0/50px Arial;
          text-align:center;
          margin:40px auto 0;
          background: #f65f57;
          /*制作圆*/
          border-radius: 10px;
          /*制作导航立体风格*/
          box-shadow: 5px 5px 10px #ccc;
        }
        .nav a{
          display: inline-block;
          -webkit-transition: all 0.2s ease-in;
          -moz-transition: all 0.2s ease-in;
          -o-transition: all 0.2s ease-in;
          -ms-transition: all 0.2s ease-in;
          transition: all 0.2s ease-in;
        }
        .nav a:hover{
          -webkit-transform:rotate(10deg);
          -moz-transform:rotate(10deg);
          -o-transform:rotate(10deg);
          -ms-transform:rotate(10deg);
          transform:rotate(10deg);
        }

        .nav li{
          position:relative;
          display:inline-block;
          padding:0 16px;
          font-size: 13px;
          text-shadow:1px 2px 4px rgba(0,0,0,.5);
          list-style: none outside none;
        }
        /*使用伪元素制作导航列表项分隔线*/
         .nav li:before {
            display: inline-block;
            content: '';
            height: 18px;
            width: 1px;
            background: linear-gradient(to right, #ef6b5f,#ca584e);
            position: absolute;
            right: 0;
            top: 18px;
         }
        
        /*删除第一项和最后一项导航分隔线*/
        .nav li:last-child:before {
         display: none;   
        }
        .nav a, .nav a:hover{
          color:#fff;
          text-decoration: none;
        }

    </style>
</head>
<body>
    <ul class="nav">
        <li><a href="">Home</a></li>
        <li><a href="">About Me</a></li>
        <li><a href="">Portfolio</a></li>
        <li><a href="">Blog</a></li>
        <li><a href="">Resources</a></li>
        <li><a href="">Contact Me</a></li>
    </ul>
</body>
</html>
```

### 六、CSS3选择器(上): 伪类选择器
* 6-1 属性选择器
    * Syntax: E为选择器, attr为属性名, val为属性值
        * `E[attr="val"]`: 等于
        * `E[attr^="val"]`: 属性attr以val `开头(^)` 的选择器E
        * `E[attr$="val"]`: 属性attr以val `结尾($)`
        * `E[attr*="val"]`: 属性attr `包含(*)` val

```
/* css */
a[class^="column"] {
    background: red;
}
a[href$=".doc"] {
    background: green;
}
a[title*="box"] {
    background: blue;
}

<!-- Html -->
<a href="##" class="columnNews">我的背景想变成红色</a>
<a href="##" class="columnVideo">我的背景想变成红色</a>
<a href="##" class="columnAboutUs">我的背景想变成红色</a><br/>
<a href="1.doc">我的背景想变成绿色</a>
<a href="2.doc">我的背景想变成绿色</a><br/>
<a href="##" title="this is a box">我的背景想变成蓝色</a>
<a href="##" title="box1">我的背景想变成蓝色</a>
<a href="##" title="there is two boxs">我的背景想变成蓝色</a>
```

* 6-2 结构性伪类选择器- root
    * `:root`选择器，是指HTML文档的根选择器, 而根元素是<html>, 所以就等同于html.
    * `:root {...}` == `html {...}`

* 6-3 结构性伪类选择器- not
    * `:not` 称为 否定选择器.和jQuery中的:not选择器一样，可以选择除了某个元素以外的所有元素.
        * `一般配合属性选择使用, 别忘了括号`
    * Example
        * `input:not([type="submit"]) {border: 1px solid red;}`
            * input中除了type为submit之外的

* 6-4 结构性伪类选择器- empty
    * Function: 选择没有任何内容的元素，这里没有是指没有任何内容，包括空格也不能有.(注释不包括)

```
/* css */
div {
    height: 50px;
}


div:empty {
    border: 1px solid #ccc;
}

<!-- html -->
<div>我这里有内容</div>
<div> <!-- 我这里有一个空格 --></div>
<div><!-- 我这里任何内容都没有 --></div>
```

* 6-5 结构性伪类选择器- target
    * Function: 目标选择器，用来匹配文档中a标签href值为另一个ID选择器值的目标元素

```
/* css */
.menuSection { display: none; }
:target {
    /* 这里: target指的就是 id="brand" 的div对象 */
    display: block;
}

<!-- html -->
<!-- 当点击Brand时, ID等于brand的选择器触发:target {...}效果 -->
<h2> <a href="#brand">Brand</a><h2>
<div class="menuSection" id="brand">
    Content for Brand
<.div>
```

```
/* css */
/* 当点击 href="brand"的a标签时, ID="brand"的标签的p标签变成黄色背景 */
#brand:target p { background: green;}

<!-- html -->
<div id="brand">
    <a href="#brand" >你变黄</a>
    <p>变黄</p>
</div>
```

* 6-6 结构性伪类选择器- first-child
    * Function: 父选择器的第一个子选择器
    * :first-child == :nth-child(1)

* 6-7 结构性伪类选择器- last-child
    * Function: 父元素的最后一个子元素

* 6-8 结构性伪类选择器- nth-child(n)
    * Funtion: 用来选择父元素的某一个或多个子元素, 不区分div:nth-child(n)的类型div
    * Syntax:
        * n 为 `整数值`, 从1开始
        * n 为表达式 或 关键词(odd | even):
            * `2n+1` == `odd` : 表示第`奇数`子元素
            * `2n+2` == `even` : 表示第`偶数`子元素
            * `n+5` : 表示第5个元素(包含)以后的所有子元素
            * `-n+5` : 表示第5个元素(包含)以前的所有子元素
            * `kN`: k为常数，如之前的2n+1的2, 此时的第一个元素是k, 每隔k个子元素
            * `kN + m`: 第一个元素为k+m(>0, 否则2k+m开始), 以后每隔k个子元素

* 6-9 结构性伪类选择器- nth-last-child(n)
    * 与:nth-child(n)类似，只不过从最后一个开始倒数

* 6-10 first-of-type 选择器 与 last-of-type 选择器
    * 与 `:first-child` 的区别就是, `指定了元素的类型`
    * 而类型就比如: `.box > p:first-of-type` 中的`p`, 因为p元素不一定是容器中的第一个子元素;
    * 当 `.box > p:first-child {...}` 中的第一个子元素不是`p`时，该css不产生任何效果; 但是 `.box > p:first-of-type { ... }` 会一直找到`p`

```
/* CSS */
/* 注意:伪类选择器冒号(:)前后不要空格*/
.box > p:first-child {
    background: red;
}

.box > p:first-of-type {
    background: green;
}

<!-- html -->
<div class="box">
    <div>第一个是DIV, 所有:first-child没效果</div>
    <p>但是:first-of-type有效，该P变为绿色</p>
</div>
```

* 6-11 nth-of-type(n) 选择器
    * 和nth-child(n)类似, 取值可以是整数, 表达式或者关键字(odd, even)
    * 与:nth-child(n)的区别是, `:nth-of-type(n)`区分类型，只有同类型才计数, 而 `:nth-child(n)` 不区分类型

```
/* css */
/* box选择器下偶数子元素 */
/* 这里，even为偶数, 那么如果box所有元素的第二个元素类型不是div的话，这个css对所有失效; 这里所说的第二个元素指的是nth-child(n)中表达式的第一个作用的元素. */
/* 如果去掉这里的'div'符号，那么效果一直在; 去掉'div'符号试试 */
.box > div:nth-child(even) {
    background: red: 
}

/* box选择器下的全部类型为div的元素偶数次序*/
/* 当'div'省略时, 自动匹配偶数元素的类型, 每个类型的偶数次序都产生作用*/
.box > div:nth-of-type(even) {
    background: green;
}

<!-- html -->
<div class="box">
  <div>我是一个Div元素</div>
  <p>我是一个段落元素</p>
  <div>我是一个Div元素</div>
  <p>我是一个段落</p>
  <div>我是一个Div元素</div>
  <p>我是一个段落</p>
  <div>我是一个Div元素</div>
  <p>我是一个段落</p>
  <div>我是一个Div元素</div>
  <p>我是一个段落</p>
  <div>我是一个Div元素</div>
  <p>我是一个段落</p>
  <div>我是一个Div元素</div>
  <p>我是一个段落</p>
  <div>我是一个Div元素</div>
  <p>我是一个段落</p>
</div>
```

* 6-13 nth-last-of-type(n) 选择器

* 6-14 only-child 选择器
    * 选择父元素有且只有唯一一个子元素的情况生效.

* 6-15 only-of-type 选择器

* `区别`

|对象|空格|区别|
|:---|---|:---|
|first-child 与 first-of-type 及 nth-child 与 nth-of-type 及 only-child 与 only-of-type 及 last-child 与 last-oftype || *-child不区分类型，但是如果它前面指定了类型(也就是说可以不指定)，那么如果符合表达式的第一个作用的元素与该类型不同时，效果全部失效, 没有任何作用. *-of-type:区分类型，如果它前面指定了类型，则它会自动分类，找到与其类型相同的符合表达式的第一个元素开始作用; 如果没指定类型，则每种类型符合表达式的第一个元素开始生效.|

### 七、CSS选择器(下): 伪类选择器
* 7-1 `:enable`选择器 与 `:disabled`选择器
    * 在Web的表单中，有些表单元素有可用(":enabled")和不可用(":disabled")状态下，比如输入框、密码框、复选框等.
    * 在默认情况下，这些表单元素都默认为enabled状态

```
/* css */
div { margin: 30px; }

input[type="text"]:enabled {
    border: 1px solid #f36;
    box-shadow: 0 0 5px #f36;
}

input[type="text"]:disbaled {
    box-shadow: none;
}

<!-- html -->
<form acttion="#">
    <div>
        <label for="enabled">可用输入框:</label>
        <input type="text" id="enabled" />
    </div>
    <div>
        <label for="disabled">禁用输入框:</label>
        <input type="text" id="disabled" />
    </div>
</form>
```

* 7-2 `:checked`选择器
    * `选中`, 在表单元素中, 单选(radio)和复选(checkbox)都具有`选中`和`未选中`状态.

* 7-3 `::selection`选择器
    * `鼠标选中文本`的状态为`::selection`
    * ":selection"伪元素是用来匹配`凸显`的文本.
    * 浏览器默认情况下，`用鼠标选择`网页文本是以`深蓝的背景，白色的字体`显示的.

```
/* css */
p::selection { background: orange;}

<!-- html -->
<div class="box">
    <p>鼠标选择该文本的颜色是橘黄色</p>
    <div>鼠标选择是默认颜色是蓝色</div>
</div>
```

* 7-4 `:read-only`选择器
    * 只读选择器，　就是当元素中readonly属性值设为readonly的时候.

* 7-5 `:read-write`选择器
    * `:read-write`选择器刚好与`:read-only`选择器相反，主要用来指定当元素处于`非只读`状态时的样式。

* 7-6 `::before` 和 `::after`
    * 与CSS2中的`:before` 和 `:after`一样
    * 主要用来给元素的前面或后面插入内容
    * 常和`content`配合使用，使用最多的场景是`清除浮动`

```
/* css 清除浮动代码 */
.clearfix::before,
.clearfix::after {
    content: '.';
    display: block;
    height: 0;
    visibility: hidden;
    overflow: hidden;
}
.clearfix:after { clear: both;}
.clearfix {zoom: 1;}
```

```
/* css 在::before和::after添加阴影效果 */
.effect::before, .effect::after {
    content: "";
    position: absolute;
    z-index: -1;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.8);

    /* 通过position:absolute和top,bottom,left,right确定block的大小, 不用width和height, 更灵活 */
    top: 50%;
    bottom: 0;
    left: 10px;
    right: 10px;

    border-radius: 100px 10px;
}
```

### 八、变形与动画(上)
* 8-1 变形--旋转: rotate()
    * Function: 旋转rotate()函数通过指定的角度使元素相对原点进行旋转(二维).
    * Syntax: `tranform: rotate( D deg);`
        * 当 D 为`正值`时，元素相对原点中心`顺时针`旋转;
        * 当 D 为`负值`时, 元素相对原点中心`逆时针`旋转
    * Example:
        * `transform: rotate(-45deg);`

* 8-2 变形--扭曲: skew()
    * Funtcion:
        * 扭曲(`skew()`)函数能够让元素`倾斜显示`.它可以将一个对象以其中心位置绕着X轴和Y轴按照一定的角度倾斜.
        * 这与rotate()函数的旋转不同, rotate()函数只是旋转,而不会改变元素的形状.
        * `skew()`不会旋转，而只会改变元素的形状.
    * Syntax:
        * `skew(x)` 等价于 `skewX(x)`
            * 仅使元素在水平(X轴)方向扭曲变形
        * `skew(x, y)`:
            * 使元素水平(X轴)和垂直(Y轴)方向同时扭曲.
        * `skewY(y)`:
            * 使元素在垂直(Y轴)方向扭曲变形.

* 8-3 变形--缩放: scale()
    * Funtion: 让元素根据`中心原点`对象进行`缩放`.
    * Syntax:
        * `scale(x)` 完全等价于 X(x)`
        * `scale(X, Y)`
            * 使元素水平(X轴)和垂直(Y轴)方向同时缩放
        * `scaleY(y)`
    * `Take Care`:
        * scale()的取值默认的值为1;
        * 当值`0.01~0.99`     --> `缩小`;
        * 当值`>=1.01`时 --> `放大`;

* 8-4 变形--位移: translate()
    * Function: 
        * 可以将元素向指定的方向移动，类似于position中的relative.
        * 可以将元素从原来的位置移动，而不影响X、Y轴上的任何Web组件.
    * Syntax: `值可以为正负`
        * `translate(x)` === `translateX(x)`
        * `translate(x, y)`
        * `translateY(y)`

* 8-5 变形--矩阵: matrix()

* 8-6 变形--原点: transform-origin
    * Function:
        * 在没有重置transform-origin改变元素原点位置的情况下，CSS变形进行的旋转、位移、缩放，扭曲等操作都是以元素自己中心位置进行变形
        * 但很多时候，我们可以通过transform-origin来对元素进行原点位置改变，使元素原点不在元素的中心位置，以达到需要的原点位置。

* 8-7 动画: transition
    * Function:
        * 通过`鼠标点击(click)`、`获得焦点(:focus)`、`被点击`、`对元素任何改变`中触发，并平滑地以动画效果改变CSS的属性值.
    * Steps:
        * `Step 1: 在默认样式中声明元素的元素状态`
        * `Step 2: 声明过渡元素的最终状态，比如悬浮(:hover)状态`
        * `Step 3: 在默认样式中通过添加过渡函数，添加一些不同的样式`
    * Categorie:
        * `transition-property`
        * `transition-duration`
        * `transition-timing-function`
        * `transition-delay`

* 8-7 动画--过渡属性: transition-property
    * Function: 
        * transition-property用来指定过渡动画的CSS属性名称，而这个过渡属性只有具备一个中点值的属性（需要产生动画的属性）才能具备过渡效果
    * Properties:
        * 大部分css属性, 比如 `transition-property: background-color;`

* 8-8 动画--过渡所需时间: transition-duration
    * Function: 主要用来设置一个属性过渡到另一个属性所需要的时间。
        * 一般设置在初始状态上
    * Syntax:
        * `transition-duration: 0.5s;`
        * 单位: 秒(s), 毫秒(ms)

* 8-9 动画--过渡函数: transition-timing-function
    * Function: 
        * 指的是过渡的"缓动函数"，即从初始状态到最终状态.
        * 主要用来指定浏览器的过滤速度，以及过滤期间的操作进展情况.
    * Functions(函数): `从初始状态到最终状态`
        * `ease`: 由快到慢
        * `ease-in`:　加速(渐显效果)
        * `ease-out`: 减速(渐隐效果)
        * `ease-in-out`: 先加速再减速(渐显渐隐)
        * `linear`: 恒速
    * Syntax: 
        * `transition-timing-function: FUNCTION_NAME;`
    * Example:
        * `transition-timing-function: ease-in-out;` /*先加速再减速*/

* 8-10 动画--过渡延迟时间: transition-delay
    * Function:
        * 与`transition-duration`相似, 但是`transition-duration`是用来设置过渡动画的`持续时间`;
        * `transition-delay`主要用来指定`一个动画开始执行时的时间`, 也就是说当改变元素属性值后多长时间开始执行(`延迟时间`).
    * Usage:
        * 有时我们想改变两个或者多个css属性的transition效果时，只要把几个transition的声明串在一起，用逗号（“，”）隔开，然后各自可以有各自不同的延续时间和其时间的速率变换方式。但需要值得注意的一点：第一个时间的值为 transition-duration，第二个为transition-delay。
    * Syntax:
        * `transition-delay: TIME;`
        * 合并: `transition: [PROPERTY] DURATION DELAY, [PROPERTY2] DURATION2 DELAY2;`
    * Example:
        * `transition: width 1s 0.5s, height 5s 3s;`
            * 长度在延迟0.5秒后执行，持续时间1s;
            * 高度在延迟3s后执行, 持续时间5s

### 九、变形与动画(下)
* 9-1 Keyframes介绍
    * Function:
        * `@keyframes`称为关键帧
        * 在一个`@keyframes`中的样式规则可以由多个百分比构成，如在"0%"到"100%"之间创建更多个百分比，分别给每个百分比中给需要有动画效果的元素加上不同样式，从而达到一种在不断变化的效果.
    * Syntax:
        * Step 1: `animation: ANIMATION_NAME DURATION TIMING_FUNCTION DELAY;`
        * Step 2: `@keyframes ANIMATION_NAME { 0%{...}, 20%{...}..., 100%{...}}`

```
/* css */
div {
    width: 300px;
    height: 200px;
    background: red;
    color: #fff;
    margin: 20px auto;
}

div:hover {
    animation: change 5s ease-out 0.2s;
}

@keyframes change {
    0% {
        background: red;
    }

    20% {
        background: orange;
    }

    40% {
        background: yellow;
    }

    60% {
        background: green;
    }

    80% {
        background: blue;
    }

    100% {
        background: purple;
    }
}
```

* 9-2 调用动画: animation-name
    * Function:
        * 用来调用`@keyframes`定义好的动画.
        * 名称必须完全一致，区分大小写.
    * Syntax:
        * `animation-name: none | IDENT[, none | DENT]*`
            * IDENT 指的是你定义的名字
            * none 为默认值，是任何动画失效，可用于`覆盖任何动画`.

* 9-3 设置动画播放时间: animation-duration
    * 类似: transition-duration
    * 完成从0%到100%需要的时间

* 9-4 设置动画播放方式: animation-timing-function
    * 类似: transition-timing-function
    * 多组用逗号(,)分开

* 9-5 设置动画开始播放时间: animation-delay
    * 类似: transition-delay

* 9-6 设置动画播放次数: animation-iteration-count
    * Function: 定义动画播放次数
    * Syntax:
        * `animation-iteration-count: infinite | <number> [, infinite | <number> ... ;]`
            * infinite: 无限循环
            * number 为整数，小数也行.

```
/* css3: animation */
div {
    width: 200px;
    height: 200px;
    border: 1px solid red;
    margin: 20px auto;
}

div span {
    display: inline-block;
    width: 20px;
    height: 20px;
    background: orange;
    border-radius: 100%;
    animation-name: ball-around;
    animation-duration: 10s;
    animation-timing-function: ease;
    animation-delay: 1s;
    animation-iteration-count: infinite; 
}
 
@keyframes ball-around {
    0% {
        transform: translate(0, 0);
    }
    25% {
        transform: translate(180px, 0);
        /* 等价于 transform: translateX(180px); */
    }
    50% {
        transform: translate(180px, 180px);
    }
    75% {
        transform: translate(0, 180px);
    }
    100% {
        transform: translateY(0);
    }
}


<!-- html -->
<div>
    <span></span>
</div>
```


* 9-7 设置动画播放方向: animation-direction
    * Syntax:
        * `animation-direction: normal | alternate [, normal | alternate, ...];`
            * `normal` 是默认值, 也就是动画的每次循环都是向前播放;
            * `alternate`: 动画播放在`第偶次`向前播放, `第奇次`向反方向播放.

* 9-8 设置动画的播放状态: animation-play-state
    * Syntax:
        * `animation-play-state: running | paused;`
            * `running`: 默认值,主要作用是类似音乐播放器，可以通过paused将正在播放的动画停下来，也可以通过running将暂停的动画重新播放.这里的重新播放不一定是从元素动画开始播放,而是从暂停的哪个位置开始播放.另外如果暂停了动画的播放，元素的样式将回到最原始的设置状态.
    * Example:
        * `animation-play-state: paused;` : 页面加载时，动画不播放.

* 9-9 设置动画时间外属性: animation-fill-mode
    * Function: 在动画开始之前和结束之后发生的操作
    * Syntax: `animation-fill-mode: none | forwards | backwords | both;`
        * `node`: 默认, 表示动画预期进行和结束，在动画完成最后一帧时，动画会反转到初始帧;
        * `forwards`: 表示动画在结束后继续应用最后的关键帧的位置;
        * `backwards`: 会在向元素应用动画样式时迅速应用动画的初始帧;
        * `both`: 元素动画同时具有forwards和backwards效果.

* 9-10 制作3D旋转导航练习
