#!/bin/bash
#
###########################################
#
#  Office: http://fishshell.com/
#
###########################################

set -e

downloadTool="sudo apt-get install -y"
PACKAGE_DIR=/tmp/src
PROGRAM_NAME=tmux
SRC_DIR=$PACKAGE_DIR
SRC_DIR_FINAL=${SRC_DIR}/$PROGRAM_NAME
URL="https://github.com/fish-shell/fish-shell.git"
BINARY_DIR=/usr/local/sbin

# Config Options
#CONFIG_OPTIONS="
#    --user=$USER
#    --prefix=$PREFIX
#    --with-http_ssl_module
#    --with-http_realip_module
#    --with-ipv6
#"

sudo apt-get install -y build-essential \
    ncurses-dev libncurses5-dev gettext

if [ ! -d $PACKAGE_DIR ]; then 
    mkdir -p $SRC_DIR
else
    test -d $SRC_DIR_FINAL && rm -rf $SRC_DIR_FINAL
fi

# src
echo "Cloning $PROGRAM_NAME to $SRC_DIR_FINAL ..."
git clone $URL $SRC_DIR_FINAL

# configure
cd $SRC_DIR_FINAL
autoconf
./configure

# make
make

# install
sudo make install

# change shell
chsh -s /usr/local/bin/fish
# config fish shell
# fish_config
# To scan your man pages for completions, run 'fish_update_completions'
