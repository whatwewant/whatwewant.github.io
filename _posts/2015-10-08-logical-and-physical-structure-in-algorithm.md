---
layout: post
title: "数据结构中的逻辑结构与物理结构"
keywords: [""]
description: ""
category: "algorithm"
tags: ["datastructure", "algorithm", "logical structure", "physical structure"]
---
{% include JB/setup %}

### 一、理解(重点)
* 比如数据结构中的`树`的`存储`
    * `逻辑结构`: 很形象啊，在你脑海里不就是一棵树吗?
    * `物理结构`: 这棵`树`在物理内存中可以用数组存储(`顺序存储`), 也可以在内存中用链表存储(`链式存储`);

### 二、课本原理
* 逻辑结构:
    * 指数据元素之间的逻辑关系;
* 物理结构:
    * 指数据结构在计算机中的表示(又称映像);
* [这里讲的不错，不妨看看](http://blog.csdn.net/zjsjknd/article/details/7203191)

### 三、类型

#### (1)逻辑结构
* 1)集合结构
    * 数据元素之间无序, 例如大圆圈里许多互不相干的小圆圈;
* 2)线性结构
    * 一对一, 例如`数组`;
* 3)树形结构
    * 一对多, 例如数据结构中的`树`;
* 4)图形结构
    * 多对多, 例如数据结构中的`图`;

#### (2)物理结构(又称存储结构)
* 1) 顺序存储
* 2) 链式存储
* `注意: 存储结构与存储方式相区别`:
    * `存取方式`包括顺序存取、随机存取;