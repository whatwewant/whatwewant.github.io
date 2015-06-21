---
layout: post
title: "MySQL (五) 函数和操作符"
keywords: [""]
description: ""
category: SQL
tags: [MySQL, SQL, 数据库]
---
{% include JB/setup %}

## 导航

### 一、操作符
* 1 操作符优先级

|操作符|优先级|
|:-----|:----:|
|BINARY, COLLATE|15|
|!|14|
|-(一元减号), ~(一元比特取反)|13|
|^|12|
|*, /, DIV, %, MOD|11|
|-, +|10|
|<<, >>|9|
|&|8|
|\||7|
|=, <=>, >=, >, <=, <, <>, !=, IS, LIKE, REGEXP, IN|6|
|BETWEEN, CASE,WHEN,THEN,ELSE|5|
|NOT|4|
|&&, AND| 3 |
|\|\|, OR, XOR|2|
|:=|1|
