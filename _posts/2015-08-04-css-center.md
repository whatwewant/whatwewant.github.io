---
layout: post
title: "CSS 中的居中"
keywords: [""]
description: ""
category: FrontEnd
tags: [CSS]
---
{% include JB/setup %}

### 一、文本(字)水平居中
    * Condition: 
        * 文本、图片、或者强制行级元素等`行内(inline, inline-block)元素`
    * Object:
        * 给要居中元素的父类元素添加
    * Code: 
        * `text-align:center`

### 二、定框块级元素水平居中:(block and width)
    * Condition:
        * Block 并且 width确定(不论px还是百分比)
    * Object:
        * 给要居中的元素本身添加
    * Code:
        * `margin: 0 auto;`

### 三、不定宽块状元素水平居中:
    * Code 1 (个人感觉不美观):
        * `postion: relative; left: 50%;`
    * Code 2 (转换为第一种情况):
        * `display: inline;`
        * 父元素: `text-align: center`

### 四、文本元素垂直居中:
    * Condition:
        * 父元素高度确定的单行文本
    * Object:
        * 容纳文字的元素也可说(DOM)文本元素的父元素
    * Code:
        * `height: 100px; line-height: 100px;`
        * `只要设置line-height与height一致`

### 五、块级元素垂直居中:
    * Condition:
        * Block
    * Object:
        * 要垂直居中元素的父元素
    * Code:
        * `display: table-cell; vertical-align: middle;/*只有display为table-cell时才会激活vertical-align属性*/`

### 六、跑题一下:
    * `block` `inline-block` `inline`的区别
        * `inline`: 没有height和width
        * `inline-block`: 有height, 没有width
        * `block`: 有height和width
