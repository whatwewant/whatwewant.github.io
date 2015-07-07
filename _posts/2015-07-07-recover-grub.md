---
layout: post
title: "恢复 Grub 引导"
keywords: [""]
description: ""
category: "linux"
tags: [linux, grub, ubuntu]
---
{% include JB/setup %}

## 问题描述:
* 原本多系统(Win + Linuxs)，但windows坏了，要重装，但想保留Ubuntu等
* 安装完Win8后, Grub没了，想要恢复Grub引导

## 方法(推荐): LiveCD 进入(大部分Linux发行版都行)
* 步骤:
    * 1 查看系统分区(一般是sda, 由于多系统, 找到其中一个linux根目录所在的分区/sda/sdaX)
        * `sudo fdisk -l` : 
        * 这里假设: Ubuntu 分区为 /dev/sda6
    * 2 将根分区/dev/sd6挂载到/mnt
        * `mount /mnt /dev/sda6`
    * 3 如果没给/boot单独分区，不需要挂载
        `mount /mnt/boot /dev/sda5`: 
    * 4 安装Grub引导到/dev/sda `注意: /dev/sda是这整个磁盘, 不是某个分区`
        *`grub-install --root-directory=/mnt /dev/sda`
    * 5 绑定LiveCD的一些东西:
        * `mount --bind /proc /mnt/proc`: 
        * `mount --bind /dev /mnt/dev`
        * `mount --bind /sys /mnt/sys`
    * 6 用Chroot方式进入原系统, 并更新grub, 是grub引导生效:
        * `chroot /mnt /bin/bash`
        * `update-grub`
        * `提示`: `现在是以root方式进入原系统，忘记密码可以以这种方式修改密码.`
    * 7 退出Chroot, 重启系统即可:
        * `exit` Or `Ctrl + D`
        * 谨慎点, 卸载刚才绑定的分区:
            * `umount /dev/sys`
            * `umount /dev/dev`
            * `umount /dev/proc`
        * `reboot`
    * 8 恭喜，修复Grub

## [懒人脚本]({{site.url}}/scripts/recover_grub.sh)
