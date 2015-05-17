#!/bin/bash

# set -e

CURRENT_PATH=$(cd `dirname $0`; pwd)
PROGRAM_DIR=$HOME/.config/ProgramFiles

source $CURRENT_PATH/BaseFunctionSets.sh

# download and install packages
PACKAGE_URL="http://download-cf.jetbrains.com/webstorm/WebStorm-10.0.2.tar.gz"
wgetToThenUntgz $PACKAGE_URL webstorm.tar.gz

# soft link
# sudo ln -s $PROGRAM_DIR/WebStorm-141.728/bin/webstorm.sh /usr/bin/webstorm
lnS WebStorm-141.728/bin/webstorm.sh webstorm
