---
layout: post
title: "Linux 开发有用的工具集"
keywords: [""]
description: ""
category: "linux"
tags: [linux, tools, network, server]
---
{% include JB/setup %}

### 一、网络

#### 流量分析

##### HTTP
* 1 [httpry](https://linux.cn/article-4148-1.html)
    * 定义: Linux 命令行下嗅探 HTTP 流量的工具
    * 常用命令:
        * sudo httpry -i DEVICE ＃监听DEVEICE的http流量, DEVICE可以为wlan0, eth0, eno1 等任何网络接口
        * sudo httpry -i DEVICE -m get,head # -m 监听指定的HTTP方法
        * sudo httpry -i DEVICE -o FILE # -o 指定输出文件
        * `sudo httpry -i DEVICE | grep xxx` # 结合管道
        * 其他 httpry -h 获取
* 2 [tcpdump](https://m.oschina.net/blog/212701)
    * 定义: 
    * 常用命令:
        * sudo tcpdump tcp port 80 -n -X -s 0 # http数据包抓取
        * sudo tcpdump tcp port 80 -n -X -s 0 # 抓取htto包数据指定文件进行输出package
        * sudo tcpdump tcp port 80 -n -X -s 0 -l | grep xxx # 结合管道流
        * sudo tcpdump tcp host 10.16.2.85 and port 2100 -s 0 -X # 只监控特定的ip主机
    * 其他选项:
        * -i DEVICE 指定接口
