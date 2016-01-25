---
layout: post
title: "Vsftpd 虚拟用户及其家目录的配置"
keywords: [""]
description: ""
category: ""
tags: [""]
---
{% include JB/setup %}

### 一.OS
* `Ubuntu 14.04`

### 二.Vsftpd Version
* `vsftpd: version 3.0.2`

### 三.准备工作
* 1. 下载VSFTPD: FTP 服务
    * `apt-get install vsftpd`
* 2. 下载[PAM(Pluggable Authentication Module)](http://www.ibm.com/developerworks/cn/linux/l-pam/index.html): 插入验证模块
    * `apt-get install libpam-pwdfile`
* 3. 下载apache2-utils(使用到htpasswd, 密码管理)
    * `apt-get install apache2-utils`

### 四.覆盖VSFTPD配置文件(/etc/vsftpd.conf)
* `注意: 以下全是/etc/vsftpd.conf中的内容`

```
# 监听服务(IPV4), 如果是IPV6, 则应开启listen_ipv6=YES
listen=YES
# 不允许匿名用户登陆, 如果要开启, 则anonymous_enable=YES
anonymous_enable=NO
# 允许本地用户登录, 虚拟用户依赖于待会儿新建的本地用户vsftp
local_enable=YES
# 本地用户写入(上传)权限
write_enable=YES
# 本地用户的umask
local_umask=022
# 本地用户的根目录, 虚拟用户目录配置在下面
local_root=/var/www
# @TODO 不理解, 拥有本地用户权限
chroot_local_user=YES
# @TODO 允许chroot写入
allow_writeable_chroot=YES
# @TODO 隐藏ID ?
hide_ids=YES

#################
#  虚拟用户配置 #
#################
# !important: 用户配置目录
# 要自己新建: mkdir -p /etc/vsftp/users_conf
# 假设已经新建用户, 其用户名为user1
# 那么配置完$user_config_dir, vsftpd服务会去查找$user_config_dir/user1文件
# $user_config_dir/user1 这个文件和/etc/vsftpd.conf一样, 所以你可以在这个目录下重新配置每个用户的家目录
# 例如: 希望设置user1的家目录为: /var/www/web_user1
#   创建目录: mkdir -p /var/www/web_user1 
#   编写配置文件($user_config_dir/user1文件是自己新建的):
#         内容为: local_root=/var/www/web_user1
user_config_dir=/etc/vsftpd/users_conf

# PAM服务的名字， 匹配文件: /etc/pam.d/vsftpd
pam_service_name=vsftpd
# @TODO 没有权限用户
nopriv_user=vsftpd
# @TODO 允许访客登陆 不理解
guest_enable=YES
# 访客用户名
guest_username=vsftpd
# 让虚拟用户使用本地用户的权限
virtual_use_local_privs=YES
```

### 五.虚拟用户创建与配置
* 1. 创建目录/etc/vsftpd,用于存放虚拟用户
    * `mkdir /etc/vsftpd`
* 2. 运用`htpasswd`创建虚拟用户和密码
    * Situation 1: 第一次创建虚拟用户文件(/etc/vsftpd/ftpd.passwd)和虚拟用户(user1)
        * `htpasswd -cd /etc/vsftpd/ftpd.passwd user1`
    * Situation 2: 只是添加新的虚拟用户(user1)
        * `htpasswd -d /etc/vsftpd/ftpd.passwd user1`
    * `Tips: -c 选项会覆盖文件`
* 3. 创建或覆盖文件: /etc/vsftpd/ftpd.passwd, 写入以下两行
    * `auth required pam_pwdfile.so pwdfile /etc/vsftpd/ftpd.passwd`
    * `account required pam_permit.so`
    * `# 注: 这将允许使用/ect/vsftpd/ftpd.passwd中的虚拟用户登陆`
    * `# 并且更重要的是: 禁止本地用户登陆, 比如root等`
* 4. 添加个本地用户给虚拟用户使用, 这些虚拟用户没有权限使用Shell
    * `useradd --home /home/vsftpd --gid nogroup -m --shell /bin/false vsftpd`
* 5. 定义每个虚拟用户的访问目录(或叫权限)
    * 涉及/etc/vsftpd.conf中的user_config_dir变量, 它的值为/etc/vsftpd/users_conf
    * 创建 $user_config_dir 目录
        * `mkdir /etc/vsftpd/users_conf`
    * 其他请参考[四.覆盖VSFTPD配置文件(/etc/vsftpd.conf)](#四.覆盖VSFTPD配置文件(/etc/vsftpd.conf))中的配置

### 六.重启VSFTPD服务
* `service vsftpd restart`

### 七.FAQ
* 1. 如果没用创建 user conf file (虚拟用户配置文件)
    * 默认根目录为: $local_root, 即/var/www
