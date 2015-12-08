#!/bin/bash
# 
# *************************************************
# File Name    : ExtractVideoSoundtrack.sh
# Author       : Cole Smith
# Mail         : tobewhatwewant@gmail.com
# Github       : whatwewant
# Created Time : 2015年12月09日 星期三 00时05分17秒
# Description  :
#     Extract Video Soundtrack to MP3
# *************************************************
set -e

VIDEO_PATH=
AUDIO_NAME=

checkDepends () {
    which $1 >> /dev/null 2>&1
    if [ ! $? -eq 0 ]; then
        echo "Please Install Depends: $1"
        exit -1
    fi
}

depends () {
    checkDepends mencoder
}

help() {
    echo "$0 VideoFullPath [AudioName]"
    exit 0
}

main () {
    if [ $# -lt 1 ]; then
        help;
    fi

    depends;

    VIDEO_PATH=$1 #"$(echo $1 | sed -r 's/[ ]+/\\ /g')"
    AUDIO_NAME="$(basename ${2:-"$VIDEO_PATH"}).mp3"

    echo "****************************************************************"
    echo "* Extract Video Soundtrack"
    echo "*     FROM: $(basename $VIDEO_PATH) (Path: $(dirname $VIDEO_PATH))"
    echo "*     TO: $AUDIO_NAME"
    echo "****************************************************************"
    mencoder -o "$AUDIO_NAME" \
        -ovc frameno \
        -oac mp3lame \
        -lameopts cbr:br=128 \
        -of rawaudio "$VIDEO_PATH"
}

# Entrance
main "$@";

