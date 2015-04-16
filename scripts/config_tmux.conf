#!/bin/bash

set -e

PROGRAM_NAME=tmux
DESTINATION=~/.tmux/plugins/tpm
URL="https://github.com/ThomasAdam/tmux.git"

which tmux >> /dev/null
if [ "$?" != "0" ]; then
    wget https://whatwewant.github.io/scripts/install_tmux.sh -O /tmp/install_tmux
    bash /tmp/install_tmux
fi

tmux -V | grep -i 2
if [ "$?" != "0" ]; then
    wget https://whatwewant.github.io/scripts/install_tmux.sh -O /tmp/install_tmux
    bash /tmp/install_tmux
fi

# DESTINATION
echo "Cloning $PROGRAM_NAME to $DESTINATION ..."
git clone $URL $DESTINATION

# Config file .tmux.conf
wget https://whatwewant.github.io/confs/tmux.conf -O ~/.tmux.conf

# Reload TMUX environment so TPM is sourced:
tmux source-file ~/.tmux.conf
