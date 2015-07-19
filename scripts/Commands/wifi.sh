#!/bin/bash

# set -e

CURRENT_PATH=$(cd `dirname $0`; pwd)
PROGRAM_DIR=$HOME/.config/ProgramFiles
BINARY_DIRECTORY=/usr/local/bin

TIME_STEMP=$(date +%s%N)
WIFI_NAME=${TIME_STEMP:5:6}
WIFI_PASSWORD=${TIME_STEMP:11:8}
FROM_NETWORK_INTERFACE=wlan0
TO_NETWORK_INTERFACE=eth0
MAC_ADDRESS="00:${TIME_STEMP:13:2}:${TIME_STEMP:15:2}:${TIME_STEMP:17:2}:${TIME_STEMP:16:2}:${TIME_STEMP:14:2}"
WIFI_INFO_FILE=/tmp/wifi_info
ERROR_LOG=/tmp/wifi_log
IP_SEGMENT="192.168.12.0/24"
WIFI_IPTABLE="wifi"

Menu () {
    echo "$0 start|stop|restart|help|info|users"
    echo ""
    echo "Option: "
    echo " -c filename  Load UserName and Password From file."
    echo " -l speed     Limit speed, (MTU = 1500 Byte = 1.46 KB), such 100 = 100*1.46 KB."
    echo " -i interface In Interface"
    echo " -o interface Out Interface"
    echo ""
    echo "Example:"
    echo "  wifi on/off"
    echo "  wifi on -g"
    echo "  wifi on --limit 300"
    echo "  wifi --limit 300"
}

getUser () {
    userInfo=$(create_ap --list-running | grep -i wlan)
    # [[ "$userInfo" = "" ]] && userCount=0 || \
    #    userCount=$(echo $userInfo | wc -l)
    userCount=0
    userDetail=$(echo $userInfo | awk '{print $1}')
    
    # if [ "$userCount" != "0" ]; then
    echo "Users Detail: (ID $userDetail)"
    # fi
    line=0
    for id in $userDetail; do
        tmp=$(create_ap --list-clients $id | wc -l)
        userCount=$(($userCount + $tmp))
        if [ "$line" = "0" ]; then
            echo "$(create_ap --list-clients $id)"
            line=1
        else
            echo "$(create_ap --list-clients $id | grep 192.168.12)"
        fi
    done

    echo ""
    echo "Total Users: $((userCount - 1))"
}

case $1 in
    "" | start | on)
        ps -e | grep -i create_ap >> /dev/null 2>&1
        [[ "$?" = "0" ]] && \
            echo "WIFI Already starts. You can restart it Manually." && \
            exit -1
        echo "Starting Wifi Now ..."
        ;;
    stop | off)
        echo "Stopping Wifi ..."
        wifi_iptable_drop=$(sudo iptables -L FORWARD --line-number | grep -i ${WIFI_IPTABLE} | head -n 1 | awk '{print $1}')
        [[ "$wifi_iptable_drop" != "" ]] && \
            sudo iptables -D FORWARD ${wifi_iptable_drop} >> /dev/null 2>&1
        sudo create_ap --stop $FROM_NETWORK_INTERFACE >> $ERROR_LOG 2>&1
        [[ "$?" != "0" ]] && \
            echo "Failed to stop ..."
            echo "Look at log ${ERROR_LOG}"
        exit 0
        ;;
    restart)
        echo "Restarting Wifi ..."
        $0 stop
        sleep 1
        $0 start
        sleep 2
        $0 info
        exit 0
        ;;
    info)
        ps -e | grep -i create_ap >> /dev/null 2>&1
        [[ "$?" != "0" ]] && echo "WIFI State: OFF" || \
            (echo "WIFI State: ON" && cat $WIFI_INFO_FILE)
        exit 0
        ;;
    state)
        ps -e | grep -i create_ap >> /dev/null 2>&1
        [[ "$?" != "0" ]] && echo "WIFI State: OFF" || \
            echo "WIFI State: ON"
        exit 0
        ;;
    users)
        $0 state | grep ON >> /dev/null 2>&1
        if [ "$?" != "0" ]; then
            echo "Wifi Doesn't On."
        else
            getUser
        fi
        exit 0
        ;;
    out)
        # getOut id
        [[ "$2" != "" ]] && outId=$2 && \
            sudo create_ap --stop $outId
        exit 0
        ;;
    -h | --help | help)
        Menu
        exit 0
        ;;
    -l | --limit | --limit-speed)
        speed=$2 # MTU
        [[ "$2" = "" ]] && Menu && exit -1
        sudo iptables -N ${WIFI_IPTABLE} >> /dev/null 2>&1
        if [ "$?" != "0" ]; then
            sudo iptables -F ${WIFI_IPTABLE}
        fi
        #
        wifi_iptable_drop=$(sudo iptables -L FORWARD --line-number | grep -i ${WIFI_IPTABLE} | head -n 1 | awk '{print $1}')
        [[ "$wifi_iptable_drop" != "" ]] && \
            sudo iptables -D FORWARD ${wifi_iptable_drop} >> /dev/null 2>&1
        sudo iptables -I FORWARD 1 -j ${WIFI_IPTABLE}
        #
        sudo iptables -I ${WIFI_IPTABLE} 1 -s ${IP_SEGMENT} -m limit --limit ${speed}/s -j ACCEPT
        sudo iptables -I ${WIFI_IPTABLE} 2 -d ${IP_SEGMENT} -m limit --limit ${speed}/s -j ACCEPT
        sudo iptables -I ${WIFI_IPTABLE} 3 -s ${IP_SEGMENT} -j DROP
        sudo iptables -I ${WIFI_IPTABLE} 4 -d ${IP_SEGMENT} -j DROP
        sudo iptables -A ${WIFI_IPTABLE} -j RETURN
        exit 0
        ;;
    *)
        echo "Error Usage: -h for help"
        Menu
        exit 0
        ;;
