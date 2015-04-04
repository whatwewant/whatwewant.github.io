---
layout: post
title: Ubuntu Server 配置 LAMP
category: php
tags: [php, server, lamp]
---
{% include JB/setup %}

## 1. Environment
* 1. Ubuntu 14.10 Server
* 2. LAMP = Linux + Apache + Mysql/MariaDB + PHP

## 2. INSTALLATION
* 1. Apache:
    * sudo apt-get install apache2
    * 查看版本: apache2 -v # 这里已经上 2.4版本，和2.2不同
* 2. Php :
    * sudo apt-get install php5
    * 查看是否被加载: cat /etc/apache2/mods-enabled/php5.load 证明被加载
    * 查看版本: php5 -v
* 3. Mysql:
    * sudo apt-get install mysql-server
    * 查看mysql是否被php加载: cat /etc/php5/conf.d/mysql.ini :
    * 查看mysql是否被php加载 或者: cat /etc/php5//mods-available/mysql.ini :
        * php默认没有mysql扩展，为了加载 mysql.so : sudo apt-get install php5-mysql

```bash
软件总结: sudo apt-get install apache2 php5 mysql php5-mysql
更简单的方法: `sudo tasksel install lamp-server`
```

* `注意: tasksel 提供 LAMP / DNS server / Mail server .. 的安装`

## 3. Make sure them work correctly.
* 1. sudo service mysql restart
* 2. sudo service apache2 restart

## 4. 创建phpinfo服务器探针
* 1. cd /var/www/html
* 2. sudo vim info.php

```php
<?php
echo mysql_connect('localhost', 'root', 'root') ? 'It works.' : 'It doesn\'t work';

phpinfo();
```
* 3. 检查是否成功: 访问 http://服务器IP/info.php

## 5. 给PHP添加常用扩展
* 1. php5-gd curl libcurl3 libcurl3-dev php5-curl :
    * sudo apt-get install php5-gd curl libcurl3 libcurl3-dev php5-curl
    * 1. gd :
    * 2. curl :
* 2. 重启服务，使模块生效:sudo service apache2 restart
* 3. 查看模块是否生效:
    1. 查看: cat /etc/php5/mods-available/...
    2. 或者 浏览器访问: http://服务器IP/info.php, 搜索 gd, curl
* 4. sftp 命令
* 5. vsftpd ---- FTP 服务器 
* 6. 或者用 FileZilla 配置客户端

## 6. LAMP环境文件目录概述
* 1. Linux系统配置文件目录: /etc :
    * Apache : /ect/apache2
    * mysql : /etc/mysql
    * php : /etc/php5
* 2. Apache2 配置 (/ect/apache2):
    * 1. 加载流程: 
        * 1. 首先加载 apache2.conf
        * 2. 然后在apache2.conf 通过Include 加载其他文件/模块:
            * 1. conf-enabled/\*
            * 2. httpd.conf
            * 3. ports.conf
            * 4. mods-enabled/\*
            * 5. sites-enabled/\*
    * 2. 核心配置:
        * 1. mods-\*\*\* Apache模块
        * 2. sites-\*\*\* 虚拟主机
    * 3. 关键字:
        * 1. available 可用; enabled 已经启用.
        * 2. (创建需要启用的mod, 软连接available到enabled) :
            * enabled ----> available: ln -s 命令 建立软连接
    * 4, 虚拟主机配置(Virtual-Host):
        * 1. 客户端模拟DNS解析, 配置DNS, 即修改客户端hosts(Linux: /etc/hosts)文件:
            * 192.168.1.106 video.cc.com
            * 192.168.1.106 bbs.cc.com
            * 192.168.1.106 oa.cc.com
        * 2. 在服务器创建三个目录，分别用于三个url:
            * 1. cd /
            * 2. sudo mkdir -p /wwwroot/{video,bbs,oa} # 注意: shell 不要随便空格, big problem.
            * 3. 分别在三个子目录创建index.html, 内容仅作标识 , 例如 Here is xx Directory.
        * 3. Apache2 中配置虚拟主机:
            * 1. 配置文件: cd /etc/apache2/sites-available/000-default.conf
            * 2. 复制三个配置文件(最好以.conf结尾):
                * cp 000-default.conf video.conf
                * cp 000-default.conf bbs.conf
                * cp 000-default.conf oa.conf
            * 3. 分别配置(例video.conf):
                * 1. 设置服务器根目录: DocumentRoot 目录: 将DocumentRoot /var/www/html 改为 DocumentRoot /wwwroot/video
                * 2. 设置ServerName对应域名, 让Apache服务器自动区分域名: ServerName video.cc.com
                * 3. 配置Directory, 拒绝403Forbidden: <Directory /var/www/> 改为 <Directory /wwwroot/video/> , 可能添加以下代码

