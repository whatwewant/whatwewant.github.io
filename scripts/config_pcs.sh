#!/bin/bash
# File Name: config_pcs.sh
# Author: Potter
# Mail: tobewhatwewant@gmail.com
# Created Time: 2014年11月05日 星期三 18时42分05秒

export PATH=.:$PATH

TMPDIR=/tmp

which pcs >> /dev/null
if [ "$?" != "0" ]; then
    echo "Pcs 不存在，正在为你安装pcs"
    cd $TMPDIR
    sudo apt-get install -y git make cmake
    sudo apt-get install -y libcurl4-openssl-dev
    sudo rm -rf $TMPDIR/pcs
    git clone https://github.com/GangZhuo/baidupcs.git $TMPDIR/pcs
    cd $TMPDIR/pcs
    make
    sudo make install
    cd -

    # echo "Login Now"
    # pcs login
fi

