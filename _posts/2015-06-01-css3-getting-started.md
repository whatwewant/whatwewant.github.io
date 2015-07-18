---
layout: post
title: "css3 getting started"
keywords: [""]
description: ""
category: 前端
tags: [css, css3]
---
{% include JB/setup %}

### 1 开始:
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

* 2.3 
