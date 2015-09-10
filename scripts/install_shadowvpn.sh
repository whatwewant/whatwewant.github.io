#!/bin/bash

set -e

downloadTool="sudo apt-get install -y"
PACKAGE_DIR=/tmp/src
SRC_DIR=$PACKAGE_DIR
SRC_DIR_FINAL=${SRC_DIR}/shadowvpn
URL="https://github.com/whatwewant/ShadowVPN"
BINARY_DIR=/usr/local/sbin

# Config Options
#CONFIG_OPTIONS="
#    --user=$USER
#    --prefix=$PREFIX
#    --with-http_ssl_module
#    --with-http_realip_module
#    --with-ipv6
#"

# build-essential
$downloadTool build-essential
$downloadTool autoconf automake
$downloadTool libtool
$downloadTool git

if [ ! -d $PACKAGE_DIR ]; then 
    mkdir -p $SRC_DIR
else
    test -d $SRC_DIR_FINAL && rm -rf $SRC_DIR_FINAL
fi

# src
echo "Cloning Shadowsocks-libev to $SRC_DIR_FINAL ..."
git clone $URL $SRC_DIR_FINAL

# configure
cd $SRC_DIR_FINAL
git submodule update --init
./autogen.ssh
./configure --enable-static --sysconfdir=/etc

# make
make

# install
sudo make install
