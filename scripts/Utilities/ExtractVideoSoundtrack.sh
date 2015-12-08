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
OPTION=

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
    echo "$0 [Options] VideoFullPath [AudioName]"
    echo ""
    echo "Options:"
    echo "  -d,--directory  Extract video soundtracks of the whole directory."
    echo "  -f,--file       Extract video soundtracks from file.(Default.)"
    exit 0
}

parseOption () {
    for arg in "$@";
    do
        case $arg in
            -*)
                OPTION=${OPTION:-$arg}
                ;;
            *)
                if [ "$VIDEO_PATH" = "" ]; then
                    VIDEO_PATH=$arg
                else
                    AUDIO_NAME=$arg
                fi
                ;;
        esac
    done
}

forOneFile() {
    local VIDEO_PATH=$1 #"$(echo $1 | sed -r 's/[ ]+/\\ /g')"
    local AUDIO_NAME="$(basename ${2:-"$VIDEO_PATH"}).mp3"

    if [ -e "$AUDIO_NAME" ]; then
        echo "File $AUDIO_NAME already exists."
        read -p "Are you sure to cover it ? (y/N): " answer
        # read -p answer
        case $answer in
            Y*|y*)
                ;;
            *)
                exit -1
                ;;
        esac
    fi

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

forOneDirectory() {
    local videoPath=$1
    if [ -f "$videoPath" ]; then
        videoPath=$(dirname "$videoPath")
    fi
    for each in $videoPath/*;
    do
        local fullPath=$each # "$videoPath/$(basename $each)"
        local nF=$(file -b --mime-type "$fullPath") 
        case $nF in
            video*)
                ;;
            *)
                echo "Sorry, $each not a video file."
                continue
                ;;
        esac

        forOneFile "$fullPath" # "$videoPath/$(basename $each)"
    done
}

main () {
    if [ $# -lt 1 ]; then
        help;
    fi

    depends;

    parseOption "$@"

    case $OPTION in
        -d)
            forOneDirectory "$VIDEO_PATH"
            ;;
        -f | "")
            forOneFile "$VIDEO_PATH" "$AUDIO_NAME"
            ;;
        *)
            echo "Error: "
            echo "  Unknown Option."
            help
            ;;
    esac
}

# Entrance
main "$@";
