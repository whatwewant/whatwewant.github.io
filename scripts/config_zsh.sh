#!/bin/bash

user=$(whoami)
userPassword=$1

script_path=$(cd `dirname $0`; pwd)
source $script_path/BaseFunctionSets.sh >> /dev/null 2>&1
startLog

# install zsh
which zsh >> /dev/null
if [ "$?" != "0" ]; then
    downloadLog zsh
fi

# config zsh
if [ ! -d "/home/$user/.oh-my-zsh" ]; then
    git clone https://github.com/whatwewant/oh-my-zsh ~/.oh-my-zsh
fi

if [ -f "/home/$user/.zshrc" ]; then
    cp ~/.zshrc ~/.zshrc.orig
fi
cp ~/.oh-my-zsh/templates/potter.zshrc ~/.zshrc

# change sh
if [ "$SHELL" != "/bin/zsh" ]; then
    if [ "$userPassword" != "" ]; then
        echo $userPassword | chsh -s /bin/zsh # 
    else
        chsh -s /bin/zsh # 
    fi
else
    echo "now is in zsh environment."
fi

endLog
