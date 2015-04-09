---
layout: post
title: "Iptables 基础"
keywords: [""]
description: ""
category: linux
tags: [linux, ubuntu, iptables, command]
---
{% include JB/setup %}

## IPTABLES 命令的基础

### One IPTABLES 规则的基本格式:
> iptables [-t table] command [match] [target/jump]
* 1. table 默认为 filter 表
* 2. 没有人要求target 必须放在 command 后面，但是最好这样。
* 3. match : 细致的描述了包的某个特点,以使这个包区别于其他所有包.这里可以指定包的来源:
    * 1. 来源IP地址
    * 2. 网络接口(-o eth0等)
    * 3. 端口(--sport, --dport)
    * 4. 协议类型(tcp udp icmp ....)
    * 5. 其他
* 4. target: 指定匹配报文的所有动作(ACCEPT, DROP, REDIRECT, CHAIN-NAME等)

### Two IPTABLES tables 表
* 1. -t 选项指明要操作的表, 默认是filter表
* 2. tables:
    * 1. `nat` (3链): 主要用于网络地址转换,即Network Address Translation, 缩写为NAT.:
        * 0. 注意: 属于一个流的包只会经过这个表一次。如果第一个包被允许做NAT或Masqueraded, 那么余下的包会自动地被做相同的动作。也就是余下的包不会再通过nat这个表，一个一个的被NAT, 而是自动完成。`这就是为什么不应该在nat表做任何过滤的主要原因`.
        * 1. `PREROUTING` 链: 主要用于包刚刚到达防火墙时该表它的`目的地址`。`(对远程进来的包)可以重定向访问的地址, 很方便`
        * 2. `OUTPUT` 链: 改变`本地`产生的包的`目的地址`.`全局代理用到,将本机产生的所有包通过OUTPUT表全部转到本地某个端口, 不明白？`
        * 3. `POSTROUTING` 链: 在包就要离开防火墙是改变其`源地址`.
    * 2. `mangle` (5链): 主要用来 mangle 数据包:
        * 0. 可以改变不同的包及包头的内容，如TTL, TOS 或 MARK.注意MARK并没有真正地改动数据包，它只是在内核空间为包设定一个标记.防火墙内的其他规则或程序(如tc)可以使用这中标记对包进行过滤或高级路由.
        * 1. `PREROUTING` 链: 在包进入防火墙之后、路由判断之前改变包.
        * 2. `POSTROUTING` 链: 在所有路由判断之后改变包.
        * 3. `OUTPUT` 链: 在确定包的目的之前更改数据包.
        * 4. `INPUT` 链: 在包被路由到本地之后, 但是在用户空间的程序看到他之前被改变.
        * 5. `FORWARD` 链: 在最初的路由判断之后、最后一次更改包的目的之前 mangle 包.
        * `注意: mangle 表不能做任何NAT, 它只是该表数据包的TTL, TOS 或 MARK, 而不是其源目地址. NAT在nat表中操作.`
    * 3. filter (3链): 用来完成报文的过滤，和其他操作一样，在filter表里可以DROP/记录/ACCEPT/REJECT报文.:
        * 1. `FORWARD` 链: 主要用来处理非本机报文.
        * 2. `INPUT` 链: 处理所有目的地址为本机的报文
        * 3. `OUTPUT` 链: 处理所有本机发送的报文.
    * 4. raw 表 (2链): Raw表和它的链都在netfilter的模块之前，主要用来完成NOTRACK功能.需要kernel大于等于2.6 :
        * 1. `PREROUTING` 链: 用于到本机的所有报文
        * 2. `OUTPUT` 链: 用于本机发送的所有报文

### Three IPTABLES Commands 命令
* 1. -A, --append: 链尾追加规则:
    * iptables -t filter -A INPUT ...
* 2. -D, --delete: 删除某链的规则:
    * 用序号(第1.条是1不是0, 累加): iptables -t filter -D INPUT 1
    * 用完整规则: iptables -D INPUT --dport 80 -j DROP
* 3. -R, --replace: 替换规则:
    * 和-D使用方式类似，但较少使用
* 4. -I, --insert: 插入规则:
    * iptable -I INPUT 1 --dport 80 -j ACCEPT # 在序号1上插入规则
* 5. -L, --list: 列出某链上的所有规则:
    * iptables -L INPUT
    * 如果没有指定链的名称，就列出该表上所有链的所有规则: iptables -L
* 6. -F, --flush: 清空某连上的规则, 也就是删除某链上的所有规则:
    * iptable -F INPUT
    * iptables -F # 没有指定链名，会清空该表上的所有链的所有规则
* 7. -Z, --zero: 清空计数器值:
    * iptables -Z INPUT
    * 同
* 8. -N, --new-chain: 新建用户自定义链:
    * iptables -N allowed
* 9. -X, --delete-chain: 从表上删除指定的链, `删除链前，必须清空链的规则`.
    * iptables -X allowed
    * 只能删除用户自定义的链
* 10. -P, --policy:
