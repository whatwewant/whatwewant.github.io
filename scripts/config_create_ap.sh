#!/bin/bash

# https://github.com/oblique/create_ap

DTool="sudo apt-get install -y"

# Begin
echo "Starting Create Your Wifi ..."

# git
# hostapd
# iptables
# dnsmasq
$DTool --reinstall git hostapd iptables dnsmasq

# create_ap
git clone https://github.com/oblique/create_ap.git /tmp/create_ap

# install
cd /tmp/create_ap
sudo make install

# end
echo "Succeed in installing create_ap" 
echo "Then,"
echo "  $ create_ap -h # for help"
echo "Congratulation!"
