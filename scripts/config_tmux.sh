#!/bin/bash

# set -e

PROGRAM_NAME=tmux
DESTINATION=~/.tmux/plugins/tpm
URL="https://github.com/tmux-plugins/tpm.git"

bash_url() {
    echo "Install $PROGRAM_NAME ..."
    script_url=$1
    script_name=bscript
    wget $script_url -O /tmp/$script_name && \
        bash /tmp/$script_name && \
        echo "Successed in installing $PROGRAM_NAME" || \
        echo "Failed to install $PROGRAM_NAME"
    echo "Install $PROGRAM_NAME end."
}

which tmux >> /dev/null
if [ "$?" != "0" ]; then
    bash_url https://whatwewant.github.io/scripts/install_tmux.sh
fi

tmux -V | grep -i 2 >> /dev/null
if [ "$?" != "0" ]; then
    bash_url https://whatwewant.github.io/scripts/install_tmux.sh
fi

# Backup
[[ ! -d ~/.backup ]] && mkdir ~/.backup
if [ -f ~/.tmux.conf ]; then
    echo "Backup Tmux Configure to $HOME/.backup ..."
    [[ ! -d ~/.tmux ]] && mkdir ~/.tmux
    mv ~/.tmux.conf ~/.tmux
    tar -zcvf ~/.backup/tmux-$(date +%Y-%m-%d-at-%H-%M).tgz  ~/.tmux >> /dev/null 2>&1
fi
rm -rf ~/.tmux* >> /dev/null 2>&1

# DESTINATION
echo "Cloning $PROGRAM_NAME to $DESTINATION ..."
git clone $URL $DESTINATION

# Config file .tmux.conf
echo "Get new .tmux.conf ..."
wget https://whatwewant.github.io/confs/tmux.conf -O ~/.tmux.conf

# Reload TMUX environment so TPM is sourced:
echo "Reload TMUX environment ..."
tmux source-file ~/.tmux.conf

# Manual to click prefix + I to download tmux plugins
echo "Now You need munual to click prefix + I to download plugins"
