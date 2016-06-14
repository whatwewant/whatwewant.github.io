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
    echo ""
    echo "More: "
    echo "  Take care: DOMAIN/.well-known/acme-challenge/ must can be visited. You can use nginx location config.)"
    echo "  Nginx server port 80 conf add: "
    echo "    ..."
    echo "    location /.well-known {"
    echo "      alias DOMAIN_DIR/.well-known;"
    echo "    }"
    echo ""
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
APPLIED_SIGNED_CTR=${DOMAIN}.signed.crt
DOMAIN_CSR=${DOMAIN}.csr
DOMAIN_SSL_DIR=${DOMAIN_DIR}/.letsencrypt/${DOMAIN}
#
NGINX_SERVER_CONF_DIR=${DOMAIN_DIR}/config;
NGINX_SERVER_CONF=${NGINX_SERVER_CONF_DIR}/${DOMAIN}.nginx.conf

# 0 创建 NGINX SERVER CONF DIR
[[ ! -d "$NGINX_SERVER_CONF_DIR" ]] && \
    (mkdir -p $NGINX_SERVER_CONF_DIR || \
        (echo "Error: #0 创建网站NGINX配置目录失败: $NGINX_SERVER_CONF_DIR" && exit -1))

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
# 签名的CRT
python $ACME_TINY --account-key $ACCOUNT_KEY --csr $DOMAIN_CSR --acme-dir $ACME_CHALLENGE_DIR > $APPLIED_SIGNED_CTR || \
    (echo -e "Error: #5.2 \n  acme_tiny.py generates $APPLIED_SIGNED_CTR failed." && exit -1)


#6 Letsencrypt 中间证书签名申请的证书, 否则手机浏览器不信任
LETENSCRIPT_SIGNED=lets-encrypt-x1-cross-signed.pem
if [ ! -f $LETENSCRIPT_SIGNED ]; then
    wget https://letsencrypt.org/certs/$LETENSCRIPT_SIGNED -O intermediate.pem -o /dev/null
fi
echo "Generame domain crt with lets-encrypt signed ..."
cat $APPLIED_SIGNED_CTR intermediate.pem > $DOMAIN_CRT
echo -e "\e[01;32mNew cert: $DOMAIN_CRT has been generated\e[0m"

# 6.1 OCSP Stapling
echo "Generate full_chained.pem for OSCP Stapling ..."
wget  https://letsencrypt.org/certs/isrgrootx1.pem -O root.pem
cat intermediate.pem root.pem > full_chained.pem

# 6.2 DH public server param (Ys) resue
echo "Generate dhparams.pem for DH ..."
openssl dhparam -out dhparams.pem 2048
sudo chmod 600 dhparams.pem

#7 Move DOMAIN key and signed crt to DOMAIN_SSL_DIR
echo "创建证书目录: "
[[ ! -d $DOMAIN_SSL_DIR ]] && \
    sudo mkdir -p $DOMAIN_SSL_DIR || \
    (echo -e "Error: #7\n  创建目录失败 $DOMAIN_SSL_DIR" && exit -1)
echo ""
echo "Move $DOMAIN_CRT to $DOMAIN_SSL_DIR"
sudo mv $DOMAIN_CRT $DOMAIN_SSL_DIR
echo "Move $DOMAIN_KEY to $DOMAIN_SSL_DIR"
sudo mv $DOMAIN_KEY $DOMAIN_SSL_DIR
echo "Move full_chained.pem to $DOMAIN_SSL_DIR"
sudo mv full_chained.pem $DOMAIN_SSL_DIR
echo "Move dhparams.pem to $DOMAIN_SSL_DIR"
sudo mv dhparams.pem $DOMAIN_SSL_DIR
echo ""

# Tips
echo "#################################"
echo "Nginx里的SSL相关的配置"
echo "#################################"
echo "更多:"
echo "  生成配置: https://mozilla.github.io/server-side-tls/ssl-config-generator/"
echo "  测试: https://www.ssllabs.com/ssltest/"
echo "#################################"
echo ""
echo "
server {
    server_name www.$DOMAIN $DOMAIN;
    server_tokens off;

    access_log /dev/null;

    if (\$request_method !~ ^(GET|HEAD|POST|PUT|DELETE)$) {
        return 444;
    }

    location ^~ /.well-known/acme-challenge/ {
        alias       $ACME_CHALLENGE_DIR;
        try_files   $uri =404;
    }

    location / {
        rewrite     ^/(.*)$ https://$DOMAIN/\$1 permanent;
    }
}

server {
    listen 443 ssl;
    server_name www.$DOMAIN $DOMAIN;
    charset utf-8;
    client_max_body_size 100M;
    server_tokens off;

    ssl on;
    ssl_certificate     $DOMAIN_SSL_DIR/$DOMAIN_CRT;
    ssl_certificate_key $DOMAIN_SSL_DIR/$DOMAIN_KEY;
    ssl_dhparam         $DOMAIN_SSL_DIR/dhparams.pem;

    ssl_prefer_server_ciphers on;
    ssl_ciphers 'ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:ECDHE-ECDSA-DES-CBC3-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!DSS';

    ssl_protocols TLSv1 TLSV1.1 TLSV1.2;
    
    ssl_stapling on;
    ssl_stapling_verify on;
    ssl_trusted_certificate $DOMAIN_SSL_DIR/full_chained.pem;

    add_header Strict-Transport-Security \"max-age=31536000; includeSubdomains\";

    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:50m;
    ssl_session_tickets off;

    resolver            114.114.114.114 valid=300s;
    resolver_timeout    10s;
    
    access_log          $DOMAIN_DIR/.$DOMAIN.log;

    if (\$request_method !~ ^(GET|HEAD|POST|OPTIONS|PUT|DELETE)$) {
        return          444;
    }

    if (\$host != '$DOMAIN') {
        rewrite ^/(.*)$ https://$DOMAIN/\$1 permanent;
    }

    location ~* (robots\\.txt|favicon\\.ico|crossdomain\\.xml|google4c90d18e696bdcf8\\.html|BingSiteAuth\\.xml)\$  {
        root        $DOMAIN_DIR/static;
        expires     1d;
    }

    location ^~ /static/ {
        root        $DOMAIN_DIR/static;
        add_header  Access-Control-Allow-Origin *;
        expires     max;
    }

    location / {
        proxy_http_version 1.1;

        add_header  Strict-Transport-Security \"max-age=31536000; includeSubDomains; preload\";
        add_header  -Frame-Options deny;
        add_header  X-Content-Type-Options nosniff;
        add_header  Content-Security-Policy \"default-src 'none'; script-src 'unsafe-inline' 'unsafe-eval' blob: https:; img-src data: https: http://ip.qgy18.com; style-src 'unsafe-inline' https:; child-src https:; connect-src 'self' https://translate.googleapis.com; frame-src https://disqus.com https://www.slideshare.net\";
        add_header  Public-Key-Pins 'pin-sha256=\"YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg=\"; pin-sha256=\"aef6IF2UF6jNEwA2pNmP7kpgT6NFSdt7Tqf5HzaIGWI=\"; max-age=2592000; includeSubDomains';
        add_header  Cache-Control no-cache;

        proxy_ignore_headers    Set-Cookie;

        proxy_hide_header       Vary;
        proxy_hide_header       X-Powered-By;

        proxy_set_header        X-Via       Qingdao.Aliyun;
        proxy_set_header        Connection  \"\";
        proxy_set_header        Host        $DOMAIN;
        proxy_set_header        X-Real_IP   $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;

        proxy_pass              http://127.0.0.1:9125;
    }
}
" | tee  $NGINX_SERVER_CONF
echo ""
echo "######################################################"
echo "  1. 请修改 $NGINX_SERVER_CONF 以适应你的网站."
echo "  2. 在/etc/nginx/nginx.conf的http底部加入服务器配置: "
echo "      include $NGINX_SERVER_CONF_DIR/*.conf"
echo "######################################################"
echo ""

# Cron 定时更新证书(每月)
# crontab -e
# 0 0 1 * * /etc/nginx/certs/letsencrypt_cmd.sh $DOMAIN $DOMAIN_DIR "DNS:$DOMAIN,DNS:www.$DOMAIN" >> /var/log/lets-encrypt.log 2>&1

