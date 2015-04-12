#!/bin/bash

if [ "$UID" != "0" ]; then
    echo "please use sudo to run $0"
    exit 1
fi

if [ "$#" != "5" ]; then
    echo "Usage: (5 parameters)"
    echo "    $0 localip remoteip username password networkSegment/NetMask"
    echo ""
    echo "  such as: $0 192.168.1.1 192.168.1.1-254 tmp tmp 192.168.1.0/24"
    echo "           $0 192.168.1.1 10.0.0.2-130 myuser mypassword 10.0.0.0/24"
    exit 1
fi

which pptpd > /dev/null
if [ "$?" != "0" ]; then
    apt-get install -y pptpd
fi

# 1. config /etc/pptpd.conf
sed -i "s%localip%#local_old_ip%g" /etc/pptpd.conf
sed -i "s%remoteip%#remote_old_ip%g" /etc/pptpd.conf
echo "localip $1" >> /etc/pptpd.conf # 这个就是你当前主机的IP地址
echo "remoteip $2" >> /etc/pptpd.conf # 这个就是给客户端分配置的IP地址池

# 2. 添加DNS , config /etc/ppp/options
sed -i "s%ms-dns%#old-dns%g" /etc/ppp/options
echo "ms-dns 114.114.114.114" >> /etc/ppp/options
echo "ms-dns 10.0.101.10" >> /etc/ppp/options
echo "ms-dns 8.8.8.8" >> /etc/ppp/options

# 3. 添加服务器名称 /etc/ppp/pptpd-options
# sed -i "s%name pptpd%name $1%g" /etc/ppp/pptpd-options
sed -i "s%name%#na_me%g" /etc/ppp/pptpd-options
echo "name $1" >> /etc/ppp/pptpd-options
echo "logfile /var/log/pptp.log" >> /etc/ppp/pptpd-options

# 4. 服务端的用户名和密码的配置 /etc/ppp/chap-secrets
#(位置): 
#  用户名 服务器名(可设置为*) 密码 允许登入的ip(可设置为*)
echo "\"$3\"    $1  \"$4\"  *" >> /etc/ppp/chap-secrets
# such as: "tmp" 192.168.1.1 "tmp" *

# 5. 查看运行的端口
# netstat -tnlpu | grep pptpd
# pptp 端口是tcp1723，可以看到1723端口开户
echo 1 > /proc/sys/net/ipv4/ip_forward #修改内核设置，使其支持转发
# 要想永久生效，使其支持转发的话
# config /etc/sysctl.conf
#echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf # 将后面值改为1，然后保存文件
sed -i "s%net.ipv4.ip_forward=1%#net_old_.ipv4.ip_forward = 1%g" /etc/sysctl.conf # 将后面值改为1，然后保存文件
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf # 将后面值改为1，然后保存文件
sysctl -p # 马上生效

# 6. 第四步打开端口转发后，路由器端口转发
# 转发本地tcp1723端口即可

# 7. 不加这条只能访问内网资源，加了可访问外网
# iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $5 -o eth0 -j MASQUERADE
# 7.1 出现在openwrt无法上网
# 默认在OpenWrt中安装pptpd并设置好后，虽然能通过vpn连接上，但是连上之后无法通过路由器上网。网上有人说在iptables中增加POSTROUTING的masquerade的规则，经老衲测试，没有效果。
#经反复摸索，发现客户端拨完vpn后，上网时的包都被rst掉了，于是想到应该是防火墙在搞鬼。
#看了下iptable，还真是复杂，增加了好几个链。想来想去应该是在FORWORD链中有名堂，于是加了条规则，发现终于可以上网了。甚喜，遂来分享之。
# iptables -A forwarding_rule -s 10.1.56.0/24 -j ACCEPT
iptables -A forwarding_rule -s $5 -j ACCEPT

# 8. 可能问题1:连接过程中无法通过帐号密码验证，logfile显示：pppd[26133]: Couldn’t open the /dev/ppp device: No such file or directory 
# 确少/dev/ppp
ls /dev/ppp
if [ "$?" != "0" ]; then
    mknod /dev/ppp c 108 0
fi

# 8. 重启pptpd服务否则客户端获取的IP段不生效
/etc/init.d/pptpd restart

exit 0
