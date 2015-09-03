---
layout: post
title: "如何通过反向SSH隧道访问NAT后面的Linux服务器"
keywords: [""]
description: ""
category: linux
tags: [linux, ssh, nat]
---
{% include JB/setup %}

## [参考整理](https://linux.cn/article-5975-1.html)

## 基本概念

### 一、反向SSH隧道简介
* 1 是什么:
    * 隧道协议(Tunneling protocol):
        * 在当前网络不支持或不提供某种网络服务的情况下，隧道协议允许访问或提供该服务.
    * (正向)SSH隧道:
        * 通过Secure Shell 提供的隧道协议服务
    * 反向SSH隧道:
        * 在本地主机与远程VPS建立SSH隧道的情况下，(通过)远程VPS能够通过它反向访问本地主机.

* 2 前提:
    * 家庭主机没有或没有固定的公网IP(一般运营商不会给的)
    * 一个拥有`公网IP`的`VPS`(中继主机), OS: `Linux`

* 3 步骤:
     * 从家里的Linux主机与公网中的VPS(中继主机)建立`SSH隧道`;
    * 有了这个`隧道`，就可以从VPS上或通过VPS连接`回`家里的Linux主机;

* 4 作用:
    * 在任何地方，连接上家里的Linux主机

### 二、设置反向SSH隧道
* 预设:
    * home: 表示家庭Linux主机
    * vps: 表示拥有公网IP的远程中继主机
* 1 打开一个到中继服务器的SSH连接:
    * `ssh -fN -R 10022:localhost:22 vps_user@1.1.1.1`
        * 10022: 是VPS上没有被占用，被用来反向连接家庭主机的端口, 也就是vps上通过`ssh home_user@127.0.0.1 -p 10022`连接家庭Linux主机
        * localhost: 是绑定远程主机的地址，这项可以当做默认
        * 22: 远程vps的ssh端口
        * vps_user: vps的用户
        * 1.1.1.1: 远程vps的IP地址
        * `-R`: 定义一个反向隧道, `-R [vps_ip:]port:host:host_port`
        * `-N`: 不执行远程命令, 这对转发端口是非常有用的.
        * `-f`: 在成功通过SSH服务器验证时, 在命令执行之前，将ssh请求放到后台运行(守护进程).

* 2 远程VPS状态:
    * `sudo netstate -nap | grep 10022`
        * 确认其127.0.0.1:10022绑定到了sshd.

* 3 从VPS连接到家庭主机:
    * `ssh -p 10022 home_user@127.0.0.1`
        * home_user是家庭主机的用户，密码自然也是。

### 三、通过反向SSH隧道直接链接到网络地址变换后的服务器
* 1 问题:
    * 上面方法允许从VPS访问NAT后面的家庭服务器, 但是需要两次登录: 先登录VPS, 再登录家庭服务器.因为中继服务器(VPS)上SSH隧道的端点绑定到了回环地址(127.0.0.1).现在我想直通过VPS对外开放的端口就可以直接访问家庭服务器(只要一步).

* 2 步骤:
    * 1 指定VPS上运行的ssh的`GatewayPorts`实现
        * 将`GatewayPorts clientspecified` 添加到 `/etc/ssh/sshd_config` (VPS: Ubuntu Server)
    * 2 重启sshd服务
        * Debian系:
            * Upstart: `sudo service ssh restart`
            * Systemd: `sudo sstemctl restart sshd`
        * Red Hat系
            * `sudo systemctl restart sshd`
    * 3 初始化方向隧道, 记得把之前的kill, 否则端口10022被占用
        * `ssh -fN -R 1.1.1.1:10022:localhost:22 vps_user@1.1.1.1`
            * 1.1.1.1 是VPS的公网IP地址
    * 4 在VPS上确认是否建立反向ssh隧道:
        * `sudo netstat -nap | hrep 10022`
    * 5 `现在可以通过VPS对外开放的端口之间访问家庭服务器`:
        * `ssh -p 10022 home_user@1.1.1.1`

### 四、永久反向SSH隧道
* 1 工具:
    * 借助`autossh`自动反向SSH隧道
    * 在执行`autossh`之前，须将ssh public key上传的VPS
        * `ssh-keygen -t rsa`
        * `ssh-copy-id -i ~/.ssh/id_rsa.pub vps_user@vps_ip`

* 2 安装:
    * Debian系: 
        * `sudo apt-get install autossh`
    * Red Hat系: 
        * `sudo yum install autossh`
        * (Fedora) `sudo dnf install autossh`

* 3 配置

```bash
autossh \
    -M 10900 \ # 指定VPS服务器上的见识端口，用于交换监视SSH会话的测试数据, 不能被占用
    -fN \ # 后台运行
    -o "PubkeyAuthentication=yes" \    # 使用秘钥验证，而不是密码验证
    -o "StrictHostKeyChecking=false" \ # 自动接受SSH主机秘钥
    -o "PasswordAuthentication=no" \
    -o "ServerAliveInterval 60" \      # 每60秒交换key-alive消息
    -o "ServerAliveCountMax 3" \       # 没有收到任何响应是最多发送3条keep-alive消息.
    -R $VPS_IP:$VPS_ACCESS_PORT:$FORWARD_IP:$FORWARD_PORT \
    vps_user@1.1.1.1
```

### `五、SOCKS代理公式`
* `ssh -fN -R $VPS_IP:$VPS_ACCESS_PORT:$FORWARD_IP:$FORWARD_PORT $VPS_USER@VPS_IP`
    * $VPS_IP: 就是远程服务器地址
    * $VPS_ACCESS_PORT: 之后你访问的就是$VPS_IP和$VPS_ACCESS_PORT
    * $FORWARD_IP: 要被转发的IP地址, 就是外网无法访问的内网IP等,也可以是本地IP, 如127.0.0.1
    * $FORWARD_IP: 要被转发的端口
    # $VPS_USER: VPS的用户，不需要root权限，它就相当于一个代理人而已
* `注意: 这里一般使用SSH_PUB_KEY, 公钥验证; 这样在配置autossh时就不会出问题了`
* `同样可以应用到autossh`

### 六、端口代理(socks代理)实际案例

#### 案例1: 转发路由器(192.168.1.1)的80端口到远程服务器(123.123.123.123)的12345端口, 远程服务器用户agent
* 目的:
    * 使得直接访问http://123.123.123.123:12345就可以访问路由器Web界面
* 前提:
    * 远程服务器及其用户有效, 路由器存在
* 实际操作:
    * `ssh -fN -R 123.123.123.123:12345:192.168.1.1:80 agent@123.123.123.123`
    * 现在访问http://123.123.123.123:12345试试

#### 案例2: 转发本地内网主机(127.0.0.1)SSH端口(22)到远程服务器(123.123.123.123)的12345端口, 本地主机SSH用户local_ssh_user(本地能连接，sshd服务必须开启), 远程服务器用户agent
* 目的:
    * 使得在任意主机上使用`ssh local_ssh_user@123.123.123.123 -p 12345`就能连接到本地主机(内网主机)SSH服务
* 前提不在赘述
* 实际操作:
    * `ssh -fN -R 123.123.123.123:12345:127.0.0.1:22 agent@123.123.123.123`

#### 案例3: 转发内网主机(10.11.12.13)的1080端口到服务器(123.123.123.123)的54321端口
* 目的:
    * 可以通过访问123.123.123.123的54321端口就能访问内网主机10.11.12.13的1080端口, 具体视情况而定
    * 具体服务如案例1和案例2
* 实际操作:
    * `ssh -fN -R 123.123.123.123:54321:10.11.12.13:1080 agent@123.123.123.123`
