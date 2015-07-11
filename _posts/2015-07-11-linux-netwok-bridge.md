---
layout: post
title: "Linux NetWok Bridge(创建网桥)"
keywords: [""]
description: ""
category: ""
tags: [""]
---
{% include JB/setup %}

## [Wiki](https://wiki.archlinux.org/index.php/Network_bridge)

### 一、通过iproute2/ip创建网桥 bridge_name
* 1 网桥创建／删除:
    * 创建:
        * `ip link add name bridge_name type bridge`
    * 删除:
        * `ip link delete bridge_name type bridge`
* 2 IP网段:
    * 设置:
        * `ip addr add 172.20.1.1/80 dev bridge_name`
    * 删除:
        * `ip addr del 172.20.1.1/80 dev bridge_name`
* 3 启动/关闭网桥:
    * 启动: `ip link set bridge_name up`
    * 关闭: `ip link set bridge_name down`

### 二、实际案例: 虚拟机Vbox中UbuntuServer14.10桥接新建的网桥bridge_name
* 1 虚拟机网络选择适配器(Adapter):
    * Bridged Adapter(桥接) -> bridge_name -> Cable Connected
* 2 Ubuntu 设置:
    * 临时配置
        * IP: `ifconfig eth0 172.20.1.2 netmask 255.255.255.0`
        * Gateway: `route add default gw 172.20.1.1`
* 3 现在`主机可以通过172.10.1.1访问UbuntuServer`了

### 三、网桥联网
