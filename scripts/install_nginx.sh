#!/bin/bash

# set -e

downloadTool="sudo apt-get install -y"
PACKAGE_DIR=/tmp/src
SRC_DIR=$PACKAGE_DIR

NGINX_VERSION=1.8.0
NGINX_TAR_GZ=${PACKAGE_DIR}/nginx-${NGINX_VERSION}.tar.gz
# NEED CHECK, @TODO
NGINX_TAR_GZ_PGP=${NGINX_TAR_GZ}.asc
SRC_DIR_FINAL=$SRC_DIR/nginx-${NGINX_VERSION}
##################################
# BASE PATHS
# PREFIX keeps default server files: like index.html ..
#   You will use relative path in nginx.conf:server segment
#     Like: ...
#           root html; # Here is a relative path, $PREFIX/html
#           ...
PREFIX=/var/www/nginx # default /usr/local/nginx
BINARY_DIR=/usr/sbin
CONF_PATH=/etc/nginx
NGINX_RUN_FILE_PATH=/var/nginx
###################################
LOG_PATH=${NGINX_RUN_FILE_PATH}/logs
PID_PATH=${NGINX_RUN_FILE_PATH}/run
LOCK_PATH=${NGINX_RUN_FILE_PATH}/lock
TEMP_PATH=${NGINX_RUN_FILE_PATH}/tmp
OTHER_PATH=${NGINX_RUN_FILE_PATH}/other

# Config Options
# More for stable version: http://nginx.org/en/linux_packages.html
CONFIG_OPTIONS="
    --user=nginx
    --group=nginx
    --prefix=$PREFIX
    --sbin-path=$BINARY_DIR
    --conf-path=${CONF_PATH}/nginx.conf
    --error-log-path=${LOG_PATH}/error.log
    --pid-path=${PID_PATH}/nginx.pid
    --lock-path=${LOCK_PATH}/nginx.lock
    --http-log-path=${LOG_PATH}/access.log
    --http-client-body-temp-path=${TEMP_PATH}/client
    --http-proxy-temp-path=${TEMP_PATH}/proxy
    --http-fastcgi-temp-path=${TEMP_PATH}/fastcgi
    --with-poll_module
    --with-http_ssl_module
    --with-http_flv_module
    --with-http_spdy_module
    --with-http_gzip_static_module
    --with-http_ssl_module
    --with-http_stub_status_module
    --with-http_realip_module
    --with-pcre-jit
    --with-ipv6
    --with-debug
"
# --with-http_image_filter_module
# --with-poll_module
# --with-select_module 
# --sbin-path=$BINARY_DIR

# Update Sources
sudo apt-get update

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
    wget http://nginx.org/download/$NGINX_TAR_GZ -O $NGINX_TAR_GZ
    wget http://nginx.org/download/$NGINX_TAR_GZ_PGP -O $NGINX_TAR_GZ_PGP
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

# why no create $NGINX_RUN_FILE_PATH/tmp
if [ ! -d "$NGINX_RUN_FILE_PATH/tmp" ]; then
    sudo mkdir -p $NGINX_RUN_FILE_PATH/tmp
fi

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
    echo \"Uninstall nginx now ...\" \n \
    sudo killall nginx \n \
    sudo rm -rf $PREFIX \n \
    sudo rm -rf $BINARY_DIR/nginx \n \
    sudo rm -rf $CONF_PATH \n \
    sudo rm -rf $NGINX_RUN_FILE_PATH \n \
    echo \"Uninstall nginx OK!\" \n \
    \" > $BINARY_DIR/uninstall_nginx"
sudo chmod a+x $BINARY_DIR/uninstall_nginx

