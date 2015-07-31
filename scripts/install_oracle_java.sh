#!/bin/bash

# set -e

CURRENT_PATH=$(cd `dirname $0`; pwd)
PROGRAM_DIR=$HOME/.config/ProgramFiles
BINARY_DIRECTORY=/usr/local/bin

source $CURRENT_PATH/BaseFunctionSets.sh >> /dev/null 2>&1

sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
sudo apt-get install -y oracle-java8-installer
