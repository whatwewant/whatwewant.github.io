#!/bin/bash

# set -e

SCRIPT_PATH=$(cd `dirname $0`; pwd)
CURRENT_PATH=$(pwd)
APP_PATH=$CURRENT_PATH

source $CURRENT_PATH/BaseFunctionSets.sh >> /dev/null 2>&1

node -v >> /dev/null 2>&1
if [ "$?" != "0" ]; then
    ${SCRIPT_PATH}/config_nodejs.sh
fi

npm -v >> /dev/null 2>&1
if [ "$?" != "0" ]; then
    sudo apt-get install -y npm
fi

if [ "${SCRIPT_PATH}" = "${CURRENT_PATH}" ]; then
    echo "****************************************************************"
    echo "Tips:                                                          *"
    echo "  App Path is the path where you work, such as ~/Work ...      *"
    echo "Then you will work in AppPath/app ...                          *"
    echo "****************************************************************"
    echo ""
    read -p "Set App Path: " APP_PATH
    if [ ! -d "$APP_PATH" ]; then
        read -p "App Path doesn't exist. Do you want to make it ? (y|N)" answer
        case $answer in
            y|Y|Yes|yes)
                mkdir $APP_PATH
                ;;
            *)
                echo "Fail To Create Gulp Project."
                echo "Exit ..."
                exit -1
        esac
    fi
fi

# COPY GULP APP PROJECT TO CURRENT_PATH
if [ ! -d "${SCRIPT_PATH/../confs/gulp}" ]; then
    echo "  Fatal Error. Default Setting Error."
    echo " You are not in scripts directory."
fi
cp -r ${SCRIPT_PATH}/../confs/gulp ${APP_PATH}/app

echo ""
echo "Create Gulp App Successfully !"
echo "App Path: ${APP_PATH}"
echo ""
