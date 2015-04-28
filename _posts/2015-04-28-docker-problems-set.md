---
layout: post
title: "docker 问题汇总(持续更新)"
keywords: [""]
description: ""
category: linux
tags: [linux, docker]
---
{% include JB/setup %}

## 1. 非root身份运行Docker
* 你需要将自己添加到docker群组，那样才能以非root用户的身份来运行Docker
* 解决方法:
    * 1. 将当前用户加入docker组: sudo usermod -a -G docker $USER
    * 2. 创建个新docker组用户: sudo useradd --create-home --shell /bin/bash --user-group --groups docker,adm,sudo YOUR_USER_NAME
