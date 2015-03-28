---
layout: post
category: linux
tags: [linux, command, iptables]
---
{% include JB/setup %}

### 将来自 10.4.143.0/24 的tcp数据指向 64.111.96.38
```bash
iptables -t nat -I PREROUTING -s 10.4.143.0/24 -p tcp -j DNAT --to-destin
ation 64.111.96.38
```

### 将来自 10.4.143.0/24 的tcp的http数据指向 123.58.180.106
```bash
iptables -t nat -I PREROUTING -s 10.4.143.0/24 -p tcp -m tcp --dport 80 -j DNAT --to-destination 123.58.180.106
```

### 禁用访问域名, 与 --string 匹配
```bash
iptables -I OUTPUT -s 10.4.143.0/24 -p tcp -m string --string "baidu.com" --algo bm -j DROP
```

### 重定向
```bash
sudo iptables -t nat -I PREROUTING -p tcp -m tcp -j DNAT --to-destination 204.79.197.200
```

### 限制速度
```
MTU: 1500Bytes ~= 1.46KB = 1 package
 --limit 1/s # 每秒限制一个package ~= 1 * 1.46 KB
 --limit-burst 1 # 允许触发 limit 限制的最大次数为1 (默认为5)

 限制最大速度 1kB/s 左右
```

* 限制来自 10.4.156.0/24的速度, 也就是上传速度

```bash
iptables -I FORWARD 1 -s 10.4.156.0/24 -m limit --limit 1/s --limit-burst 1 -j ACCEPT
iptables -I FORWARD 2 -s 10.4.156.0/24 -j DROP # 不满足上一项，直接丢弃
```

* 限制去到 10.4.156.0/24的速度,也就是下载速度, 
  这里限制1package/s, 大约1KB/s, 由 limit后的参数决定
  
```bash
iptables -I FORWARD 1 -d 10.4.156.0/24 -m limit --limit 1/s -j ACCEPT
iptables -I FORWARD 2 -d 10.4.156.0/24 -j DROP # 不满足上一项，直接丢弃
```
