#!/bin/bash

set -e

downloadTool="sudo apt-get install -y"
PACKAGE_DIR=/tmp/src
SRC_DIR=$PACKAGE_DIR

NGINX_VERSION=1.11.2
NGINX_TAR_GZ_NAME=nginx-${NGINX_VERSION}.tar.gz
NGINX_TAR_GZ=${PACKAGE_DIR}/${NGINX_TAR_GZ_NAME}
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
PREFIX=/usr/local/nginx # default /usr/local/nginx
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
    --with-http_v2_module
    --with-http_ssl_module
    --with-http_flv_module
    --with-http_mp4_module
    --with-http_gzip_static_module
    --with-http_secure_link_module
    --with-http_stub_status_module
    --with-http_realip_module
    --with-pcre-jit
    --with-ipv6
    --with-file-aio
    --with-mail
    --with-mail_ssl_module
    --with-debug
"
# --with-http_spdy_module
# --with-http_image_filter_module
# --with-poll_module
# --with-select_module 
# --sbin-path=$BINARY_DIR

echoError() {
    local reason=$1
    echo ""
    echo "Error:"
    echo "  $reason"
    echo ""
}

checkMD5 () {
    local md5sumResult=$(md5sum ${NGINX_TAR_GZ} | awk '{print $1}')
    local md5sum_1_7_0=017ca65f0101915143b7211977bb5dd2
    local md5sum_1_8_0=3ca4a37931e9fa301964b8ce889da8cb
    local md5sum_1_9_0=487c26cf0470d8869c41a73621847268
    case $NGINX_VERSION in
        1.9.0)
            if [ "$md5sumResult" != "$md5sum_1_9_0" ]; then
                echoError "$NGINX_TAR_GZ_NAME md5sum doest match $md5sum_1_9_0"
                exit -1
            fi
            ;;
        1.8.0)
            if [ "$md5sumResult" != "$md5sum_1_8_0" ]; then
                echoError "$NGINX_TAR_GZ_NAME md5sum doest match $md5sum_1_8_0"
                exit -1
            fi
            ;;
        1.7.0)
            if [ "$md5sumResult" != "$md5sum_1_7_0" ]; then
                echoError "$NGINX_TAR_GZ_NAME md5sum doest match $md5sum_1_7_0"
                exit -1
            fi
            ;;
    esac
}

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
    wget -c http://nginx.org/download/$NGINX_TAR_GZ_NAME -O $NGINX_TAR_GZ
    wget -c http://nginx.org/download/$NGINX_TAR_GZ_PGP -O $NGINX_TAR_GZ_PGP
fi
# check md5 for nginx-$NGINX_VERSION.tar.gz file
checkMD5


# src
tar -zxvf $NGINX_TAR_GZ -C $SRC_DIR

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
[[ -f $BINARY_DIR/nginx ]] && sudo rm -rf $BINARY_DIR/nginx
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

