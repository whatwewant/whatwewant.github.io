#!/bin/bash
# File Name: config_init_background_image.sh
# Author: Potter
# Mail: tobewhatwewant@gmail.com
# Created Time: 2015年01月01日 星期四 13时41分30秒
# wget https://raw.githubusercontent.com/whatwewant/pScript/master/wallpaper/wallpaper.jpg

script_path=$(cd `dirname $0`; pwd)

sudo cp ${script_path}/google-chrome.desktop /usr/share/applications/
