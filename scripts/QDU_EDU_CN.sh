#!/bin/bash 

PROGRAM_NAME=QDU_EDU_CN_S
USER_INFO_DIR=$HOME/.config
USER_INFO_FILE=$USER_INFO_DIR/qdu_user_conf.json
TMP_DATA_DIR=/tmp
INDEX_HTML=$TMP_DATA_DIR/${PROGRAM_NAME}_INDEX.html
AFTER_POST_HTML=$TMP_DATA_DIR/${PROGRAM_NAME}_POST.html

install_packages() {
    PackagesSet="curl"
    which curl >> /dev/null 2>&1 && \
        which iconv >> /dev/null 2>&1 && \
        return 

    echo "正在安装必要的工具..."
    which apt-get >> /dev/null 2>&1
    if [ "$?" = "0" ]; then
        sudo apt-get update
        sudo apt-get install -y $PackagesSet
        sudo apt-get install -y iconv
        return 
    fi
    
    which yum >> /dev/null 2>&1
    if [ "$?" = "0" ]; then
        sudo yum update
        sudo yum install -y $PackagesSet
        sudo yum install -y perl-Text-Iconv.x86_64
        return 
    fi
    
    which pacman >> /dev/null 2>&1
    if [ "$?" = "0" ]; then
        sudo pacman -Syy
        sudo pacman -S --noconfirm  $PackagesSet
        sudo pacman -S --noconfirm perl-text-iconv
        return 
    fi

    echo "   Cannot Recognize Your Linux Distribution..."
    echo "  Please Install:"
    echo "      curl"
    echo "      iconv"
}

initialize() {
    # 初始化操作
    [[ ! -d "USER_INFO_DIR" ]] && mkdir -p $USER_INFO_DIR
    install_packages
}

getCharMd5() {
    raw_value=$1
    md5_value=$(echo -n $raw_value | md5sum | cut -d ' ' -f1)
    echo -n $md5_value
}

getCookie() {
    index_url=$1
    tmpCookieFile=${TMP_DATA_DIR}/${PROGRAM_NAME}-$(date +%s).cookie
    [[ -f "$INDEX_HTML" ]] && rm -rf $INDEX_HTML
    curl -s -c $tmpCookieFile $index_url > $INDEX_HTML
    [[ -f $tmpCookieFile ]] && cat $tmpCookieFile
}

staticHttpHeader() {
    headers=" -H 'Host: 10.0.109.2' \
 -H 'Origin: http://10.0.109.2' \
 -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.152 Safari/537.36' \
 -H 'Content-Type: application/x-www-form-urlencoded' \
 -H 'Referer: http://10.0.109.2'"
    echo $headers
}

httpPostWithCookie() {
    url=$1
    data=$2
    [[ -f $tmpCookieFile ]] && cookie_post=$tmpCookieFile
    headers=$(staticHttpHeader)
    # COMMAND="curl ${cookie_post} ${headers} -d '$data' $url > $AFTER_POST_HTML"
    # echo $COMMAND
    # $COMMAND
    # curl ${cookie_post} $(staticHttpHeader) -d '$data' $url > $AFTER_POST_HTML
    # echo $data
    [[ -f "$AFTER_POST_HTML" ]] && rm -rf $AFTER_POST_HTML
    curl -b $cookie_post \
        -H "Host: 10.0.109.2" \
        -H "Origin: http://10.0.109.2" \
        -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.152 Safari/537.36" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -H "Referer: http://10.0.109.2" \
        -d "$data" \
        $url > $AFTER_POST_HTML 2>/dev/null
}

login() {
    url=$1
    data=$2
    echo "正在登陆, 请稍等"
    getCookie;
    httpPostWithCookie $url $data
}

QDU_EDU_CHECK_LOGIN() {
    index_url=$1
    [[ -f "$INDEX_HTML" ]] && rm -rf $INDEX_HTML
    curl -s $index_url > $INDEX_HTML 2>&1
    if [ "$?" != "0" ]; then
        echo "未能检测到 QDU_EDU_CN网络" 
        exit -1
    fi
    cat $INDEX_HTML | grep -i "logout" >> /dev/null 2>&1 && \
        result=1 || \
        result=0
}

QDU_EDU_ERROR() {
    echo "Error:"
    echo -n "    "
    which iconv >> /dev/null 2>&1 && \
        iconv -f GBK -t utf-8 $AFTER_POST_HTML | awk '/msga=+/{print}' | awk -F "'" '{print $2}' || \
        cat $AFTER_POST_HTML | awk '/msga=+/{print}' | awk -F "'" '{print $2}'
}

# result=0
QDU_EDU_LOGIN() {
    url="http://10.0.109.2"
    # result=$(QDU_EDU_CHECK_LOGIN $url)
    QDU_EDU_CHECK_LOGIN $url

    if [ "$result" = "1" ]; then
        echo "Already Login !"
        exit 0
    fi

    username=$1
    raw_password=$2
    calg="12345678"
    pid="1"
    tmpchar=${pid}"${raw_password}${calg}"
    password=$(getCharMd5 $tmpchar)
    password="${password}${calg}${pid}"
    data="DDDDD=${username}&upass=${password}&R1=0&R2=1&para=00&0MKKey=123456"

    getCookie $url
    httpPostWithCookie $url $data

    cat $AFTER_POST_HTML | grep -i "You have successfully logged into our system." >> /dev/null 2>&1 && \
        echo "登入成功" || \
        (echo "登陆失败" && \
        QDU_EDU_ERROR)
}

QDU_EDU_LOGOUT() {
    url="http://10.0.109.2/F.htm"
    curl -s $url >> /dev/null 2>&1 && \
        echo "注销成功" || \
        echo "注销失败"
}

QDU_EDU_LOGIN_WITH_DATA() {
    if [ -f "$USER_INFO_FILE" ]; then
        username=$(cat $USER_INFO_FILE | grep -i username | awk -F '"' '{print $4}')
        password=$(cat $USER_INFO_FILE | grep -i password | awk -F '"' '{print $4}')
        
        # QDU_EDU_LOGIN 201140701005 tobewhatwewant
        # QDU_EDU_LOGOUT

        QDU_EDU_LOGIN $username $password
        return 
    fi
    
    echo "First Use, please write userinfo"
    echo -n "Username: "
    read username
    echo -n "Password: "
    read password
    echo "{" > $USER_INFO_FILE
    echo "    \"username\": \"${username}\"," >> $USER_INFO_FILE
    echo "    \"password\": \"${password}\"" >> $USER_INFO_FILE
    echo "}" >> $USER_INFO_FILE

    QDU_EDU_LOGIN $username $password
}

if [ "$1" = "" ]; then
    echo "Usage: "
    echo "    $0 start|login|stop|logout|restart|relogin"
    exit -1
fi

case $1 in 
    login|start)
        QDU_EDU_LOGIN_WITH_DATA
        ;;
    logout|stop)
        QDU_EDU_LOGOUT
        ;;
    relogin|restart)
        QDU_EDU_LOGOUT
        sleep 2
        QDU_EDU_LOGIN_WITH_DATA
        ;;
    *)
        echo "Usage: "
        echo "    $0 start|login|stop|logout|restart|relogin"
        ;;
esac
