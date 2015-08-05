---
layout: post
title: "css3 getting started"
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

### 六、CSS3选择器(上)
* 6-1 属性选择器

* 6-2 结构性伪类选择器- root

* 6-3 结构性伪类选择器- not

* 6-4 结构性伪类选择器- empty

* 6-5 结构性伪类选择器- target

* 6-6 结构性伪类选择器- first-child

* 6-7 结构性伪类选择器- last-child

* 6-8 结构性伪类选择器- nth-child(n)

* 6-9 结构性伪类选择器- nth-last-child(n)

* 6-10 first-of-type 选择器

* 6-11 nth-of-type(n) 选择器

* 6-12 last-of-type 选择器

* 6-13 nth-last-of-type(n) 选择器

* 6-14 only-child 选择器

* 6-15 only-of-type 选择器
