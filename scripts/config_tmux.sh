#!/bin/bash

set -e

PROGRAM_NAME=tmux
DESTINATION=~/.tmux/plugins/tpm
URL="https://github.com/ThomasAdam/tmux.git"

bash_url() {
    echo "Install $PROGRAM_NAME ..."
    url=$1
    script_name=bscript
    wget $url -O /tmp/$script_name && \
        bash /tmp/$script_name && \
        echo "Successed in installing $PROGRAM_NAME" || \
        echo "Failed to install $PROGRAM_NAME"
    echo "Install $PROGRAM_NAME end."
}

which tmux >> /dev/null
if [ "$?" != "0" ]; then
    bash_url https://whatwewant.github.io/scripts/install_tmux.sh
fi

tmux -V | grep -i 2
if [ "$?" != "0" ]; then
    bash_url https://whatwewant.github.io/scripts/install_tmux.sh
fi

# DESTINATION
echo "Cloning $PROGRAM_NAME to $DESTINATION ..."
git clone $URL $DESTINATION

# Config file .tmux.conf
echo "Backup $HOME/.tmux.conf to $HOME/.backup/tmux.conf ..."
mkdir ~/.backup >> /dev/null 2>&1
mv ~/.tmux.conf ~/.backup/tmux.conf 2&>1
echo "Get new .tmux.conf ..."
wget https://whatwewant.github.io/confs/tmux.conf -O ~/.tmux.conf

# Reload TMUX environment so TPM is sourced:
echo "Reload TMUX environment ..."
tmux source-file ~/.tmux.conf
