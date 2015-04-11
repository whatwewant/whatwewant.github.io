#!/bin/bash

set -e

downloadTool="sudo apt-get install -y"
PACKAGE_DIR=/tmp/src
SRC_DIR=$PACKAGE_DIR
NGINX_VERSION=1.6.2
NGINX_TAR_GZ=${PACKAGE_DIR}/nginx.tar.gz
SRC_DIR_FINAL=$SRC_DIR/nginx-${NGINX_VERSION}
PREFIX=/etc/nginx
BINARY_DIR=/usr/local/sbin

# Config Options
CONFIG_OPTIONS="
    --user=$USER
    --prefix=$PREFIX
    --with-http_ssl_module
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

# configure
cd $SRC_DIR_FINAL
./configure $CONFIG_OPTIONS

# make
make

# install
sudo make install

# ln sbin
if [ -f ${BINARY_DIR}/nginx ]; then
    sudo rm -rf ${BINARY_DIR}/nginx
fi
sudo ln -s ${PREFIX}/sbin/nginx ${BINARY_DIR}/nginx
