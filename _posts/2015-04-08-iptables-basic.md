---
layout: post
title: "Iptables 基础"
keywords: [""]
description: ""
category: linux
tags: [linux, ubuntu, iptables, command]
---
{% include JB/setup %}

## 1. IPTABLES 命令的基础

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
* 10. -P, --policy: 为链配置默认的target(值为ACCEPT或DROP), 这个target称为策略:
    * iptables -P INPUT DROP
    * 默认使用这个target(策略), 只有符合特定规则的采用特定方式.
    * 只有内建的链才可以使用规则.但内建的链和用户自定义的链都不能用作策略
    * 不允许: iptables -P INPUT allowed
* 11. -E, --rename-chain:为链重命名:
    * iptables -E ChainOldName ChainNewName

### Four IPTABLES OPTIONS (选项)
* 1. iptables -Lv
  * Option: -v, --version
  * Commands: --list, --append, --insert, --delete, --replace
  * Such as: iptables -Lv
  * Explanation:
      * 
* 2. iptables -Lx :
    * Option: -x, --exact # 将输出中的计数器显示准确的数字，必须和--list连用
    * Commands: -L, --list
    * Explanation:
        * 
* 3. iptables -Ln or iptables -Lvn:
    * Option: -n, --numeric # 使输出的IP地址和端口以数值的形式显示, 而不是默认名字，如主机名，网络名，程序名等
    * Commands: -L, --list
    * Explanation:
* 4. iptables -L --line-numbers:
    * Option: --line-numbers # 显示规则的行号
    * Commands: -L, --list # 列出规则
    * Explanation:
* 5. iptables -I INPUT -c 20 4000:
    * Option: -c, --set-counters # 设置字节或者报文的计数值
    * Commands: -I, -A, -R
    * Explanation
* 6. ...:
    * Option: --modprobe # iptables 探测并装在要使用的模块.
    * Commands: All
    * Explanation:

## 2. IPTABLES 的匹配(matches)

### One. 通用匹配: 可以在任何规则里
* 1. Match: -p, --protocol : 主要用来检查特定协议(TCP/UDP/ICMP等)
    * Example: iptables -A INPUT -p tcp
    * 1. 指定协议的名称，必须在/etc/protocols里面定义，否则报错
    * 2. 可以指定一个整数值, 例如ICMP是1, TCP是6, UDP是17
    * 3. 另外，可以指定为ALL, ALL表示仅匹配ICMP/TCP/UDP协议，这个是默认配置,数值为0:
        * iptables -A INPUT -p all -j ACCEPT
* 2. Match: -s, --src, --source : 主要用来匹配报文的源地址,单个IP或IP地址段(一个主机或一个网络):
    * Example: iptables -A INPUT -s 192.168.1.1
    * 1. 单个地址: -s 192.168.1.1
    * 2. 一个网络: -s 192.168.0.0/24
    * 3. 缺省表示所有地址
* 3. Match: -d, --dst, --destination: 匹配报文的目的地址, 用法和源地址一致
* 4. Match: -i, --in-interface : 以包进入本地所使用的网络接口来匹配包.`注意:只能用于INPUT, FORWARD, PREROUTING链.`
    * Example: iptables -A INPUT -i eth0
    * 1. 指定接口名称
    * 2. 使用通配符, 即英文加号, 表示匹配所有包, 不考虑来自哪个接口, 这是不指定接口的默认行为:
        * iptables -I INPUT -i +
* 5. Match: -o, --out-interface: 以包离开本地所使用的网络接口的匹配包, 和 -i 一样
* 6. Match: -f, --fragment : ....
* 集合例子: iptables -t nat -A OUTPUT -s 10.1.0.0/24 -d 111.112.113.114 -p tcp -j ACCEPT

### Two. 只能用于TCP的TCP matches
* 1. Match: --sport, --source-port : 基于TCP包的源端口来匹配包:
    * Example: iptables -A INPUT -p tcp --sport 22
    * 1. 不指定此项，暗指所有端口.
    * 2. 使用服务名或端口号, 但名字必须在/ect/services中定义, 因为iptables从这个文件查找想要的端口号.
    * 3. 可以使用连续的端口: -p tcp --sport 22:80, 从22到80的所有端口, 包括22和80
    * 4. 连续端口可以省略第一个端口号，即从0号端口开始: -p tcp --sport :80
    * 5. 连续端口省略第二个端口号,即到65535端口为止: -p tcp --sport 22:
