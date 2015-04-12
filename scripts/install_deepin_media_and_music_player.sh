#!/bin/bash
# File Name: install_deepin_music_player.sh
# Author: Potter
# Mail: tobewhatwewant@gmail.com
# Created Time: 2015年01月05日 星期一 03时09分45秒

# source
deepin_music_source="deb http://mirrors.aliyun.com/deepin trusty main non-free universe"

# add source to sources.list
sudo bash -c "echo $deepin_music_source >> /etc/apt/sources.list"
sudo apt-get update

# deepin-music-player and plugins
sudo apt-get install -y --force-yes deepin-music-player
sudo apt-get install -y --force-yes dmusic-plugin-baidumusic
sudo apt-get install -y --force-yes deepin-media-player
sudo apt-get install -y --force-yes python-deepin-gsettings

# remove deepin music source
sudo sed -i "s%$deepin_music_source%%g" /etc/apt/sources.list
sudo apt-get update
