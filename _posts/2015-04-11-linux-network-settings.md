---
layout: post
title: "Linux 高级网络配置"
keywords: [""]
description: ""
category: linux
tags: [linux, ubuntu, network]
---
{% include JB/setup %}

## 1. 网卡高级命令
* 1. 查看物理网卡状态:
   * sudo mii-tool eth0
* 2. 查看物理网卡配置:
    * ethtool eth0 查看网卡特性
    * ethtool -i eth0 查看驱动信息
    * ethtool -S eth0 查看网卡状态

## 2. IP 别名
>   Linux 支持在一个物理网卡上配置多个IP地址
> 用来实现类是子接口之类的功能，也就是IP别名

* 1. 禁用网卡管理: (CentOS or RHEL):
    * service NetworkManager stop
    * chkconfig NetworkManager off
* 2. 用IP命令临时创建一个IP别名:
    * ip addr add 10.1.1.1/24 dev eth0 label eth0:0
    * eth0:0中第二个0为别名的编号
    * 第二个别名可以为eth0:1
    * `当然也可以使用ifconfig`
* 3. 永久添加IP别名..

