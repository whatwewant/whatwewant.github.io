#!/bin/bash
# 
# *************************************************
# File Name    : lets-encrypt_cmd.sh
# Author       : Cole Smith
# Mail         : tobewhatwewant@gmail.com
# Github       : whatwewant
# Created Time : 2016年02月13日 星期六 20时46分17秒
# *************************************************

set -e

# Key params
DOMAIN=example.com # 域名
DOMAIN_DIR=/var/www
DOMAINS_DNS="DNS:$DOMAIN" # 要签名的域名列表

CONF_DIR=/tmp/Letsencrypt
ACCOUNT_KEY=letsencrypt-acount.key

ACME_TINY=$CONF_DIR/acme_tiny.py

# ECC="TRUE" # ECC 证书支持

menu() {
    echo "Usage: "
    echo "  $0 DOAMIN DOMAIN_DIR DOMAINS_DNS"
    echo ""
    echo "Example: "
    echo "  $0 example.com /var/www \"DNS:exmaple.com,DNS:whaterver.example.com\""
}

if [ ! ${#*} -eq 3 ]; then
    menu
    exit -1
else
    DOMAIN=$1
    DOMAIN_DIR=$2
    DOMAINS_DNS=$3
fi

DOMAIN_KEY=${DOMAIN}.key
DOMAIN_CRT=${DOMAIN}.crt
DOMAIN_CRT_UNSIGNED=${DOMAIN}.unsigned.crt
DOMAIN_CSR=${DOMAIN}.csr
DOMAIN_SSL_DIR=/etc/letsenscript/${DOMAIN}

#1 创建临时配置目录, 并切换目录
[[ ! -d "$CONF_DIR" ]] && \
    (mkdir -p $CONF_DIR || \
      (echo "Error: #1 创建目录失败: $CONF_DIR" && exit -1))
cd $CONF_DIR

#2 产生ACCOUNT_KEY
if [ ! -f $ACCOUNT_KEY ]; then
    echo "Generate account key ..."
    openssl genrsa 4096 > $ACCOUNT_KEY 2>>/dev/null
fi

#3 产生DOMAIN_KEY
if [ ! -f $DOMAIN_KEY ]; then
    echo "Generate domain key ..."
    if [ "$ECC" = "TRUE" ]; then
        openssl ecparam -genkey -name secp256r1 | openssl ec -out $DOMAIN_KEY
    else
        openssl genrsa 2048 > $DOMAIN_KEY
    fi
fi

#4 产生DOMAIN_CSR
echo "Generate CSR ... $DOMAIN_CSR"
OPENSSL_CONF=/etc/ssl/openssl.cnf
if [ ! -f $OPENSSL_CONF ]; then
    OPENSSL_CONF=/etc/pki/tls/openssl.cnf
    if [ ! -f $OPENSSL_CONF ]; then
        echo "Error: #4"
        echo "  Cannot fount file: $OPENSSL_CONF"
        exit -1
    fi
fi

openssl req -new -sha256 -key $DOMAIN_KEY -subj "/" -reqexts SAN -config <(cat $OPENSSL_CONF <(printf "[SAN]\nsubjectAltName=$DOMAINS_DNS")) > $DOMAIN_CSR

#5 ACME_TINY Script
if [ ! -f $ACME_TINY ]; then
    wget https://raw.githubusercontent.com/diafygi/acme-tiny/master/acme_tiny.py -O $ACME_TINY -o /dev/null
fi

#5.1 ACME Challenge Dir
ACME_CHALLENGE_DIR="$DOMAIN_DIR/.well-known/acme-challenge/"
[[ ! -d $ACME_CHALLENGE_DIR ]] && \
    (mkdir -p $ACME_CHALLENGE_DIR || \
        (echo "Error: #2 创建目录失败 $ACME_CHALLENGE_DIR" && exit -1))

#5.2 ACME TINY Script generate crt without signed 
# 未签名的CRT
python $ACME_TINY --account-key $ACCOUNT_KEY --csr $DOMAIN_CSR --acme-dir $ACME_CHALLENGE_DIR > $DOMAIN_CRT_UNSIGNED || \
    (echo -e "Error: #5.2 \n  acme_tiny.py generates $DOMAIN_CRT_UNSIGNED failed." && exit -1)


#6 Letsencrypt SIGNED
LETENSCRIPT_SIGNED=lets-encrypt-x1-cross-signed.pem
if [ ! -f $LETENSCRIPT_SIGNED ]; then
    wget https://letsencrypt.org/certs/$LETENSCRIPT_SIGNED -O $LETENSCRIPT_SIGNED -o /dev/null
fi
echo "Generame domain crt with lets-encrypt signed ..."
cat $DOMAIN_CRT_UNSIGNED lets-encrypt-x1-cross-signed.pem > $DOMAIN_CRT
echo -e "\e[01;32mNew cert: $DOMAIN_CRT has been generated\e[0m"

#7 Move DOMAIN key and signed crt to DOMAIN_SSL_DIR
[[ ! -d $DOMAIN_SSL_DIR ]] && \
    mkdir -p $DOMAIN_SSL_DIR || \
    (echo -e "Error: #7\n  创建目录失败 $DOMAIN_SSL_DIR" && exit -1)
echo ""
echo "Move $DOMAIN_CRT to $DOMAIN_SSL_DIR"
mv $DOMAIN_CRT $DOMAIN_SSL_DIR
echo "Move $DOMAIN_KEY to $DOMAIN_SSL_DIR"
mv $DOMAIN_KEY $DOMAIN_SSL_DIR
echo ""

# Tips
echo "#################################"
echo "Nginx里的SSL相关的配置"
echo "#################################"
echo "  ..."
echo "  ssl_certificate     $DOMAIN_SSL_DIR/$DOMAIN_CRT"
echo "  ssl_certificate_key $DOMAIN_SSL_DIR/$DOMAIN_KEY"
echo "  ..."
echo ""

# Cron 定时更新证书
# crontab -e
# 0 0 1 * * /etc/nginx/certs/letsencrypt.sh /etc/nginx/certs/letsencrypt.conf >> /var/log/lets-encrypt.log 2>&1

