#!/bin/bash

# set -e

CURRENT_PATH=$(cd `dirname $0`; pwd)

# downloadTool="sudo apt-get install -y"
PACKAGE_DIR=/tmp/src
# SRC_DIR=$PACKAGE_DIR
# SRC_DIR_FINAL=${SRC_DIR}/shadowsocks
# URL="https://github.com/madeye/shadowsocks-libev.git"
# BINARY_DIR=/usr/local/sbin
CONFIG_DIR=$HOME/.config/Cud
LOG_FILE=$CONFIG_DIR/INSTALL_PACKAGES.log

dpkgLog() {
    # 使用前修复依赖
    sudo apt-get -f -y install >> /dev/null 2>&1

    for argv in "$@"
    do
        sudo dpkg -i $PACKAGE_DIR/$argv && \
            echo "(DPKG)Succeed in installing --> $argv $(date)" >> $LOG_FILE || \
            echo "(DPKG)ERROR: Failed to install --> $argv $(date)" >> $LOG_FILE
        sudo apt-get -f -y install >> /dev/null 2>&1
    done
}

wgetTo () {
    wTurl=$1
    wTnewname=$2
    wget -c $wTurl -O $PACKAGE_DIR/$wTnewname
}

wgetThenDpkg () {
    wTDurl=$1
    wTDname=$2
    wgetTo $wTDurl $wTDname && \
        dpkgLog $wTDname
}

initialize () {
    sudo ls /tmp >> /dev/null 2>&1
    [[ ! -d $CONFIG_DIR ]] && mkdir -p $CONFIG_DIR
    [[ ! -d $PACKAGE_DIR ]] && mkdir -p $PACKAGE_DIR
    export PATH=$CURRENT_PATH:$PATH
}

# Begin
initialize

# download and install packages
# PACKAGE_URL="http://pinyin.sogou.com/linux/download.php?f=linux&bit=64"
PACKAGE_URL="http://download.ime.sogou.com/1408440412/sogou_pinyin_linux_1.1.0.0037_amd64.deb"
wgetThenDpkg $PACKAGE_URL sougou.deb
