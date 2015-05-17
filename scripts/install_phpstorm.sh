#!/bin/bash

# set -e

CURRENT_PATH=$(cd `dirname $0`; pwd)
PROGRAM_DIR=$HOME/.config/ProgramFiles

source $CURRENT_PATH/BaseFunctionSets.sh

# download and install packages
PACKAGE_URL="http://download.jetbrains.com/webide/PhpStorm-8.0.1.tar.gz"
wgetToThenUntgz $PACKAGE_URL phpstorm.tgz

# soft link
sudo ln -s $PROGRAM_DIR/PhpStorm-138.2001.2328/bin/phpstorm.sh /usr/bin/phpstorm
