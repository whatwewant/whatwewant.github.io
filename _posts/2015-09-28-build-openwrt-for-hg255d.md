---
layout: post
title: "为HuaWei HG255D 路由器编译 Openwrt 固件"
keywords: [""]
description: ""
category: "linux"
tags: [linux, openwrt, hg255d, router]
---
{% include JB/setup %}

### 参考资料
* [官方文档](http://wiki.openwrt.org/doc/start)
    * [Easy Build](http://wiki.openwrt.org/doc/howto/easy.build)
    * [Image Generator](http://wiki.openwrt.org/doc/howto/obtain.firmware.generate)
    * [SDK](http://wiki.openwrt.org/doc/howto/obtain.firmware.sdk)
* [HG255D配置修改](http://www.cnphp6.com/archives/27122)
* 其他
    * [Man 1](http://my.oschina.net/zuobz/blog/208034)
    * [Man 2](http://www.jianshu.com/p/66c7b0969a31)
    * [Openwrt ShadowVPN](https://github.com/whatwewant/ShadowVPN)
    * [Openwrt Shadowsocks](https://github.com/shadowsocks/openwrt-shadowsocks)
    * [Openwrt njit8021xclient](https://github.com/liuqun/openwrt-clients)
* [官方固件地址](https://downloads.openwrt.org)
    * [ramips](https://downloads.openwrt.org/barrier_breaker/14.07/ramips/rt305x/)
* 搜索引擎:
    * Google
    * 百度(中文信息较多)
* 相关网站:
    * [Stackoverflow](http://stackoverflow.com/)
    * [Openwrt中文网技术论坛](http://www.openwrt.org.cn/bbs/)
    * [恩山论坛](http://www.right.com.cn/)
    * [简书](http://www.jianshu.com/)
    * [开源中国社区](http://www.oschina.net)
    * [CSDN](http://blog.csdn.net)
    * 其他

### 一、Openwrt 版本
* [Barrier Breaker 14.07](https://downloads.openwrt.org/barrier_breaker/14.07/)
* 另:
    * 当然也可以是Chaos Calmer 15.05或trunk, 但是好像后面的都不支持了

### 二、路由信息
* Machine:
    * HuaWei HG255D
* CPU型号(Target System)
    * Ralink RT3052 id:1 rev:3 
    * 属于 Ramips

### 三、交叉编译环境搭建
* OS:
    * Ubuntu 14.04
* 所需依赖:

```bash
sudo apt-get install subversion \
                    build-essential \
                    libncurses5-dev \
                    zlib1g-dev \
                    gawk \
                    git \
                    ccache \
                    gettext \
                    libssl-dev \
                    xsltproc \
                    file \
                    unzip \
                    flex \
                    quilt \
                    libxml-parser-perl \
                    mercurial \
                    bzr \
                    ecj \
                    cvs \
                    python \
                    wget
```

### 四、下载Openwrt源码以及编译
* Infomation:
    * Version: barrier_breaker
    * Kernel: 3.10.x
    * Support HuaWei HG255D: Y

#### 具体步骤

```bash
# Step 1: 下载源码
###
    mkdir ~/openwrt
    cd ~/openwrt
    # 下载barrier_breaker分支，当然你可以选择trunk(开发分支)或者其他分支
    # 开发分支: svn://svn.openwrt.org/openwrt/trunk
    svn co -r 36088 svn://svn.openwrt.org/openwrt/branches/barrier_breaker
    cd barrier_breaker
    
# Step 2: 更新软件包
###
    # *******************
    # 提示: 最好在VPS上或者挂VPN, 可能有些更新不了
    # *******************
    # 更新种子
    # 相关文件: feeds.conf.default
    ./scripts/feeds update -a
    # 下载更新
    ./scripts/feeds install -a
    
# Step 3: 生成默认配置
###
    make clean # 清除
    make defconfig # 非必须
    
# Step 4: 进入配置菜单进行配置
###
    #   1、在这一步之前，修改一些配置以适应HG255D，非常重要
    # 具体见 为HG255D修改配置
    #
    #   2、选择shadowsocks、shadowvpn、njit8021xclient: 见七、自己添加的包
    make menuconfig
    #   2.1、如果需要修改包，请参见 十、对一些包的修改
    #　 3、选择基础包: 见六、固件推荐包
    #
    ##
    # 仔细阅读以上3条,再继续; Or Exit
    # 
    # 基础信息
    Target System (Ralink RT288x/RT3xxx)
    Subtarget (RT3x5x/RT5350 based boards)
    Target Profile (HuaWei HG255D)
    Target Image --> squashfs
    
    ############################
    # 以下个人建议推荐 begin
    [*] Advanced configuration options (for developers)
    
    # 从ImageBuilder构建固件,这个非常好用，
    # 见八、从[ImageGenerator](http://wiki.openwrt.org/doc/howto/obtain.firmware.generate)生成固件
    [*] Build the OpenWrt Image Builder
    
    # SDK可用于直接编译所需要的包,也就是不在需要源码，只要SDK和包
    # 见九、从[SDK](http://wiki.openwrt.org/doc/howto/obtain.firmware.sdk)编译软件包
    [*] Build the OpenWrt SDK
    
    [*] Build the Openwrt based Toolchain
    [*] Image configuration
    # 推荐 end
    ############################
    
    # 推荐的包
    Base System --> [*] base-files
                    [*] block-mount
                    [*] dnsmasq
    # Base System --> [*] dnsmasq-dncpv6
    # Base System --> [*] bridge
    Administration -->  [*] sudo
    #                   [*] syslog-ng3
    Kernel modules --> FIlesystems -->  [*] kmod-fs-ext4
                                        [*] kmod-fs-ntfs
                                        [*] kmod-fs-vfat
                   --> LED modules -->  [*] kmod-leds-gpio
                                        [*] kmod-ledtrig-default-on
                                        [*] kmod-ledtrig-gpio
                                        [*] kmod-ledtrig-heartbeat
                   --> Network Support --> [*] kmod-pptp
                                           [*] kmod-tun # For ShadowVPN
                   --> USB Support --> [*] kmod-usb2
                   --> Wireless Drivers --> [*] kmod-rt2800-soc
                                            [*] kmod-rtl8187
                                            [*] kmod-rt73-usb
    Language --> Python --> [*] ipython # 是否嵌入Python，自己决定
                            [*] python　# 只作为模块编译[*] -> [M]
                            [M] python-django
                            [M] python-mysql
                            [M] python-sqlite3
             # --> PHP
             # --> Lua 默认即可
             # --> Javascript
    Libraries --> database --> [*] libsqlite3
    LUCI --> Collections --> [*] luci
                             # [*] luci-ssl # https支持
         --> Applications --> [*] luci-app-chinadns
                              [*] luci-app-commands # LuCI Shell Commands
                              [*] luci-app-ddns # 动态DNS
                              [*] luci-app-firewall # 防火墙
                              [*] luci-app-p2pblock
                              [*] luci-app-polipo
                              [*] luci-app-qos
                              [*] luci-app-radvd
                              [*] luci-app-redsocks2
                              [*] luci-app-shadowsocks-spec
                              [M] luci-app-shadowvpn # ShadowVPN有BUG,不宜内建
                              [ ] luci-app-samba # 好像编译会出错,不选
                              [*] luci-app-tinyproxy
                              [*] luci-app-transmission
                              [*] luci-app-upnp
                              [*] luci-app-wol
         --> Themes --> [*] luci-theme-bootstrap
         --> Translations --> [*] luci-i18n-chinese
    Network --> BitTorrent --> [*] transmission-daemon
                               [*] transmission-web
            --> Captive Portals --> [*] wifidog # ...
                                    [M] wifidog-auth
            --> File Transfer --> [*] aria2 *
                              --> [*] curl
                              --> [*] vsftpd
            --> SSH --> [*] autossh
                    --> [*] openssh-keygen
            --> VPN --> [*] pptpd
                    # --> [*] chaosvpn
                    # --> [*] l2tpd
                    # --> [*] l2tpns
                    # --> [*] n2n
                    # --> [*] openvpn-* # 我不想要，麻烦
                    # --> [*] xl2tpd
            --> Version Control Systems --> [M] git
                                        --> [M] subversion-libs
            --> Web Servers/Proxies --> # [M] apache # 下载不了
                                    --> [M] nginx
                                    --> [M] redsocks
                                    --> 其他默认
            --> dial-in/up --> 尚且不知学不需要
          --> [*] ChinaDNS
          --> [M] ShadowVPN
          --> [ ] agan8021xclient
          --> [ ] mentohust
          --> [*] netcat # nc
          --> [ ] njit8021xclient
          --> [*] odhcp6c
          --> [*] odhcpd
          --> [*] ppp-mod-pppoe
          --> [*] ppp-mod-pptp
          --> [*] redsocks2
          --> [M] shadowsocks-libev
          --> [M] shadowsocks-libev-polarssl
          --> [*] shadowsocks-libev-spec
          --> [M] shadowsocks-libev-spec-polarssl
          # --> [M] wpa-cli
          # --> [M] wpa-supplicant
          --> [*] wpad
          # --> [*] wpad-mini # IEEE 802.1x Authenticator/Supplicant(WPA-PSK only)
        --> Utilities --> database --> [M] mysql-server
                                   --> [*] sqlite3-cli
                      --> backup --> [M] rsnapshot
                      --> [M] bash
                      --> [*] shadow-passwd
                      --> [*] shadow-su
                      --> [*] shadow-useradd
                      --> [*] shadow-userdel
                      --> [*] shadow-usermod
                      --> [M] squashfs-tools-mksquashfs
                      --> [M] squashfs-tools-unsquashfs
                      --> [ ] tessert # 下载不了
                      --> [M] tmux
                      --> [*] wifitoggle
                      --> [M] zsh

# Step 5: 下载所需要的软件源码
###
    # 最好在VPS或通过VPN下载
    make download V=99 # V=99 == V=s, 输出所有信息

# Step 6: 开始编译
###
    # 其中也有些包需要联网下载，这点好像不太合适，因为应该安排在上一步，怪作者..
    make V=99 
    # 建议 make -j 4 V=99 # 主流机器都支持 -j 4, 比直接make V=99快很多

# Step 7: 如果有错误
###
    # 可以 make menuconfig 入后 输入 /, 查找并去除出错的包
    # 然后再make -j 4 V=99即可，最好不用make clean, 否则之前编译的包都没了
    
# Step 8
###
    # 在 bin/ramips/下查找
    # 可安装固件:
        openwrt-ramips-rt305x-hg255d-squashfs-sysupgrade.bin
    # 软件包文件夹:
        packages/*
    # SDK
        OpenWrt-SDK-ramips-for-linux-x86_64-gcc-4.8-linaro_uClibc-0.9.33.2.tar.bz2
    # ImageBuilder
        OpenWrt-ImageBuilder-ramips_rt305x-for-linux-x86_64.tar.bz2
    # Toolchain
        OpenWrt-Toolchain-ramips-for-mipsel_24kec+dsp-gcc-4.8-linaro_uClibc-0.9.33.2.tar.bz2
    # 不知道的文件
        openwrt-ramips-rt305x-uImage.bin
        openwrt-ramips-rt305x-vmlinux.bin
        等
```

### 五、为HuaWei HG255D修改配置
* 1、打开对HG255D板的支持
    * File: `target/linux/ramips/image/Makefile`

```
Image/Build/Profile/HG255D=$(call BuildFirmware/Default16M/$(1),$(1),hg255d,HG255D)
...
$(call Image/Build/Profile/HG255D,$(1))
```

* 2、修改源码脚本的错误
    * File: `target/linux/ramips/base-files/lib/ramips.sh`

```
将

*"HG255D")
    name="hg255d"
    ;;

修改为

*"HuaWei HG255D"
    name="hg255d"
    ;;
```

* 3、解决电源LED灯不能正常工作的问题
    * File: `target/linux/ramips/base-files/etc/diag.sh`

```bash
在
    hlk-rm04)
        status_led="hlk-rm04:red:power"
        ;;
下添加
    hg255d)
        status_led="hg255d:power"
        ;;
```

* 4、设置默认打开Wlan, 密码为空
    * File: `package/kernel/mac80211/files/lib/wifi/mac80211.sh`

```
注释 option disabled 0 即可

# option disabled 0
```

* 5、添加root账号密码为admin
    * File: package/base-files/files/etc/shadow

```bash
将
    root::0:0:99999:7:::
修改为
    root:$1$21u5EotL$B9ebsVgEQe.C7lsk0iMf10:0:0:99999:7:::
```

### 六、固件推荐软件包
* 1 添加USB挂载
    * Base system --> block-mount
* 2 添加磁盘格式支持
    * Kernel modules --> Filesystems --> kmod-fs-ext4
    * Kernel modules --> Filesystems --> kmod-fs-msdos
    * Kernel modules --> Filesystems --> kmod-fs-ntfs
    * Kernel modules --> Filesystems --> kmod-fs-vfat
* 3 语言支持
    * Kernel modules --> Native Language Support --> kmod-nls-utf8
    * LUCI --> Translations --> luci-i18n-chinese
* 4 网络支持
    * Kernel modules --> Network Support --> kmod-pppol2tp
    * Kernel modules --> Network Support --> kmod-pptp
* 5 USB支持
    * # Kernel modules-->USB Support-->kmod-usb-hid
    * # Kernel modules-->USB Support-->kmod-usb-printer
    * # Kernel modules-->USB Support-->kmod-usb-serial  # usb转串口
    * # Kernel modules-->USB Support-->kmod-usb-serial-cp210x
    * # Kernel modules-->USB Support-->kmod-usb-serial-pl2303
    * Kernel modules-->USB Support-->kmod-usb-storage
    * Kernel modules-->USB Support-->kmod-usb-storage-extras
    * Kernel modules-->USB Support-->kmod-usb2
* 6 USB无线网卡驱动
    * Kernel modules-->Wireless Drivers-->kmod-rt2800-usb
    * Kernel modules-->Wireless Drivers-->kmod-rt73-usb
    * Kernel modules-->Wireless Drivers-->kmod-rtl8187
* 7 添加libffmpeg-mini支持ushare需要
    * Libraries-->libffmpeg-mini
* 8 LUCI (网页管理)
    * LuCI-->Collections-->luci
    * LuCI-->Applications-->luci-app-ddns
    * LuCI-->Applications-->luci-app-hd-idle
    * LuCI-->Applications-->luci-app-multiwan
    * LuCI-->Applications-->luci-app-ntpc
    * LuCI-->Applications-->luci-app-p910nd
    * LuCI-->Applications-->luci-app-qos
    * LuCI-->Applications-->luci-app-samba
    * LuCI-->Applications-->luci-app-tinyproxy
    * LuCI-->Applications-->luci-app-upnp
    * LuCI-->Applications-->luci-app-ushare
    * LuCI-->Applications-->luci-app-wol
    * LuCI-->Themes-->luci-theme-bootstrap
    * LuCI-->Translations-->luci-i18n-chinese
* 9 Network
    * Network --> File Transfer --> aria2
    * # Network --> Printing --> cups-locale-zh
    * Network --> VPN --> pptpd
* 10 Utilities
    * Utilities-->Filesystem-->badblocks#自动挂载工具
    * Utilities-->Filesystem-->mkdosfs
    * Utilities-->Filesystem-->ntfs-3g#ntfs读写
    * Utilities-->disc-->fdisk#分区工具
    * Utilities-->disc-->findfs
    * Utilities-->disc-->hdparm
    * Utilities-->lrzsz #上传下载工具
    * Utilities-->restorefactory#reset键支持(长按5秒以上就可以恢复固件默认设置)
    * Utilities-->wifitoggle #添加一键开关无线(按一下WPS键放开无线就打开或者关闭)

### 七、自己添加的软件(注意: package是源码根目录的package)
* 1、[ShadowVPN](https://github.com/aa65535/openwrt-shadowvpn)
    * `git clone https://github.com/aa65535/openwrt-shadowvpn.git package/shadowvpn`
    * `Bug: 不能作为内建(build-in)软件, 否则编译出的固件很多问题，暂时无法解决`
    * 可以作为生成模块, 即[M]
* 2、[ChinaDns](https://github.com/aa65535/openwrt-chinadns)
    * `git clone https://github.com/aa65535/openwrt-chinadns.git package/chinadns`
* 3、[dnsmasq](https://github.com/aa65535/openwrt-dnsmasq)
    * `git clone https://github.com/aa65535/openwrt-dnsmasq.git package/dnsmasq`
* 4、[redsocks2](https://github.com/aa65535/openwrt-redsocks2)
    * `git clone https://github.com/aa65535/openwrt-redsocks2.git package/redsocks2`
* 5、[shadowsocks](https://github.com/shadowsocks/openwrt-shadowsocks)
    * `git clone https://github.com/shadowsocks/openwrt-shadowsocks.git package/shadowsocks-libev`
* 6、[ShadowVPN ChinaDns dnsmasq redsocks2 shadowsocks的luci](https://github.com/aa65535/openwrt-dist-luci)
    * `git clone https://github.com/aa65535/openwrt-dist-luci.git package/openwrt-dist-luci`
* 7、[njit-client](https://github.com/liuqun/openwrt-clients)
    * 方法一: 只可以编译软件包，请不要内建，否则编译出错
        * `git clone https://github.com/liuqun/openwrt-clients package/openwrt-clients`
        * Bug: 编译无法通过，失败
        * 但是直接编译包却可以: `make package/openwrt-clients/njit/njit8021xclient/compile V=99`
    * (推荐)方法二、在feeds.conf.default中添加
        * `src-svn njit https://github.com/liuqun/openwrt-clients/trunk/njit`
        * `src-svn hust https://github.com/liuqun/openwrt-clients/trunk/hust`
        * `src-svn gdou https://github.com/liuqun/openwrt-clients/trunk/gdou`
        * `src-svn sysu https://github.com/liuqun/openwrt-clients/trunk/sysu`
        * 然后 `./scripts/feeds update -a; ./scripts/feeds install -a`


### 八、从ImageBuilder包生成Image(固件)
* File: OpenWrt-ImageBuilder-ramips_rt305x-for-linux-x86_64.tar.bz2
* 解压:
    * tar -xvf OpenWrt-ImageBuilder-* 
    * cd OpenWrt-ImageBuilder-*
* 生成Image
    * make image PROFILE=HG255D # HG255D为路由器名字, 默认只有基础包
    * make image PROFILE=HG255D PACKAGES="pk1 pk2 pk3 -pk4" # -pk4表示去掉pk4包

```bash
 make image PROFILE=HG255D PACKAGES="kmod-tun zlib libopenssl libpthread ip luci luci-i18n-chinese luci-app-firewall curl vsftpd ntfs-3g autossh netcat python pptpd ChinaDNS luci-app-chinadns redsocks2 luci-app-redsocks2 shadowsocks-libev-spec luci-app-shadowsocks-spec transmission-web luci-app-transmission luci-app-upnp luci-app-qos wifidog openssh-keygen sqlite3-cli sudo shadow-common shadow-su shadow-useradd shadow-userdel shadow-usermod"
 # 注意, 不要加入ShadowVPN包，会造成固件很多问题，重启后配置丢失, LED灯不正常, POWER灯一直闪让我以为坏掉，其实是正常的等
 # luci-app-shadowvpn 最好也不要
```

### 九、从SDK编译生成软件包
* 好处: 
    * 如果只要编译某些包，这样简单方便多了
    * 只用于编译生成软件包
* File: OpenWrt-SDK-ramips-for-linux-x86_64-gcc-4.8-linaro_uClibc-0.9.33.2.tar.bz2
* 解压: 
    * tar -xvf OpenWrt-SDK-ramips-*
    * cd OpenWrt-SDK-ramips-*
* 编译包: 假定包已经在package/中, 叫njit8021xclient
    * make package/njit8021xclient/compile V=99

```bash
# 栗子一、编译ShadowVPN
# 获取 Makefile
git clone https://github.com/aa65535/openwrt-shadowvpn.git package/shadowvpn
# 选择要编译的包 Network -> ShadowVPN
make menuconfig
# 开始编译
make package/shadowvpn/compile V=99

# 栗子二、编译njit8021xclient
git clone https://github.com/liuqun/openwrt-clients package/openwrt-clients
# 选择要编译的包 Network -> njit8021xclient
make menuconfig
make package/openwrt-clients/njit/njit8021xclient/compile V=99
```

### 十、对一些包的修改
* 1 修改shadowsocks, 使其生成ss-server

```bash
找到
    ss-{local,redir,tunnel}
修改为
    ss-{server,local,redir,tunnel}
```

* 2 修改shadowvpn, 它的配置好像有问题
    * [下载client/server配置文件](https://github.com/whatwewant/ShadowVPN/tree/master/samples)
        * 有关client* 和 server*的文件(共留个)
        * client.conf
        * client_up.sh
        * client_down.sh
        * server.conf
        * server_up.sh
        * server_down.sh
    * 将client*和server*文件(6个文件)移动到 package/ShadowVPN/files下
    * 修改Makefile文件，见下文
    * `注意: 该包有BUG, 不能内建`
        * 一、如果opkg安装ShdowVPN_*.ipk出错，可能造成很多，命令不能用, 如不能重启(reboot)等，不用惊慌, 只要 opkg remove ShadowVPN即可
        * 二、如果安装出错了，请尝试opkg重新安装, 然后/etc/init.d/shadowvpn disable 或者 rm -rf /etc/rc.d/*shadowvpn, 然后关闭电源重启即可
        * 三、如果再出错，重复解决方法一, 然后tar -zxvf ShadowVPN*, 然后tar -zxvf data.tar.gz -C /, 然后/etc/init.d/shadowvpn 或者 rm -rf /etc/rc.d/*shadowvpn, 然后关闭电源重启即可

```bash
将
    $(INSTALL_DATA) ./files/client_up.sh $(1)/etc/shadowvpn/client_up.sh
    $(INSTALL_DATA) ./files/client_down.sh $(1)/etc/shadowvpn/client_down.sh
修改为
    $(INSTALL_DATA) ./files/client.conf $(1)/etc/shadowvpn/client.conf
    $(INSTALL_DATA) ./files/client_up.sh $(1)/etc/shadowvpn/client_up.sh
    $(INSTALL_DATA) ./files/client_down.sh $(1)/etc/shadowvpn/client_down.sh
    $(INSTALL_DATA) ./files/server.conf $(1)/etc/shadowvpn/server.conf
    $(INSTALL_DATA) ./files/server_up.sh $(1)/etc/shadowvpn/server_up.sh
    $(INSTALL_DATA) ./files/server_down.sh $(1)/etc/shadowvpn/server_down.sh
```

### 十一、遇到的问题
* 1、软件包源码下载问题解决办法
    * 方法一
        * 尝试修改DNS慢慢下
        * File: /etc/resolv.conf
        * 开头添加: `nameserver 114.114.114.114`
        * 开头添加: `nameserver 8.8.4.4`
        * 然后继续下，只能自求多福
    * 方法二
        * 连接VPN
    * 方法三
        * 在VPS上make download, 然后tar压缩下载到本地编译, 当然也可以在服务器上编译，不过性能...
* 2、有些包真心下载不了，要么不存在，要么它的服务器出问题，导致编译出错
    * 例如 mentohust 在 googlecode, apache 好像下不了了
    * 解决办法:
        * make menuconfig
        * 输入 /
        * 查找 mentohust, 然后将其删除即可
* 3、有些包不知道出什么问题，然后导致整个固件很大问题
    * 例如: ShadowVPN 导致编译出来的固件
        * 重启后，配置不能保存
        * df -h 查看 rootfs 30M (肯定是有问题的)
        * reboot 等命令失效
        * LED灯问题: 电源灯(POWER)一直闪烁(让我以为是刷成砖了，其实不是), 其他灯不亮了
    * 推测:
        * 可能是/etc/rc.d/S90shadowvpn 导致的
    * 解决办法:
        * `不要将这种包内建[*], 编译成模块[M]即可`
    * `安装ShadowVPN包的办法: 见 十、对一些包的修改`
* 4、编译Error(出错)而停止
    * 不用惊慌，根据前面1、2、3先解决
    * 不用make clean, 因为已经编译过的包是没问题的，网上好多资料不准确
    * 然后继续 make -j 4 V=99
* 5、`make -j 4 V=99`一直出错
    * 尝试: `make V=99`
* 6、路由器电源灯不亮 和 无线没有开启
    * 见`五、为HuaWei HG255D修改配置`

### 十二、某些软件BUG
* 1 编译`tesseract`
    * Problem 1:
        *** No rule to make target `../src/liblept.la', needed by `adaptnorm_reg'.  Stop.
        * [解决办法](https://dev.openwrt.org/ticket/18355)
        * File: `package/feeds/oldpackages/leptonica/Makefile`

```bash
    PKG_NAME:=leptonica
    PKG_VERSION:=1.71
    PKG_RELEASE:=1
    
    PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
    PKG_SOURCE_URL:=http://www.leptonica.org/source/
    PKG_MD5SUM:=790f34d682e6150c12c54bfe4a824f7f
```
