#!/bin/bash

# set -e

CURRENT_PATH=$(cd `dirname $0`; pwd)
PROGRAM_DIR=$HOME/.config/ProgramFiles
BINARY_DIRECTORY=/usr/local/bin

source $CURRENT_PATH/BaseFunctionSets.sh >> /dev/null 2>&1

if [ "$(checkNetwork)" = "0" ]; then
    # download and install packages
    PACKAGE_URL="http://mirrors.ustc.edu.cn/eclipse/technology/epp/downloads/release/mars/R/eclipse-jee-mars-R-linux-gtk-x86_64.tar.gz"
    wgetToThenUntgz $PACKAGE_URL eclipse.tar.gz

    # soft link
    # sudo ln -s $PROGRAM_DIR/WebStorm-141.728/bin/webstorm.sh /usr/bin/webstorm
    lnS eclipse/eclispe eclipse
else
    echo "No Network."
    echo "Like:"
    echo ""
    echo " ad/"
    echo "   - bin/idea.sh"
    echo "   - a"
    echo "   - b"
    echo "   - c"
    echo ""
    echo " Package Name: ad"
    echo " Package Address: path/to/xx.tar.gz"
    echo " Package Start Entrance: bin/idea.sh"
    read -p "Package Name(The Directory after uncompress.): " package_name
    read -p "Package Address(*.tar.gz, absolute path): " package_address
    read -p "Program Start Entrance: " program_start_entrance

    if [ "$package_name" = "" ] || \
        [ "$package_address" = "" ] || \
        [ "$program_start_entrance" = "" ] \
    ; then
        echo "Error: Empty Value."
        exit
    fi

    if [ ! -d "$PROGRAM_DIR/${package_name}" ]; then
        tar -zxvf $package_address -C $PROGRAM_DIR
    fi

    lnS "${package_name}/$program_start_entrance" eclipse
fi
