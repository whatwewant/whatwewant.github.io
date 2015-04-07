#!/bin/bash

# extern variables
SS=ss-redir
SS_IP=$1
SS_PORT=$2
SS_LOCAL_PORT=$3
SS_PASSWORD=$4
SS_METHOD=ase-256-cfb
SS_CONFIG_FILE=$HOME/.config/shadowsocks/shadowsocks.json
CHAIN_NAME=SHADOWSOCKS

# enumerate random
function random ()
{
    min=1503;
    max=65535;
    num=$(date +%s+%N);
    ((retnum=num%max+min));
    # echo $retnum;
    # return $retnum;
    SS_LOCAL_PORT=$retnum;
}

# random SS_PORT
random;

if [ ! -f $SS_CONFIG_FILE ]; then
    echo "First Use, Please Config Shadowsocks:"
    echo -n "Server IP: "
    read SS_IP
    echo -n "Server_PORT: "
    read SS_PORT
    echo -n "LOCAL_PORT: "
    read SS_LOCAL_PORT
    echo -n "Server Password: "
    read SS_PASSWORD
    echo -n "Server Method (Default: aes-256-cfb): "
    read SS_METHOD
fi

# root
# if [ "$UID" != "0" ]; then
#    echo "You must use root priviledge!";
#    exit -1;
# fi

# iptables
which iptables;
if [ "$?" != "0" ]; then
    echo "Please install iptables first.";
    exit;
fi

# shadowsocks
which $SS
if [ "$?" != "0" ]; then
    echo "Please install shadowsocks first."
    exit
fi 

# iptables
sudo ptables -t nat -L $CHAIN_NAME >> /dev/null
if [ "$?" != "0" ]; then
    sudo iptables -t nat -N $CHAIN_NAME
fi
sudo iptables -t nat -F

## iptables Ignore shadowsocks address
sudo iptables -t nat -A $CHAIN_NAME -d $SS_IP -j RETURN

## Ignore LANs and any other addresses you'd like to bypass the proxy
sudo iptables -t nat -A $CHAIN_NAME -d 0.0.0.0/8 -j RETURN
sudo iptables -t nat -A $CHAIN_NAME -d 10.0.0.0/8 -j RETURN
sudo iptables -t nat -A $CHAIN_NAME -d 127.0.0.0/8 -j RETURN
sudo iptables -t nat -A $CHAIN_NAME -d 169.254.0.0/16 -j RETURN
sudo iptables -t nat -A $CHAIN_NAME -d 172.16.0.0/12 -j RETURN
sudo iptables -t nat -A $CHAIN_NAME -d 192.168.0.0/16 -j RETURN
sudo iptables -t nat -A $CHAIN_NAME -d 224.0.0.0/4 -j RETURN
sudo iptables -t nat -A $CHAIN_NAME -d 240.0.0.0/4 -j RETURN

## Anything else should be redirected to shadowsocks's local port
sudo iptables -t nat -A $CHAIN_NAME -j REDiRECT --to-ports $SS_LOCAL_PORT

# Apply the rules
sudo iptables -t nat -L OUTPUT | grep $SHADOWSOCKS >> /dev/null
if [ "$?" != "0" ]; then 
    sudo iptables -t nat -I OUTPUT -j $CHAIN_NAME
fi

## SAVE iptables config
sudo iptables-save

# config shadowsocks
if [ ! -d "$HOME/.config/shadowsocks" ]; then
    mkdir $HOME/.config/shadowsocks;
fi
if [ ! -f "$SS_CONFIG_FILE" ]; then
    echo "{" > $SS_CONFIG_FILE
    echo "  \"server\": \"$SS_IP\"," >> $SS_CONFIG_FILE
    echo "  \"server_port\": $SS_PORT," >> $SS_CONFIG_FILE
    echo "  \"local_port\": $SS_LOCAL_PORT," >> $SS_CONFIG_FILE
    echo "  \"password\": \"$SS_PASSWORD\"," >> $SS_CONFIG_FILE
    echo "  \"method\": \"$SS_PASSWORD\"" >> $SS_CONFIG_FILE
    echo "}" >> $SS_CONFIG_FILE
else
    echo "ConfigFile Already Exist: $SS_CONFIG_FILE"
    echo "Use Old Config."
fi

# Start the shadowsocks-redir
if [ "$1" == "-d" ]; then
    echo "Shadowsocks Daemon Now."
    $SS -c $SS_CONFIG_FILE -f /tmp/shadowsocks.pid
else 
    $SS -c $SS_CONFIG_FILE
fi