esac

# Only $1 = Start Will Come Here
wifi_file_dir=/etc/ColeWifi
wifi_file_name=${wifi_file_dir}/wifi_info
case $2 in
    "")
        ;;
    -c)
        # Load Wifi Info From File
        [[ "$3" = "" ]] && echo "Error -c need a file." && exit -1 \
            || wifi_file_name=$3
        WIFI_NAME=$(cat $wifi_file_name | grep -i wifi_name | awk -F '"' '{print $4}')
        WIFI_PASSWORD=$(cat $wifi_file_name | grep -i wifi_password | awk -F '"' '{print $4}')
        ;;
    -g | --static)
        WIFI_INFO_FILE=$wifi_file_name
        [[ ! -f "${wifi_file_name}" ]] && \
            sudo mkdir -p $wifi_file_dir && \
            echo "First Arrive, You need write some info." && \
            read -p "Wifi SSID: " WIFI_NAME && \
            read -p "Wifi PASSOWRD: " WIFI_PASSWORD && \
            sudo touch $wifi_file_name && \
            sudo chown $USER:$USER $wifi_file_name && \
            echo "{" > $WIFI_INFO_FILE && \
            echo "  \"WIFI_NAME\": \"$WIFI_NAME\"," >> $WIFI_INFO_FILE && \
            echo "  \"WIFI_PASSWORD\": \"$WIFI_PASSWORD\"" >> $WIFI_INFO_FILE && \
            echo "}" >> $WIFI_INFO_FILE && \
            echo "" && \
            echo "Now restart it." && \
            exit 0
        # 
        echo "Load Info ..."
        WIFI_NAME=$(cat $wifi_file_name | grep -i wifi_name | awk -F '"' '{print $4}')
        WIFI_PASSWORD=$(cat $wifi_file_name | grep -i wifi_password | awk -F '"' '{print $4}')
        ;;
    -i | --in)
        FROM_NETWORK_INTERFAC=$3
        ;;
    -l | --limit | --limit-speed)
        speed=$3 # MTU
        [[ "$speed" = "" ]] && Menu && exit -1
        sudo iptables -N ${WIFI_IPTABLE} >> /dev/null 2>&1
        if [ "$?" != "0" ]; then
            sudo iptables -F ${WIFI_IPTABLE}
        fi
        #
        wifi_iptable_drop=$(sudo iptables -L FORWARD --line-number | grep -i ${WIFI_IPTABLE} | head -n 1 | awk '{print $1}')
        [[ "$wifi_iptable_drop" != "" ]] && \
            sudo iptables -D FORWARD ${wifi_iptable_drop} >> /dev/null 2>&1
        sudo iptables -I FORWARD 1 -j ${WIFI_IPTABLE}
        #
        sudo iptables -I ${WIFI_IPTABLE} 1 -s ${IP_SEGMENT} -m limit --limit ${speed}/s -j ACCEPT
        sudo iptables -I ${WIFI_IPTABLE} 2 -d ${IP_SEGMENT} -m limit --limit ${speed}/s -j ACCEPT
        sudo iptables -I ${WIFI_IPTABLE} 3 -s ${IP_SEGMENT} -j DROP
        sudo iptables -I ${WIFI_IPTABLE} 4 -d ${IP_SEGMENT} -j DROP
        sudo iptables -A ${WIFI_IPTABLE} -j RETURN
        exit 0
        ;;
    -o | --out)
        TO_NETWORK_INTERFACE=$3
        ;;
    -r | --reconfig)
        sudo rm -rf $wifi_file_name
        $0 start -g
        exit 0
        ;;
    *)
        echo "Unknow options"
        exit -1
        ;;
esac

# export PATH=${CURRENT_PATH}/..:$PATH

# source $CURRENT_PATH/../BaseFunctionSets.sh >> /dev/null 2>&1

which create_ap >> /dev/null 2>&1
if [ "$?" != "0" ]; then
    config_create_ap.sh
fi

echo "{" > $WIFI_INFO_FILE
echo "  \"WIFI_NAME\": \"$WIFI_NAME\"," >> $WIFI_INFO_FILE
echo "  \"WIFI_PASSWORD\": \"$WIFI_PASSWORD\"," >> $WIFI_INFO_FILE
echo "  \"WIFI_MAC\": \"$MAC_ADDRESS\"" >> $WIFI_INFO_FILE
echo "}" >> $WIFI_INFO_FILE

sudo create_ap --daemon \
    -c ${TIME_STEMP:18:1} \
    $FROM_NETWORK_INTERFACE \
    $TO_NETWORK_INTERFACE \
    $WIFI_NAME \
    $WIFI_PASSWORD \
    --mac ${MAC_ADDRESS} > $ERROR_LOG 2>&1

if [ "$?" != "0" ]; then
    echo "Wifi failed to start ..."
    echo "Please Look at logfile ${ERROR_LOG}"
    exit -1
else
    echo ""
    echo "**********************************"
    echo "* SSID     : $WIFI_NAME          "
    echo "* PASSWORD : $WIFI_PASSWORD      "
    echo "**********************************"
    echo ""
    echo "(More Infomation, look at $ERROR_LOG)"
fi