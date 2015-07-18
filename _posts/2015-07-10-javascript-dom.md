---
layout: post
title: "javascript dom"
keywords: [""]
description: ""
category: ""
tags: [""]
---
{% include JB/setup %}

### 一、DOM 基础
* 1 window基本方法:
    * `history` 对象
        * `back()`
        * `forward()`
        * `go()`
    * `location` 对象
        * `href`: 用于实现跳转
        * `reload`
* 2 document
    * 基本方法:
        * `getElementById()`
        * `getElemenstByTagName()`
        * `getElementsByName()`
        * `getElementsByClassName()`
        * `setAttribute(attr, value)` // 一级DOM
            * attr: 选择器的属性，value: 属性取值
        * `write()`: 想文档写。。。
    * 基本属性:
        * `referrer`: 返回载入当前文档的URL
        * `URL`: 返回当前文档的URL

* 3 DOM 对象属性:
    * `style`: // 也就是 CSS 属性
        * `visibility` : visible | hidden
        * `display` : none | block | inline-block | inline
        * ...
    * `name`
    * `href`
    * `data-*`
    * ...

### 二、DOM基础二
* 1 查看节点Node
    * 1 访问指定节点的方法:
        * `getElementById` `getElemenstByTagName` `getElemenstByTagName`
    * 2 查看和修改属性节点: // DOM Level 1
        * `getAttribute(attrName)`
        * `setAttribute(attrName, attrValue)`

* 1.1 节点关系:
    * `node.parentNode`
    * `node.childNodes`
    * `node.firstChild`
    * `node.lastChild`

* 2 创建和增加节点Node
    * `createElement(nodeName)`: Create An Node named nodeName
    * `appendChild(node)`: 末尾追加节点
    * `insertBefore(newChild, refChild)`: 在指定节点refNode前插入新节点newNode
    * `cloneNode([boolean] deep)`: Clone Node

* 3 删除和替换节点Node
    * `removeChild(node)`
    * `replaceChild(newChild, refChild)`

* 4 节点属性和方法:
    * 方法:
        * `onclick`
        * `onmouseover` `onmouseout` `onmousedown`
        * `onkeydown` `onkeyup`

* 5 document.documentElement 对象
    * `scrollTop`
        * 设置或获取位于对象最顶端和窗口中可见内容最顶端之间的距离
    * `scrollLeft`
    * `clientWidth`
        * 浏览器可见内容的高度，不包括滚动条等边线，会随窗口的显示大小改变
    * `clientHeight`
    * `clientHeight`

* 6 表单验证技术:
    * 表单提交
        * `onsubmit` 事件
    * 文本框对象属性、方法、事件
        * 事件:
            * `onblur` : 失去焦点，当光标离开某个文本框时触发o
            * `onfocus`: 获得焦点, ......进入...
            * `onkeypress`: 按下键盘键
        * 方法:
            * `blur()`: 从文本域中移开焦点
            * `focus()`: 在文本域中设置焦点，即获得鼠标光标
            * `select()`: 选取文本域中的内容
        * 属性:
            * `id`: 设置或返回文本域的ID
            * `value`: 设置或返回文本域value属性的值

* 7 `正则表达式` 和 表单辅助特效
    * Syntax:
        * `var reg = /expression/附加参数`
            * Ex1: var reg = /^\w+$/;
            * Ex2: var reg = /^w+$/g;
        * `构造函数: var reg = new RegExp("expression");`
            * Ex1: var reg = new RegExp("^w+@\w+.[a-zA-Z]{2,3}(.[a-zA-Z]{2,3})?$");
            * Ex2: var reg = new RegExp("white", "g");
    * RegExp对象的方法:
        * `exec`: 
        * `test`: 检索字符串中指定的值，返回true或false
