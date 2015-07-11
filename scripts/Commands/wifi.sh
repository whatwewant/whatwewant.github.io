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

Menu () {
    echo "$0 start|stop|restart|help|info"
    echo ""
    echo " -c filename    Load UserName and Password From file."
    echo ""
}

case $1 in
    "" | start)
        ps -e | grep -i create_ap >> /dev/null 2>&1
        [[ "$?" = "0" ]] && \
            echo "WIFI Already starts. You can restart it Manually." && \
            exit -1
        echo "Starting Wifi Now ..."
        ;;
    stop)
        echo "Stopping Wifi ..."
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
    -h | --help | help)
        Menu
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
    echo "More Infomation, look at $ERROR_LOG"
fi
