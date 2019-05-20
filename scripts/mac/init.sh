#!/bin/bash

PACKAGES="
homebrew
zsh
vim
tmux
python
node
"

Install () {
  for e in "$@";
  do
    echo "Config $e ..."
    bash ./config_$e
    echo "Config $e Done"
    echo ""
  done
}

Install $PACKAGES
