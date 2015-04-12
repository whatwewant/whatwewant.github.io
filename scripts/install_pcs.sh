#!/bin/bash
# File Name: install_pcs.sh
# Author: Potter
# Mail: tobewhatwewant@gmail.com
# Created Time: 2015年01月01日 星期四 13时30分58秒

logDir=/tmp

git_log() {
    url=$1
    name=$2
    cd $logDir
    git clone $url $name
}

make_log() {
    make_dir=$1
    cd $make_dir
    make clean
    make && sudo make install
}

git_make() {
    url=$1
    name=$2
    git_log $url $name
    make_log $logDir/$name
}

# BaiduyunCloudTool: pcs
sudo apt-get install -y libcurl4-openssl-dev
# fatal error: openssl/md5.h
sudo apt-get install -y libssl-dev
git_make https://github.com/GangZhuo/baidupcs.git baidupcs
