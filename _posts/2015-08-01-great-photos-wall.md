---
layout: post
title: "Great Photos Wall"
keywords: [""]
description: ""
category: 前端
tags: [css, css3]
---
{% include JB/setup %}

### 一、知识点
* 1 `box-shadow`:
    * Function: 给元素边框添加阴影效果
    * Syntax: `box-shadow: offset-x offset-y blur-radius [spread-radius] color [inset];`
        * offset-x: X轴偏移量
        * offset-y: Y轴偏移量
        * blur-radius: 阴影模糊半径
        * spread-radius: 阴影扩展半径
        * color: 阴影颜色
        * inset | outset: 投影方式, 内阴影 | (默认)外阴影

* 2 `position`:
    * Function: 给元素定位，主要用到绝对定位absolute
    * Syntax: `position: keyword-value;`
        * Keyword Values: static(default) | relative | absolute | fixed | sticky | inherit | initial | unset;
    * how-to:
        * `position:absolute 和 position:relative 配合使用实现相对于包含元素(参照元素)定位`

* 3 `z-index`:
    * Function: 设置元素的上下层显示顺序
    * Syntax: `z-index: INTEGER;`
        * INTEGER(整数)越大，显示越上层，可以为负数

* 4 `transform`:
    * Function: 使元素变形的属性, 其配合`rotate(旋转)`、`scale(缩放)`、`skew(扭曲)`等参数一起使用
    * Syntax:
        * `transform: rotate(旋转角度);`
        * `transform: scale(缩放倍数);`
        * `transform: rotate(旋转角度) scale(缩放倍数);` // 旋转并缩放

* 5 `transition`:
    * Function: 设置元素由样式1变化到样式2的过程所需要的时间
    * Syntax: `transition: duration;`

### 二、制作步骤
* 1 每张照片的`位置`不一样
* 2 每张照片有一定的`旋转角度(transform:rotate(?deg))`
* 3 照片`阴影(box-shadow)`及`缓慢(transition)旋转(transform:rotate)`、`缓慢(transsition)放大(transfrom:scale)`特效制作

### 三、实现

```
.container {
    padding: 0;
    margin: 60px auto;
    width: 960px;
    height: 450px;
    position: relative;
}

/* 公共初始属性 */
img {
    padding: 10px 10px 15px;
    background: #fff;
    border: 1px solid #ddd;
    
    position: absolute; /*绝对定位, left, right, top, bottom*/
   
    /* 兼容性, 从初始状态到鼠标移上状态的时间 */
    -webkit-transition: 500ms;
    -moz-transition: 500ms;
    -ms-transition: 500ms;
    -o-transition: 500ms;
    transition: 500ms;

    width: 200px;
    height: 300px;
}

/* 公共鼠标移上属性 */
img:hover {
    /* 将图片旋转为0度 */
    tranform: rotate(0deg);
    -webkit-transform: rotate(0deg);
    -moz-transform: rotate(0deg);
    -o-transform: rotate(0deg);

    /*将图片缩放为原来的1.2倍 */
    -webkit-transform: scale(1.2);
    -moz-transform: scale(1.2);
    -ms-transform: scale(1.2);
    -o-transform: scale(1.2);
    transform: scale(1.2);

    /* 图片阴影 */
    -webkit-box-shadow: 10px 10px 15px #ccc;
    -moz-box-shadow: 10px 10px 15px #ccc;
    box-shadow: 10px 10px 15px #ccc;
    z-index: 2;
}

/* 图片特性 */
.img-1 {
    /* 绝对定位设置的属性: left, right, top, bottom */
    top: 0px;
    left: 200px;

    /* 初始状态旋转角度 */
    transform: rotate(20deg);
    -webkit-transform: rotate(20deg);
    -moz-transform: rotate(20deg);
    -o-transform: rotate(20deg);
}
```

### 四、Daemon和源码
* [Daemon]({{ site.url }}/work/photowall)
* [源码](https://github.com/whatwewant/PhotoWall)
