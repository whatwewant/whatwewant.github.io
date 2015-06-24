#!/bin/bash

# set -e
CURRENT_PATH=$(cd `dirname $0`; pwd)
DATE_TODAY=$(date +%Y-%m-%d)

PACKAGE_DIR=/tmp/src
CONFIG_DIR=$HOME/.config/Cud
LOG_FILE=$CONFIG_DIR/INSTALL_PACKAGES_${DATE_TODAY}.log

# FUNCTION
initialize () {
    sudo ls /tmp >> /dev/null 2>&1
    [[ ! -d $CONFIG_DIR ]] && mkdir -p $CONFIG_DIR
    [[ ! -d $PACKAGE_DIR ]] && mkdir -p $PACKAGE_DIR
    export PATH=$CURRENT_PATH:$PATH
}

# Ctrl-C to exit
ExitNow () {
    trap "" SIGINT
    trap "" SIGUSR1
    exit 0
}

SetExitMark () {
    trap "ExitNow" SIGINT
    trap "ExitNow" SIGUSR1
}

# Begin
initialize
SetExitMark

# python

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

# PACKAGES
pipLog ipython
pipLog virtualenv virtualenvwrapper
pipLog requests # grequests
pipLog django djangorestframework
pipLog flask
pipLog qduTAportal qdudomportal simplefileserver
pipLog speedtest-cli
pipLog BeautifulSoup4
