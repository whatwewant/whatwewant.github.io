---
layout: post
category: linux
tag: [linux, network, commands]
---
{% include JB/setup %}

## 扫描技术
[Study Address](http://imooc.com/video/6629)

### 1. 概述
* 1.互联网安全: 数据的真实、可靠、完整、可控
* 2. 命令:
  * tracert
  * `traceroute`:
      * 扫描到达目的网络的路由
      * 例如: traceroute www.baidu.com #　将可以看到所经过的路由
  * `nmap`:
      * 端口范围扫描, 批量主机服务扫描
  * `nc`:
      * 任意IP地址端口扫描
* 3.网络入侵方式:
    * 踩点－网络扫描－查点－提权等

### 2.主机扫描
* 命令:
    * `fping` (ping增强版):
        * 作用: 批量的给目标主机发送ping请求，测试主机的存活情况
        * 特点: `并行发送`、结果易读
        * 参数:
            * h: help (详细信息: man)
            * a: 只显示出存货的主机(相反参数 -u)
            * g 支持主机段的方式: 192.168.1.1 192.168.1.255或者192.168.1.0/24
            * q: 安静,不输出不显示每个ping的结果
            * f: 通过读取一个文件中Ip的内容: fping -f filename
        * 例子:
            * 1.通过标准输入方式 fping + IP1 + IP2 + IP3 ...
            * 2. 批量扫描主机段:
                * fping -g 192.168.1.1 192.168.1.255
                * fping -g 192.168.1.0/24
                * fping -agq 192.168.0/24
    * `hping` :
        * 特点: 支持使用的TCP/IP数据包组装、分析工具
          * 即当ICMP数据包被服务器丢弃时，这个命令就很好用了
          * Github: hping 
          * 安装(ubuntu): sudo apt-get install hping3
          * 依赖:
              * libpcap-devel
          * 参数:
              * h: help
              * v: version
              * p: 端口
              * S: 设置TCP模式SYN包(三次握手包的同步包)
              * a: 伪造IP地址
          * 用法:
              * 1. 对指定目标端口发起tcp探测:
                  * hping3 -p 80 -S 192.168.1.1
              * 2伪造来源IP，模拟Ddos攻击:
                  * hping3 -p 80 -S 192.168.1.1 -a 10.10.163.123
          * 扩展:
              * `netstat`:
                  * l : 查看本机监听端口
                  * t : 查看tcp的协议
                  * n : 不做主机名解析,即只显示IP地址不显示主机名
              * sysctl -w net.ipv4-icmp\_echo\_ignore\_all=1 (去掉\)
                * 写入内核，禁用icmp echo; 更好的方式用iptables
                * iptables -A INPUT -p icmp --icmp-type 8 -j DROP
                   * icmp-type:
                      * 8 : 禁止echo
                * tcpdump:
                    * tcpdump -np ieth0 (eth0是网卡)
                    * tcpdump -np -ieth0 src host 10.10.163.123 # 只把来自host10.10.163.123的主机的包过滤出来

### 3.路由扫描
* 作用: 查询一个主机到另一个主机的经过的路由的跳数、以及数据的延迟情况
* 常用工具:
    * `traceroute`
      * 默认使用的是UDP协议(30000上的端口)
      * 使用TCO协议 -T(tcp协议) -p(端口)
      * 使用ICMP协议 -I
      * 不显示域名解析,只显示IP: -n
    * `mtr`:
      * man mtr

### 4.批量服务扫描
* 目的:
    * 1.批量主机存活扫描
    * 2.针对主机服务扫描
* 作用:
    * 1.能更方便快捷获取网络中主机的存活状态
    * 2.更加细致、智能获取主机服务侦查情况
* 命令:
    * `nmap` 命令

| 扫描类型 | 描述 | 特点 |
|----------|:-----|:-----|
|ICMP协议类型(-sP)|ping扫描|简单、快速、有效|
|TCP SYN扫描(-sS)|TCP半开放扫描|高效、不易被检测、通用|
|TCP connect()扫描(-sT)|TCP全开放扫描|真实、结果可靠|
|UDP扫描(-sU)|UDP协议扫描|有效透过防火墙策略|

* 命令:
    * nmap:
        * 用ICMP协议主机段扫描: nmap -sP 10.1.21.0/24
        * TCP SYN半开放: nmap -sS 127.0.0.1
        * TCP SYN半开放: nmap -sS -p 0-2048 127.0.0.1 # -p + 端口范围
        * TCP SYN全开放: nmap -sT -p 0-2048 127.0.0.1 # -p + 端口范围
        * UDP扫描: nmap -sU 127.0.0.1
    * `ncat`:
        * 组合参数:
            * w : 设置的超时时间
            * z : 一个输入输出模式
            * v : 显示命令执行过程
        * 应用:
            * 基于tcp协议(默认): nc -v -z -w2 10.1.21.254 1-50
            * 基于udp协议 -u : nc -v -z -w2 -u 10.1.21.254 1-50

### 5.linux防范恶意扫描安全策略
* 常见的攻击方法:
    * 1. SYN攻击:
        * 定义: 录用TCP协议缺陷进行，导致系统服务停止响应，网络带宽跑满或者响应缓慢
        * 原理:
           * 伪造IP地址
        * 防范:
            * 1.减少发送sny+ack包时重试次数:
                * sysctl -w net.ipv4.tcp\_synack\_retries==3 (去掉\)
                * sysctl -w net.ipv4.tcp\_syn\_retries=3
            * 2.SYN cookies技术:
                * sysctl -w net.ipv4.tcp\_syncookies=1
            * 3.增加backlog队列，即增加backlog队列长度:
                * sysctl -w net.ipv4.tcp\_max\_syn\_backlog=2048 (默认512)
    * 2. DDOS攻击:
        * 定义: 分布式访问拒绝服务攻击
    * 3. 恶意扫描
* Linux其他安全策略:
    * 1.关闭ICMP协议请求:
        * sysctl -w net.ipv4.icmp\_echo\_ignore\_all=1
    * 2.通过iptables防止扫描:
        * iptables -A FORWARD -p tcp --syn -m limit --limit 1/s --limit-burst 5 -j ACCEPT
        * iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT
        * iptables -A FORWARD -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT


