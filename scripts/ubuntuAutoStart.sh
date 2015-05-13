#!/bin/bash
# File Name: ubuntuAutoStart.sh
# Author: Potter
# Mail: Whatwewant@gmail.com
# Created Time: 2014年10月28日 星期二 16时05分05秒

export PATH=.:$PATH

if [ "$#" != "2" ]; then
    echo "Usage:"
    echo "  $0 scriptName command [Options]"
    echo "Such as:"
    echo "  $0 ACBI /usr/bin/ACBI &"
    echo ""
    exit -1
fi

scriptName=$1".desktop"
name=$1
execCommand=$2

for arg in $@
do
    if [ $arg != $0 ] && [ $arg != $1 ] && [ $arg != $2 ]; then
        execCommand=$execCommand" $arg"
    fi
done

if [ ! -d ~/.config ]; then
    mkdir ~/.config
fi

if [ ! -d ~/.config/autostart ]; then
    mkdir ~/.config/autostart
fi

cd ~/.config/autostart

touch $scriptName

# 
echo "Type=Application" > $scriptName
echo "Exec=$execCommand" >> $scriptName
echo "Hidden=false" >> $scriptName
echo "NoDisplay=false" >> $scriptName
echo "X-GNOME-Autostart-enabled=true" >> $scriptName
echo "Name[en_US]=$name" >> $scriptName
echo "Name=$name">> $scriptName
echo "Comment[en_US]=" >> $scriptName
echo "Comment[en_US]=" >> $scriptName