* 2. Match: --dport, --destination-port: 目的端口, 和--sport用法一样
* 3. Match: --tcp-flags :　匹配指定的TCP标记:
    * Example: iptables -A INPUT -p tcp --tcp-flag SYN,FIN,ACK SYN
    * 有两个参数，它们都是列表(以,隔开), 这两个列表以空格隔开
    * 第一个参数指定要检查的标记; 第二个标记指定"在第一个列表中出现过且必须被设为1(即状态打开)"的标记(第一个表的其他标记必须置零).
    * 也就是，第一个参数提供检查范围，第二个参数提供被设置的条件(即哪些可以置1)
    * 标记有: SYN, ACK, FIN, RST, URG, PSH, 还有ALL和NONE
    * 1. 表示匹配哪些SYN标记被设置而FIN和ACK标记没有设置的包: iptables -p tcp --tcp-flags SYN,FIN,ACK SYN
    * 2. --tcp-flags ALL NONE 匹配所有标记都未置1的包
* 4. Match: --tcp-option : 根据选项匹配包:
    * Example: iptables -p tcp --tcp-option 16
    * TCP选项是TCP头中的特殊部分，有三个不同的部分:
        * 1. 第一个8位组标书选项的类型
        * 2. 第二个8位组标书选项的长度(这个长度是整个选项的长度，但不包含填充部分所占的字节，而且要注意不是每个TCP选项都有这一部分)
        * 3. 第三个8位组标书选项的内容


### Three. 能够用于UDP的UDP matches:
* UDP是一种无连接协议，所以它在打开、关闭连接以及发送数据时没有多少标记要设置，它也不需要任何类型的确认.
* 1. Match: --sport, --source-port 和 TCP 一样
* 2. Match: --dport, --destination-port 和 TCP 一样

### Four. 只能用于ICMP的ICMP matches
* 和UDP一样是无连接协议, 但是生存时间更短
* ICMP协议主要用来错误报告和连接控制等
* ICMP不是IP的子协议，而是和IP并列的一个协议，它主要用来增强IP功能和帮助IP进行错误处理.
* Match: --icmp-type : 根据ICMP类型匹配包:
    * Example: iptables -A INPUT -p icmp --icmp-type 8
    * 帮助: iptables -p icmp --help
    * icmp 类型 ....

### Four. 1 SCTP匹配(matches):
* 流控制传输协议(SCTP), 是一个箱单新的协议，查看问

### Five 显示匹配(Explicit matches):

### Five. 一些特殊匹配, 例如基于状态(state), 所有者(owner)或者限制(limit)等
* 显示匹配必须用-m或--match装载, 比如使用状态匹配就必须使用 -m state

#### Five 1. 限速匹配器(match)
* 对指定的规则的日志数量加以限制
* 减少Dos syn flood攻击的影响
* -m --limit --limit 5/s: 限制每秒5个package，其他丢弃(每个package 1480字节); 也就是在数量超过限定后，所有的包都会被匹配.
* 1. -m limit --limit 5/s --limit-burst 10/s:
    * limit-burst令牌首先被初始化为10, 每一条满足这条规则的报文都会消耗一个令牌
* 2. ...

#### Five 2. MAC地址匹配器(match)
* 能够根据报文的MAC地址匹配报文，到目前只能根据报文的源MAC进行匹配
* -m mac 
* Match: --mac-source : 基于包的MAC源地址匹配包，地址格式XX:XX:XX:XX:XX:XX :
    * iptables -A INPUT -m mac --mac-source 00:11:22:33:44:55
    * 注意: 因为MAC address 只能用于 Ethernet 类型的网络,所以这个match只能用于Ethernet接口, 而且，　它还只能在PREROUTING, FORWARD 和 INPUT链里使用.

#### Five 3. 多端口匹配器(match):
* 不能把标准匹配和多端口匹配混用: --sport 1024:65535 -m multiport --dport 21,23,80
* Match : --source-port :源端口
    * iptables -A INPUT -p tcp -m multiport --source-port 22,53,80,110
    * 最多能匹配15个不连续端口，前提-p tcp 或 -p udp才有端口
* Match : --destination-port :目的端口
    * iptables -A INPUT -p tcp -m multiport --destination-port 22,53,80
* Match : --port : 同端口多端口匹配，意思是它匹配的是那种源端口和目的端口是同一个端口的包, 比如: 端口80到端口80的包:
    * iptable -A INPUT -p tcp -m multiport --port 22,53,80

#### Five 4. 数组匹配器(macth)
* 

