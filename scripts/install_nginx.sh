#!/bin/bash

set -e

downloadTool="sudo apt-get install -y"
PACKAGE_DIR=/tmp/src
SRC_DIR=$PACKAGE_DIR

NGINX_VERSION=1.6.2
NGINX_TAR_GZ=${PACKAGE_DIR}/nginx.tar.gz
SRC_DIR_FINAL=$SRC_DIR/nginx-${NGINX_VERSION}
PREFIX=/usr
BINARY_DIR=/usr/sbin
CONF_PATH=/etc/nginx/nginx.conf

# Config Options
CONFIG_OPTIONS="
    --user=nginx
    --group=nginx
    --prefix=$PREFIX
    --sbin-path=$BINARY_DIR
    --conf-path=$CONF_PATH
    --error-log-path=/var/log/nginx/error.log
    --pid-path=/var/run/nginx/nginx.pid
    --with-http_ssl_module
    --with-http_flv_module
    --with-http_gzip_static_module
    --http-log-path=/var/log/nginx/access.log
    --http-client-body-temp-path=/var/tmp/nginx/client
    --http-proxy-temp-path=/var/tmp/nginx/proxy
    --http-fastcgi-temp-path=/var/tmp/nginx/fcgi
    --with-http_stub_status_module
    --with-http_realip_module
    --with-ipv6
"
# --with-http_image_filter_module
# --with-poll_module
# --with-select_module 
# --sbin-path=$BINARY_DIR

# build-essential
$downloadTool build-essential

# gcc
$downloadTool gcc

# PCRE MODULE
$downloadTool libpcre3 libpcre3-dev

# zlib
$downloadTool zlib1g zlib1g-dev

# OpenSSL
$downloadTool openssl
$downloadTool libssl-dev
# $downloadTool openssl-dev

if [ ! -d $PACKAGE_DIR ]; then 
    mkdir -p $SRC_DIR
else
    test -d $SRC_DIR_FINAL && rm -rf $SRC_DIR_FINAL
fi

# tar.gz
if [ ! -f $NGINX_TAR_GZ ]; then
    wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -O $NGINX_TAR_GZ
fi

# src
tar -zxvf ${PACKAGE_DIR}/nginx.tar.gz -C $SRC_DIR

# 建立nginx组
id nginx >> /dev/null 2>&1
if [ "$?" != "0" ]; then
    sudo groupadd -r nginx
    sudo useradd -s /sbin/nologin -g nginx -r nginx
fi

# configure
cd $SRC_DIR_FINAL
./configure $CONFIG_OPTIONS

# make
make

# install
sudo make install

# ln sbin
# if [ -f ${BINARY_DIR}/nginx ]; then
#    sudo rm -rf ${BINARY_DIR}/nginx
# fi
# sudo ln -s ${PREFIX}/sbin/nginx ${BINARY_DIR}/nginx

# uninstall script
# if [ -f "$BINARY_DIR/uninstall_nginx" ]; then
#    sudo rm -rf $BINARY_DIR/uninstall_nginx
# fi
# sudo touch $BINARY_DIR/uninstall_nginx
sudo bash -c "echo -e \" \
    sudo rm -rf $PREFIX/nginx \n \
    sudo rm -rf $BINARY_DIR/nginx \n \
    sudo rm -rf $CONFIG_OPTIONS \n \
    sudo rm -rf /var/run/nginx \n \
    sudo rm -rf /var/log/nginx \n \
    \" > $BINARY_DIR/uninstall_nginx"
sudo chmod a+x $BINARY_DIR/uninstall_nginx
