---
layout: post
title: 为 ubuntu 14.04 上4.0 kernel
category: linux
tags: [linux, ubuntu, ubuntu14.04, kernel]
---
{% include JB/setup %}

## 原因:
    * 内核太老，强迫症，想换内核，但是又不想自己编译，毕竟对内核不了解，并且编译过程中有各种问题...所以，就从官方已经编译打包好的包来安装...

### 1. 下载 需要的 image, header等文件(3个):
    * [linux-headers-4.0.0-040000rc7_4.0.0-040000rc7.201504061936_all.deb](http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.0-rc7-vivid/linux-headers-4.0.0-040000rc7_4.0.0-040000rc7.201504061936_all.deb)
    * [linux-headers-4.0.0-040000rc7-generic_4.0.0-040000rc7.201504061936_amd64.deb](http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.0-rc7-vivid/linux-headers-4.0.0-040000rc7-generic_4.0.0-040000rc7.201504061936_amd64.deb)
    * [linux-image-4.0.0-040000rc7-generic_4.0.0-040000rc7.201504061936_amd64.deb](http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.0-rc7-vivid/linux-image-4.0.0-040000rc7-generic_4.0.0-040000rc7.201504061936_amd64.deb)

### 2. 安装
    * sudo dpkg -i linux-*  // 也就是这三个deb包

### 3. 更新启动项，理论上在上一步会自动更新:
    * sudo update-grub
