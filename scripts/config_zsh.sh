#!/bin/bash

user=$(whoami)

# install zsh
which zsh >> /dev/null
if [ "$?" != "0" ]; then
    sudo apt-get install -y zsh
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
    chsh -s /bin/zsh # 
else
    echo "now is in zsh environment."
fi
