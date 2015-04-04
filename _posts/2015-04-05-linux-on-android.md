---
layout: post
title: adb 简单运用之启动LinuxOnAndroid
category: android
tags: [adb, shell, android, LinuxOnAndroid, Ubuntu]
---
{% include JB/setup %}

## 0. 原因: LinuxOnAndroid
    > 主要是因为自己有架Android手机主板出问题了，屏幕一直花屏，就想拿来玩玩LinuxOnAndroid, 但是屏幕花屏严重，基本看不了，但是偶尔恢复，所以就想从adb shell 来启动LinuxOnAndroid, 我用的是Ubuntu12.04版本, 适合android4.0-4.2, 可以拿来玩服务。。。

## 1. 手机:
    * 1. 打开Debug模式，并用数据线连接电脑
    * 2. 最好确保手机已经root

## 2. Ubuntu 14.04:
    * 1. 将/path/to/sdk/platform-tools加入/etc/profile环境变量,但是必须重启 或者 直接进入/path/to/sdk/platform-tools目录
    * 2. sudo ./adb kill-server

## 3. 可能手机不识别:
    * 1. sudo vim /etc/udev/rules.d/51-android.rules (该文件一般不存在)
    * 2. lsusb 查看:
        * 1. 我的usb: Bus 003 Device 003: ID `0bb4`:`0c03` HTC (High Tech Computer Corp.) 
        * 2. 需要的数据: `0bb4` 和 `0c03`
    * 3. 在/etc/udev/rules.d/51-android.rules 添加:
        * `SUBSYSTEM=="usb", ATTRS{idVendor}==" 0bb4", ATTRS{idProduct}=="0c03",MODE="0666"`
        * sudo chmod a+x /etc/udev/rules.d/51-android.rules
    * 4. 重启udev: sudo /etc/init.d/udev restart
    * 5. 拔掉usb线重新插入
    * 6. 现在大概可以识别手机了
    * 7. sudo ./adb kill-server
    * 8. 连接: sudo ./adb shell # 用sudo, 否则可能出现 insufficient permissions for device 问题

## 4. adb shell 之后:
    * 1. 使用root权限: su # 请确保已经root

## 5. 我今天用adb shell 的目的，运行Linux On Android
    * [项目下载地址](http://sourceforge.jp/projects/sfnet_linuxonandroid/releases/)
    * 下载 [bootscript.sh](http://sourceforge.jp/projects/sfnet_linuxonandroid/downloads/bootscript.sh) 适用于Android4.0, 或 [bootscript4-3.sh](http://sourceforge.jp/projects/sfnet_linuxonandroid/downloads/bootscript4-3.sh)适用于Android4.3以后
    * 将 bootscript.sh 或 bootscript4-3.sh 放到和 ubuntu.img目录下
    * sudo adb shell 进入 (如失败，查看上几步)
    * cd /path/to/ubuntu.img
    * su # 提取root权限
    * sh bootscript.sh 或者 sh bootscript4-3.sh 即可启动 LinuxuOnAndroid

```bash
lsusb 结果:
...
Bus 001 Device 003: ID 0a5c:21e3 Broadcom Corp. HP Portable Valentine
Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 003: ID 0bb4:0c03 HTC (High Tech Computer Corp.) 
Bus 003 Device 002: ID 1bcf:0005 Sunplus Innovation Technology Inc. 
...
```
