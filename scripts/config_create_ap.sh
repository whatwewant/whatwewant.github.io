#!/bin/bash

# https://github.com/oblique/create_ap

script_path=$(cd `dirname $0`; pwd)
source $script_path/BaseFunctionSets.sh >> /dev/null 2>&1
startLog

DTool="sudo apt-get install -y"

# Begin
echo "Starting Create Your Wifi ..."

# git
# hostapd
# iptables
# dnsmasq
$DTool --reinstall git hostapd iptables dnsmasq

# create_ap
git clone https://github.com/oblique/create_ap.git $PACKAGE_DIR/create_ap

# install
cd /tmp/create_ap
sudo make install

# end
echo "Succeed in installing create_ap" 
echo "Then,"
echo "  $ create_ap -h # for help"
echo "Congratulation!"

endLog
