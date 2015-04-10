---
layout: post
title: "LVM: Logical Volume Manager"
keywords: [""]
description: ""
category: linux
tags: [linux, lvm, filesystem]
---
{% include JB/setup %}

## LVM: 逻辑卷管理

### 1. 概念
|缩写|全称|中文|
|:---|:---|:---|
|PE|Physical Extend|物理扩展|
|PV|Physical Volume|物理卷|
|VG|Volume Group|卷组|
|LV|Logical Volume|逻辑卷|

### 2. 顺序 or 层次
|Module|Direction|Module|
|:----:|:-------:|:----:|
|PV|<----|PE|
|向下组成||向下组成|
|VG|<----|PE Pool|
|向下组成||向下组成|
|LV|<----|PE|

### 3. 顺序创建
* 1. 将物理磁盘设备初始化为物理卷:
    * 创建: pvcreate /dev/sda /dev/sdb
    * 查看状态: pvs 查看简单信息; pvdisplay 查看详细信息
* 2. 创建卷组, 将PV加入卷组中:
    * 创建: vgcreate vgName /dev/sda /dev/sdb
    * 查看状态：　vgs vgdisplay
    * 位置: /dev/vgName
* 3. 基于卷组创建逻辑卷:
    * 创建: lvcreate -n lvName -L 2G vgName
    * 查看状态: lvs lvdisplay
    * 位置: /dev/vgName/lvName
* 4. 格式化文件系统:
    * mkfs.ext4 /dev/vgName/lvName
* 5. 挂在文件系统:
    * mount /dev/vgName/lvName /mnt
* 6. 查看挂载文件系统状态:
    * mount
    * df -m

### 4. 顺序删除
* 1. 卸载逻辑卷: umount /mnt
* 2. 移除逻辑卷: lvremove /dev/vgName/lvName
* 3. 移除卷组(前提: 必须移除所有lv才行): vgremove /dev/vgName
* 4. 移除物理卷: pvremove /dev/sda /dev/sdb

### 5. 拉伸一个逻辑卷
* 1. 保证VG有足够的空闲空间, vgdisplay
* 2. 扩充逻辑卷:
    * lvextend -L +1G /dev/vgName/lvName
    * 为lvName逻辑卷增加1G扩展空间
* 3. 查看扩充后LV大小, lvdisplay
* 4. 更新文件系统，才能让系统知道(df 前后可知):
    * resize2fs /dev/vgName/lvName
* 5. 查看新的文件系统: df -h

### 6. 拉伸一个卷组
* 1. 将要添加到VG的硬盘格式化为PV:
    * pvcreate /dev/sdd
* 2. 将新的PV添加到指定卷组:
    * vgextend vgName /dev/sdd
* 3. 查看VG大小 vgdisplay

### 7. 缩小一个逻辑卷
* 1. 卸载已经挂载的文件系统:
    * umount /dev/vgName/lvName
* 2. 缩小文件系统:
    * resize2fs /dev/vgName/lvName 1G
    * 将文件系统缩小到 1G
* 3. 缩小LV:
    * lvreduce -L -1G /dev/vgName/lvName
    * 将lvName逻辑卷减小 1G 大小
* 4. lvdisplay
* 5. 挂载文件系统:
    * mount /dev/vgName/lvName /mnt

### 8. 缩小卷组
* 1. 将一个pv从指定卷组中移除:
    * vgreduce vgName /dev/sdd
* 2. 查看 vgdisplay
* 3, 移除物理卷:
    * pvremove /dev/sdd
