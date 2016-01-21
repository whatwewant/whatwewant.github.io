#!/bin/zsh
###############################################
# Usage:
#   ./gulp project_name
###############################################

# set -e

export PATH=$PATH
source $HOME/.zshrc

SCRIPT_PATH=$(cd `dirname $0`; pwd)
CURRENT_PATH=$(pwd)
APP_PATH=$CURRENT_PATH
TMP_DIR=/tmp
TMP_GIT_REPO=${TMP_DIR}/projbase
PROJ_NAME=$1

GIT_RESPOSITY="https://github.com/whatwewant/whatwewant.github.io"
GIT_DIR=$HOME/.config/git
GIT_BLOG=$GIT_DIR/blog

WORK_DIR=$HOME/Work/GulpProj
APP_PATH=$WORK_DIR

SCRIPT_PATH=$GIT_BLOG/scripts

if [ "$PROJ_NAME" = "" ]; then
    echo "****************************"
    echo "* Usage: "
    echo "*   $0 proj_name"
    echo "****************************"
    exit -1
fi

if [ ! -d "$WORK_DIR" ]; then
    mkdir -p $WORK_DIR
fi

if [ ! -d "$GIT_DIR" ]; then
    echo "Why this ? Because this is the first time you use it."
    mkdir -p $GIT_DIR
    if [ ! -d "$GIT_BLOG" ]; then
        git clone $GIT_RESPOSITY $GIT_BLOG
        if [ "$?" != "0" ]; then
            echo "Fatal Error: Need git tool."
            exit -1
        fi
    fi
fi

which gulp_app >> /dev/null 2>&1
if [ "$?" != "0" ]; then
    sudo cp $SCRIPT_PATH/config_gulp_app.sh /usr/bin/gulp_app
    echo "You can use:"
    echo "   gulp_app PROJ_NAME"
    echo ""
fi

# source $SCRIPT_PATH/BaseFunctionSets.sh >> /dev/null 2>&1

nvm --version >> /dev/null 2>&1
if [ "$?" != "0" ]; then
    ${SCRIPT_PATH}/config_nodejs.sh
    nvm install v5.4.0
fi

nvm use v5.4.0 >> /dev/null 2>&1 # for node v5.4.0

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
    cat $SH_PROFILE | grep NODE_PATH >> /dev/null 2>&1 || \
        echo "NODE_PATH=${NODE_PATH}" >> $SH_PROFILE
fi

if [ ! -d "${SCRIPT_PATH}/../confs" ]; then
    if [ ! -d "${TMP_GIT_REPO}" ]; then
        git clone https://github.com/whatwewant/whatwewant.github.io $GIT_BLOG 
        if [ "$?" != "0" ]; then
            echo "Fatal Error: Need git tool."
            exit -1
        fi
    fi
    SCRIPT_PATH=${GIT_BLOG}/scripts
fi

if [ "$PROJ_NAME" != "" ]; then
    if [ -d "$APP_PATH/$PROJ_NAME" ]; then
        echo "Error: "
        echo "  Project $PROJ_NAME already exists."
        echo "  App Path: $APP_PATH"
        echo ""
        exit -1
    fi
    mkdir ${APP_PATH}/${PROJ_NAME}
    cp -r ${SCRIPT_PATH}/../confs/gulp ${APP_PATH}/${PROJ_NAME}
fi

echo ""
echo "Create Gulp App Successfully !"
echo "App Path      : ${APP_PATH}"
echo "Project Name  : ${PROJ_NAME}"
echo ""