```bash
<Directory />
        Options FollowSymLinks
        AllowOverride None
    </Dorectory>

    <Directory /wwwroot/video/>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride None
        # Order allow, deny # Apache2 2.2
        # allow from all
        Require all granted # Apache2 2.4 
        # 详情查看: [Apache2 2.4 升级变化](http://httpd.apache.org/docs/2.4/upgrading.html)
    </Directory>
```

                * 4. 启用site配置: ln 软连接sites-available到sites-enabled:
                    * cd sites-enabled; sudo ln -s ../sites-available/video video.conf 
                    * > 注意：这里必须是.conf结尾的文件，否则服务器可能不识别
                * 5. 在/etc/apache2/apache2.conf配置文件中添加 ServerName cc.com, 否则可能警告没有全局ServerName
                * 6. 在/etc/apache2/apache2.conf配置文件中注释<Directory >相关
                * 7. 注意如果访问域名不存在，默认不一定是default.conf文件，而是按顺序，在/etc/apache2/sites-enabled文件夹中的第一个配置文件，所以就是为什么sites-available有000-default.conf了，所以在ln到sites-enabled时注意default配置文件应该数字字母排在第一个,例如 ln -s ../sites-available/000-default.conf 000-default.conf
                * 8. 重启Apache服务器, 就可以访问 video.cc.com了: sudo service apache2 restart

* 3. Mysql 配置 (/etc/Mysql/my.conf):
    * 1. Mysql数据存储目录迁移:
        * 1. 先停止MySQL服务，杜绝数据迁移产生的不良后果: sudo service mysql stop
        * 2. 创建数据迁移的目标文件夹(注意权限和默认配置要一直), MySQL默认数据存储目录在/var/lib/mysql中: 
            * 1. cd /
            * 2. sudo mkidir /mysqldata
            * 3. 修改用户组和所属用户为mysql: sudo chown -vR mysql:mysql /mysqldata
            * 4. 修改权限为700: sudo chmod -vR 700 /mysqldata
            * 5. 迁移数据，即复制/var/lib/mysql到/mysqldata:
                * sudo su
                * cp -av /var/lib/mysql /mysqldata # -a表示保存原文件权限等
            * 6. 修改MySQL配置文件/etc/mysql/my.cnf: 
                * 修改datadir(指定数据存储目录)的值: /var/lib/mysql 改为 /mysqldata
            * 7. 这步很重要: 修改apparmor对mysql的保护配置:
                * 1. sudo vim /etc/apparmor.d/usr.sbin.mysqld
                * 2. 修改有关/var/lib/mysql的配置:

```bash
# /var/log/mysql/ r,
# /var/log/mysql/** rwk,
/mysqldata/ r,
/mysqldata/** rwk,
```
            * 8. 重启 apparmor 服务: sudo service apparmor reload:
                * ubuntu 14.10 上报错: reload: Unknown instance:,是软件本身bug=-=, 重启系统也行
            * 9. 重启 mysql 服务: sudo service mysql start
            * 10. 测试数据迁移是否成功:
                * 1. mysql创建新的数据库时会在datadir目录下创建同名文件夹
                * 2. mysql -uroot -p
                * 3. create database cole;
                * 4. show database cole;
                * 5. quit
                * 6. 查看 /mysqldata下有没有创建新目录cole

* 4. Php 配置 (/etc/php5/apache2/php.ini)
  * 1. PHPMyAdmin的安装:
      * 1. sudo apt-get install phpmyadmin
      * 2. 看安装过程说明，配置
      * 3. 不一定必要: sudo ln -s /usr/share/phpmyadmin/ /var/www/pma ()
      * 4. 访问: 192.168.1.106/phpmyadmin
  * 2. 开启MySQL的remote access:
      * 1. 修改配置: sudo vim /etc/mysql/my.cnf
      * 2. 找到 bind-address, 注释掉 或者 修改为 0.0.0.0
      * 3. 在数据库名为mysql的user表单中添加一个公网可以访问的用户, 终端打开或者phpmyadmin打开添加均可
      * 4. Insert 一条数据: (如果看不懂英文, PHPMyAdmin可以选择中文)
          * Host : %  // % 代表任意IP
          * User : remote
          * Password : 123456
          * 权限自己看情况选择开启: 默认全关闭
      * 5. 重启mysql: sudo service mysql restart 

* 5. 了解一种简单的LAMP集群:
    * 1. 负载均衡Nginx + Apache + PHP + MySQL
