#!/bin/bash
# 
# *************************************************
# File Name    : lets-encrypt.sh
# Author       : Cole Smith
# Mail         : tobewhatwewant@gmail.com
# Github       : whatwewant
# Created Time : 2016年02月13日 星期六 17时04分32秒
# *************************************************

# Usage: /etc/nginx/certs/letsencrypt.sh /etc/nginx/certs/letsencrypt.conf

CONFIG=$1
ACME_TINY="/tmp/acme_tiny.py"

if [ -f "$CONFIG" ];then
    . $CONFIG
    cd $(dirname $CONFIG)
else
    echo "Usage:"
    echo " $0 /path/to/letsencrypt.conf"
    exit 1
fi

KEY_PREFIX="${DOMAIN_KEY%%.*}"
DOMAIN_CRT="$KEY_PREFIX.crt"
DOMAIN_CSR="$KEY_PREFIX.csr"
DOMAIN_CHAINED_CRT="$KEY_PREFIX.chained.crt"
# 
DOMAIN_KEY_STORE_DIR="$DOMAIN_DIR/SSL_KEY"

[[ ! -d "$DOMAIN_KEY_STORE_DIR" ]] && mkdir -p $DOMAIN_KEY_STORE_DIR

if [ ! -f "$ACCOUNT_KEY" ];then
    echo "Generate account key..."
    openssl genrsa 4096 > $ACCOUNT_KEY
fi

if [ ! -f "$DOMAIN_KEY" ];then
    echo "Generate domain key..."
    if [ $ECC = "TRUE" ];then
        openssl ecparam -genkey -name secp256r1 | openssl ec -out $DOMAIN_KEY
    else
        openssl genrsa 2048 > $DOMAIN_KEY
    fi
fi

echo "Generate CSR...$DOAMIN_CSR"

OPENSSL_CONF="/etc/ssl/openssl.cnf"

if [ ! -f "$OPENSSL_CONF" ];then
    OPENSSL_CONF="/etc/pki/tls/openssl.cnf"
    if [ ! -f "$OPENSSL_CONF" ];then
        echo "Error, file openssl.cnf not found."
        exit 1
    fi
fi

openssl req -new -sha256 -key $DOMAIN_KEY -subj "/" -reqexts SAN -config <(cat $OPENSSL_CONF <(printf "[SAN]\nsubjectAltName=$DOMAINS")) > $DOMAIN_CSR

if [ ! -f "$ACME_TINY" ]; then
    wget https://raw.githubusercontent.com/diafygi/acme-tiny/master/acme_tiny.py -O $ACME_TINY -o /dev/null
fi

if [ -f "$DOMAIN_CRT" ];then
    mv $DOMAIN_CRT $DOMAIN_CRT-OLD-$(date +%y%m%d-%H%M%S)
fi

DOMAIN_DIR="$DOMAIN_DIR/.well-known/acme-challenge/"
mkdir -p $DOMAIN_DIR

python $ACME_TINY --account-key $ACCOUNT_KEY --csr $DOMAIN_CSR --acme-dir $DOMAIN_DIR > $DOMAIN_CRT

if [ "$?" != 0 ];then
    exit 1
fi

if [ ! -f "lets-encrypt-x1-cross-signed.pem" ];then
    wget -c https://letsencrypt.org/certs/lets-encrypt-x1-cross-signed.pem
fi

cat $DOMAIN_CRT lets-encrypt-x1-cross-signed.pem > $DOMAIN_CHAINED_CRT


echo -e "\e[01;32mNew cert: $DOMAIN_CHAINED_CRT has been generated\e[0m"

echo ""
# Move DOMAIN key and cgained crt to DOMAIN_KEY_STORE_DIR
echo "Move $DOMAIN_KEY to $DOMAIN_KEY_STORE_DIR"
mv $DOMAIN_KEY $DOMAIN_KEY_STORE_DIR
echo "Move $DOMAIN_CHAINED_CRT to $DOMAIN_KEY_STORE_DIR"
mv $DOMAIN_CHAINED_CRT $DOMAIN_KEY_STORE_DIR
echo ""

# Tips
echo "#################################"
echo "Nginx里的SSL相关的配置"
echo "#################################"
echo "  ..."
echo "  ssl_certificate     $DOMAIN_KEY_STORE_DIR/$DOMAIN_CRT"
echo "  ssl_certificate_key $DOMAIN_KEY_STORE_DIR/$DOMAIN_KEY"
echo "  ..."

# Cron 定时更新证书
# crontab -e
# 0 0 1 * * /etc/nginx/certs/letsencrypt.sh /etc/nginx/certs/letsencrypt.conf >> /var/log/lets-encrypt.log 2>&1
