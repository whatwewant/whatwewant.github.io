#!/bin/bash

# set -e

CURRENT_PATH=$(cd `dirname $0`; pwd)

source $CURRENT_PATH/BaseFunctionSets.sh

# download and install packages
PACKAGE_URL="http://download.jetbrains.com/webide/PhpStorm-8.0.1.tar.gz"
wgetToThenUntgz $PACKAGE_URL phpstorm.tgz

# soft link
sudo ln -s /home/potter/.config/ProgramFiles/PhpStorm-138.2001.2328/bin/phpstorm.sh /usr/bin/phpstorm
