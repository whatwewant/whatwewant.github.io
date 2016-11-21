---
layout: post
title: "SVG 入门和进阶"
keywords: [svg,front-end]
description: ""
category: "front-end"
tags: [svg,front-end]
---
{% include JB/setup %}

## SVG基础

### 一、定义与优势: `SVG` - `Scalable Vector Graphics`
* 定义
  * 1 可伸缩矢量图
  * 2 使用XML格式定义图形
  * 3 W3C的标准
* 优势
  * 容易修改
  * 比JPEG和GIF小，可读性强
  * 矢量，即在任何分辨率下都不会模糊，高清

### 二、基本使用

```
// 1. 文件后缀必须为.svg
// 2. 栗子: 矩形
<svg width="100%" height="100%" version="1.1" xmlns="http://www.w3.org/2000/svg">
  <rect width="100" height="100" stroke="black" stroke-wdith="2" fill="red" />
</svg>
```

### 三、基础Shape和Style属性

* 1 Common Style Attributes -- `既可以独立使用(fill="red")，也可以写在style里(style="fill:red")`
  * `x` -- 到浏览器左侧距离(Default: 0, 指0px)
  * `y` -- 到浏览器右侧距离(Default: 0)
  * `width` -- 宽
  * `height` -- 高
  * `fill` -- 填充颜色(Default: #000)
  * `fill-opacity` -- 填充颜色透明度(取值和opacity一样)
  * `stroke` -- 线颜色(Default: #FFF)
  * `stroke-width` -- 线宽(Default: 1, 主要这里1指1px, 大部分都是这样)
  * `stroke-opacity` -- 线透明度
  * `filter` -- 滤镜(Advanced)
  * `style` -- 同DOM的style, 并且可以将以上搜集在一起

* 2 Shape 与 特有属性
  * 1 `rect` -- 矩形
    * `rx` + `ry`: 使矩形产生圆角
  * 2 `circle` -- 圆形
    * `cx` + `cy`: 圆心坐标
    * `r`: 圆半径
  * 3 `ellipse` -- 椭圆
    * `cx` + `cy`: 椭圆圆心坐标
    * `rx` + `ry`: 椭圆水平、垂直半径
  * 4 `line` -- 线
    * `x1` + `y1`: 起点坐标
    * `x2` + `y2`: 终点坐标
  * 5 `polyline` -- 折线
  * 6 `ploygon` -- 多边形(不少于三条边的图形)
    * `points`: 点集, 其中点(x,y)与点(m,n)之间用空格分隔
  * 7 `path` -- 路径
    * `d`: 数据(data), 一下是数据中的指令
      * 1 `M` -- moveTo(`M x,y`): 将画笔移动到指定的坐标位置
      * 2 `L` -- lineTo(`L x,y`): 画直线到指定的坐标位置
      * 3 `H` -- Horizontal lineTo(`H X`): 画水平线到指定的X坐标位置
      * 4 `V` -- Vertical lineTo(`V Y`): 画垂直线到指定的Y坐标位置
      * 5 `C` -- curveTo(`C X1,Y1,X2,Y2,ENDX,ENDY`): 三次Belzier曲线 
      * 6 `S` -- smooth curveTo(`S X2,Y2,ENDX,ENDY`)
      * 7 `Q` -- qiadratic Belzier curve(`Q X,Y,ENDX,ENDY`): 二次Belzier曲线
      * 8 `T` -- smootg quadratic Belzier curveTo(`T ENDX,ENDY`): 映射
      * 9 `A` -- elliptical Arc(`A RX,RY,XRotation,Flag1,Flag2,X,Y`): 弧线
      * 10 `Z` -- closepath: 关闭路径

```js
// 栗子: Path
//  内容: 首先移动到点(0,0) -- moveTo(0,0)，然后画线到(0, 100) -- lineTo(0, 100), stroke颜色是red
//  注意: stroke的颜色默认为#fff，不手动赋值会是白色一片
<svg
  xmlns="http://www.w3c.org/2000/svg"
  version="1.1">
  <path 
    d="M0,0L0,100"
    style="stroke:red">
</svg>
```

### 三、`滤镜(Filter)` -- in `<defs>`
* 1 效果分类
  * 1 `feBlend` -- 与图像结合的滤镜
  * 2 `feColorMatrix` -- 用于彩色滤光片转换
  * 3 `feComponentTransfer`
  * 4 `feComposite`
  * 5 `feConvolveMatrix`
  * 6 `feDiffuseLighting`
  * 7 `feDisplacementMap`
  * 8 `feFlood`
  * 9 `feGaussianBlur` -- `高斯模糊`
    * `in`: SourceGraphic定义了由整个图像创建效果
    * `stdDeviation`: 定义模糊程度
  * 10 `feImage`
  * 11 `feMerge`
  * 12 `feMorphology`
  * 13 `feOffset` -- 过来阴影
  * 14 `feSpecularLighting`
  * 15 `feTile`
  * 16 `feTurbulence`
  * 17 `feDistantLight` -- 过滤照明
  * 18 `fePointLight` -- 过滤照明
  * 19 `feSpotLight` -- 过滤照明
* 2 定义
  * 必须在`<defs>`标签中定义, defs是definitions的缩写
  * 必须指定需要滤镜的图像`id`, 其中在图形中定义id: `filter=url(#ID)`, 如`<rect ... filter="url(#ID)">` 或者 `<rect ... style="...;filter=url(#ID)">`

```js
// 栗子: 高斯模糊
//  内容: <defs>中定义<filter>, id为Gaussian_Blur, 并在图形中使用style="filter:url(#Gaussian_blur)"
<svg 
  version="1.1"
  xmlns="http://www.w3.org/2000/svg"
  style="width:100%;height:100%;">
  
  <defs>
    <filter id="Gaussian_Blur">
      <feGaussianBlur in="SourceGraphic" stdDeviation="20" />
    </filter>
  </defs>

  <ellipse cs="200" cy="150" rx="70" ry="40"
    style="fill:#ff0; stroke:#000; stroke-width:2, filter:url(#Gaussian_Blur);"/>

</svg>
```

### 四、`渐变(Gradient)` -- in `<defs>`
* 1 定义
  * 一种颜色到另一种颜色平滑过渡
  * 另，可以把多个过渡颜色应用到同一个元素上
* 2 分类
  * 1 `线性渐变(linearGradient)`
    * 类型
      * 1 `水平渐变`: Y同, X不
      * 2 `垂直渐变`: X同, Y不
      * 3 `斜渐变`: X、Y均不同
    * 属性
      * id: 需要渐变的图形
      * x1 + y1: 起点(百分比)
      * x2 + y2: 终点(百分比)
      * stop -- 子元素，其属性: offset, stop-opacity, stop-color, style等
  * 2 `放射渐变(radialGradient)`
    * cx + cy + r: 外圆渐变的范围(cx+cy: 可百分比或者像素)和半径(r)
    * fx + fy: 内圆颜色渐变的范围(可百分比或者像素)
    * stop: 颜色标签

```js
// One 线性渐变 -- Path矩形垂直渐变
// Two 放射渐变 -- Path矩形放射渐变

<svg
  xmlns="http://www.w3.org/2000/svg"
  version="1.1">
  <path 
    d="M0,0L0,100L100,100L100,0Z" 
    style="stroke:red;fill:url(#linearG)" />

  <defs>

    <linearGradient 
      id="linearG"
      x1="0%" y1="0%"
      x2="100%" y2="0%">
      <stop offset="0%" stop-color="red" />
      <stop offset="100%" stop-color="yellow" />
    </linearGradient>
  
    <radialGradient
      id="radialG"
      cx="50%" cy="50%" r="50%"
      fx="50%" fy="50%">
      <stop offset="0%" stop-color="red" />
      <stop offset="100%" stop-color="yellow" />
    </radialGradient>
  </defs>
</svg>
```

### 五、`SVG图形组<g>`
* 定义:
  * 将图形分组，便于统一操作
* 功能
  * `<g>`标签用来创建分组
  * 属性继承
  * transform属性定义坐标变换
  * 可以嵌套
  * 元素属性可以在`<g>`中定义一次就行, 如fill,stroke,stroke-wdith等
* 注意
  * 可以在`<defs>`中定义`<g>`，并赋予id, 在其他`<g>`或者坐标中用`<use xlink="#ID">`使用


## SVG 进阶

### 六、坐标系统 -- 使用 transform 观察
* 1 视野(viewbox)的概念
* 2 分组的概念(<g>)
* 3 四个坐标
  * 1 用户坐标系(User Coordinate)
    * 世界的坐标系
  * 2 自身坐标系(Current Coordinate)
    * 每个图形元素或者分组独立与生俱来
  * 3 前驱坐标系(Previous Coordinate)
    * 父容器的坐标系
  * 4 参考坐标系(Reference Coordinate)
    * 使用其他坐标系来考究自身的情况时使用
* 4 坐标变换
  * 线性变换 -- (MD: 高数和图形变换都还给老师了)
    * transform属性
      * 前驱坐标系: 父容器的坐标系
      * transform属性: 定义前驱坐标系到自身坐标系的线性变换
      * 语法: rotate(deg) / translate(x, y) / scale(sx, sy) / matrix(a, b, c, d, e, f)

### 七、RGB与HSL
* 基础
  * RGB: 用Red, Green, Blue分量来表示颜色
    * 格式: rgb(r, g, b) 或者 #rrggbb
    * 取值: 0-255
    * 优劣: 容易显示器解析，但不符合人类描述颜色的习惯
  * HSL: 用`颜色(Hue)`、`饱和度(Saturation)`、`亮度(Lightness)`来表示
    * 格式: `hsl(h, s%, l%)`
    * 取值范围
      * `h: [0, 359]`
      * `s, l: [0, 100]`
    * 优势符合人类描述颜色的习惯
