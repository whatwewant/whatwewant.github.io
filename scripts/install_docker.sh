#!/bin/bash


script_path=$(cd `dirname $0`; pwd)
source $script_path/BaseFunctionSets.sh >> /dev/null 2>&1
startLog

wget -qO- https://get.docker.com/ | sh

endLog
