---
layout: post
title: "CSS 布局解决浮动问题"
keywords: [""]
description: ""
category: FrontEnd
tags: ["CSS", 'web-front']
---
{% include JB/setup %}

### 一、问题(Question):
* 浮动脱离文档流，导致无法撑开DIV解决:

### 二、解决办法(Solution):
* 在父DIV中加入
    * 1 声明该DIV的伪类选择器divName::after (divName只是标识，泛指能找到DIV的选择器名)
    * 2 必须是block
    * 3 高度必须为0
    * 4 内容随意，但必须有
    * 5 清楚两边浮动: clear: both
    * 6 overflow: hidden;

### 三、CSS　实现代码(Implement Code)

```
    divName::after `{
        display: block;
        height: 0;
        content: "0";
        clear: both;
        overflow: hidden;
    }`
```
