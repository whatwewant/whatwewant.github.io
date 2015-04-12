#!/bin/bash
# File Name: config_desktop_shortcuts.sh
# Author: Potter
# Mail: tobewhatwewant@gmail.com
# Created Time: 2014年12月22日 星期一 10时36分27秒

TPATH=""
CorrectTPATH() {
    TPATH=$1
    if [ "$TPATH" = "." ]; then
        TPATH=$(pwd)
    elif [ "${TPATH:${#TPATH}-1:1}" = "/" ]; then
        TPATH=${TPATH:0:${#TPATH}-1}
    fi
}

if [ "$#" != "5" ]; then
    echo "Usage:"
    echo "    $0 NAME COMMAND_TPATH COMMAND ICON_TPATH ICON"
    echo "Like: $0 AndroidStudio /TPATH/to studio.sh /TPATH/to studioPhoto"
    exit
fi

NAME=$1
FILE_NAME=$HOME/Desktop/$1.desktop
COMMAND_TPATH=$2
COMMAND=$3
ICON_TPATH=$4
ICON=$5

# if [ "$COMMAND_TPATH" = "." ]; then
#    COMMAND_TPATH=$(pwd)
# elif [ "${COMMAND_TPATH:${#COMMAND_TPATH}-1:1}" = "/" ]; then
#    COMMAND_TPATH=${COMMAND_TPATH:0:${#COMMAND_TPATH}-1}
# fi

# if [ "$ICON_TPATH" = "." ]; then
#    ICON_TPATH=$(pwd)
# elif [ "${ICON_TPATH:${#ICON_TPATH}-1:1}" = "/" ]; then
#    ICON_TPATH=${ICON_TPATH:0:${#ICON_TPATH}-1}
# fi

CorrectTPATH $COMMAND_TPATH
COMMAND_TPATH=$TPATH

CorrectTPATH $ICON_TPATH
ICON_TPATH=$TPATH

COMMAND=$COMMAND_TPATH/$COMMAND
ICON=$ICON_TPATH/$ICON

echo "#!/usr/bin/env xdg-open" > $FILE_NAME
echo "[Desktop Entry]" >> $FILE_NAME
echo "Version=1.0" >> $FILE_NAME
echo "Terminal=false " >> $FILE_NAME
echo "Type=Application" >> $FILE_NAME
echo "Name=$NAME" >> $FILE_NAME
echo "Exec=$COMMAND" >> $FILE_NAME
echo "Icon=$ICON" >> $FILE_NAME

# add executive power
chmod +x $FILE_NAME
