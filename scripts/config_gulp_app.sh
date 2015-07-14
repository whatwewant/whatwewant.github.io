#!/bin/bash
###############################################
# Usage:
#   ./gulp project_name
###############################################

# set -e

SCRIPT_PATH=$(cd `dirname $0`; pwd)
CURRENT_PATH=$(pwd)
APP_PATH=$CURRENT_PATH
TMP_DIR=/tmp
TMP_GIT_REPO=${TMP_DIR}/projbase
PROJ_NAME=$1

if [ "$PROJ_NAME" = "" ]; then
    echo "****************************"
    echo "* Usage: "
    echo "*   $0 proj_name"
    echo "****************************"
    exit -1
fi

source $CURRENT_PATH/BaseFunctionSets.sh >> /dev/null 2>&1

node -v >> /dev/null 2>&1
if [ "$?" != "0" ]; then
    ${SCRIPT_PATH}/config_nodejs.sh
fi

npm -v >> /dev/null 2>&1
if [ "$?" != "0" ]; then
    sudo apt-get install -y npm
fi

# Node Path
if [ "${NODE_PATH}" = "" ]; then
    NODE_PATH="$HOME/.config/ProgramFiles/node_modules"
    [[ "$SHELL" = "/bin/zsh" ]] && \
        SH_PROFILE=$HOME/.zshrc || \
        SH_PROFILE=$HOME/.bashrc
    cat $HOME/.zshrc| grep NODE_PATH >> /dev/null 2>&1 || \
        echo "NODE_PATH={NODE_PATH}" >> $SH_PROFILE
fi

if [ ! -d "${SCRIPT_PATH}/../confs" ]; then
    if [ ! -d "${TMP_GIT_REPO}" ]; then
        git clone https://github.com/whatwewant/whatwewant.github.io $TMP_GIT_REPO 
        if [ "$?" != "0" ]; then
            echo "Fatal Error: Need git tool."
            exit -1
        fi
    fi
    SCRIPT_PATH=${TMP_GIT_REPO}/scripts
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

if [ "$PROJ_NAME" != "" ]; then
    mkdir ${APP_PATH}/${PROJ_NAME}
    cp -r ${SCRIPT_PATH}/../confs/gulp ${APP_PATH}/${PROJ_NAME}/app
else
    cp -r ${SCRIPT_PATH}/../confs/gulp ${APP_PATH}/app
fi

echo ""
echo "Create Gulp App Successfully !"
echo "App Path: ${APP_PATH}/${PROJ_NAME}"
echo ""
