---
layout: post
title: Linux Shadowsocks 全局代理
category: linux
tags: [linux, ubuntu, shadowsocks, iptables]
---
{% include JB/setup %}

# Linux用 iptables + ss-redir 为 Shadowsocks 全局代理 [Shell脚本下载地址]({{site.url}}/scripts/linux-shdowsocks-global.sh)

## 1. create new chain on nat table
* iptables -t nat -N SHADOWSOCKS

## 2. Ignore shdowsocks's address, avoid loop
* iptables -t nat -A SHADOWSOCKS -d YOUR-SERVER-IP -j RETURN

## 3. Ignore LANs and any other addresses you'd like to bypass the proxy
* iptables -t nat -A SHADOWSOCKS -d 0.0.0.0/8 -j RETURN
* iptables -t nat -A SHADOWSOCKS -d 10.0.0.0/8 -j RETURN
* iptables -t nat -A SHADOWSOCKS -d 127.0.0.0/8 -j RETURN
* iptables -t nat -A SHADOWSOCKS -d 169.254.0.0/16 -j RETURN
* iptables -t nat -A SHADOWSOCKS -d 172.16.0.0/12 -j RETURN
* iptables -t nat -A SHADOWSOCKS -d 192.168.0.0/16 -j RETURN
* iptables -t nat -A SHADOWSOCKS -d 224.0.0.0/4 -j RETURN
* iptables -t nat -A SHADOWSOCKS -d 240.0.0.0/4 -j RETURN

## 4. Anything else should be redirected to shadowsocks's local port
* iptables -t nat -A SHADOWSOCKS -p tcp -j REDIRECT --to-ports LOCAL-PORT

## 5. Apply the rules
* iptables -t nat -A OUTPUT -p tcp -j SHADOWSOCKS

## 6. Start the shadowsocks-redir
* ss-redir -c /etc/config/shadowsocks.json -f /var/run/shadowsocks.pid

## 7. 已经写好的shell脚本
* [下载地址]({{site.url}}/scripts/linux-shdowsocks-global.sh)

### 参考: [shadowsocks-openwrt](https://github.com/haohaolee/shadowsocks-openwrt)

