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
PROGRAM_DIR=$HOME/.config/ProgramFiles

menu() {
    echo -e "
    Function Sets 
        (For detail: $0 about FUNCTION_NAME):
    "
#    dpkgLog
#    wgetTo 
#    wgetThenDpkg 
#    initialize 
#    downloadLog
#    pipLog
#    pip3Log
#    easy_installLog
#    makeLog
#    gitThenMake
#    wgetToThenUntgz
#    "
    cat BaseFunctionSets.sh| grep -i \(\) | awk -F '\(' '{print "    "$1}'
}

initialize () {
    # Usage:
    #   initialize
    sudo ls /tmp >> /dev/null 2>&1
    [[ ! -d $CONFIG_DIR ]] && mkdir -p $CONFIG_DIR
    [[ ! -d $PACKAGE_DIR ]] && mkdir -p $PACKAGE_DIR
    [[ ! -d $PROGRAM_DIR ]] && mkdir -p $PROGRAM_DIR
    export PATH=$CURRENT_PATH:$PATH
}

dpkgLog() {
    if [ "$1" == "about" ]; then
        echo "Usage:"
        echo "  dpkgLog path/to/package1 path/to/package2 ..."
        exit 0
    fi

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
    if [ "$1" == "about" ]; then
        echo "Usage:"
        echo "  wgetTo 下载链接URL 存取文件名"
        exit 0
    fi
    wTurl=$1
    wTnewname=$2
    wget -c $wTurl -O $PACKAGE_DIR/$wTnewname
}

wgetThenDpkg () {
    if [ "$1" == "about" ]; then
        echo "Usage:"
        echo "  wgetThenDpkg 下载链接URL 存取文件名"
        exit 0
    fi

    wTDurl=$1
    wTDname=$2
    wgetTo $wTDurl $wTDname && \
        dpkgLog $wTDname
}

downloadLog() {
    if [ "$1" == "about" ]; then
        echo "Usage:"
        echo "  downloadLog path/to/package1 path/to/package2 ..."
        exit 0
    fi
    # 使用前修复依赖
    sudo apt-get -f -y install

    for argv in "$@"
    do
        sudo apt-get install -y $argv && \
        echo "(APT-GET)Succeed in installing --> $argv $(date)" >> $LOG_FILE || \
        echo "(APT-GET)ERROR: Failed to install --> $argv $(date)" >> $LOG_FILE
    done
}

pipLog() {
    if [ "$1" == "about" ]; then
        echo "Usage:"
        echo "  pipLog path/to/package1 path/to/package2 ..."
        exit 0
    fi
    for argv in "$@"
    do
        sudo pip install $argv && \
            echo "(PIP)Succeed in installing --> $argv" >> $LOG_FILE || \
            echo "(PIP)ERROR: Failed to install $argv" >> $LOG_FILE
    done
}

pip3Log() {
    if [ "$1" == "about" ]; then
        echo "Usage:"
        echo "  pip3Log path/to/package1 path/to/package2 ..."
        exit 0
    fi
    for argv in "$@"
    do
        sudo pip3 install $argv && \
            echo "(PIP3)Succeed in installing --> $argv" >> $LOG_FILE || \
            echo "(PIP3)ERROR: Failed to install $argv" >> $LOG_FILE
    done
}

easy_installLog() {
    if [ "$1" == "about" ]; then
        echo "Usage:"
        echo "  easy_installLog path/to/package1 path/to/package2 ..."
        exit 0
    fi

    for argv in "$@"
    do
        sudo easy_install $argv && \
            echo "(EASY_INSTALL)Succeed in installing --> $argv" >> $LOG_FILE || \
            echo "(EASY_INSTALL)ERROR: Failed to install $argv" >> $LOG_FILE
    done
}

makeLog() {
    if [ "$1" == "about" ]; then
        echo "Usage:"
        echo "  makeLog PROGRAM_NAME"
        exit 0
    fi
    PROGRAM_NAME=$1
    make_dir=$PACKAGE_DIR/$PROGRAM_NAME
    cd $make_dir
    make clean
    make && sudo make install && \
        echo "(MAKE)Succeed in installing --> $PROGRAM_NAME $(date)" >> $LOG_FILE || \
        echo "(MAKE)ERROR: Failed to install $PROGRAM_NAME $(date)" >> $LOG_FILE
}

gitThenMake() {
    if [ "$1" == "about" ]; then
        echo "Usage:"
        echo "  gitThenMake 项目地址URL 自定义项目名"
        exit 0
    fi
    gTMURL=$1
    gTMNAME=$2
    git clone $gTMURL $PACKAGE_DIR/$gTMNAME && \
        make_log $gTMNAME
}

wgetToThenUntgz () {
    if [ "$1" == "about" ]; then
        echo "Usage:"
        echo "  wgetToThenUntgz 压缩文件地址URL 自定义文件名"
        exit 0
    fi
    pack_url=$1
    pack_name=$2
    wgetTo $pack_url $pack_name
    tar -zxvf $PACKAGE_DIR/$pack_name -C $PROGRAM_DIR && \
        echo "(ProgramFile) Succeed ProgramFile: $name to $PROGRAM_DIR $(date +%Y-%m-%d\ %H-%M-%S)" >> $LOG_FILE || \
        echo "(ProgramFile) Failed ProgramFile: $name to $PROGRAM_DIR $(date +%Y-%m-%d\ %H-%M-%S)" >> $LOG_FILE
}

lnS () {
    if [ "$1" == "about" ]; then
        echo "Usage:"
        echo "  lnS 实际地址 DIY_COMMAND_NAME"
        echo "(\$1 in $PROGRAM_DIR, \$2 in /usr/local/bin)"
        exit 0
    fi
    app=$1
    name=$2
    sudo ln -s $PROGRAM_DIR/$app /usr/local/bin/$2
}

# 初始化
initialize;

case $1 in
    -h|--help)
        menu
        ;;
    about)
        [[ "$2" = "" ]] && menu && exit 0
        $2 about 2>>/dev/null
        [[ "$?" != "0" ]] && echo "Function $2 doesnot exist."
        ;;
    *)
        menu
        ;;
esac
