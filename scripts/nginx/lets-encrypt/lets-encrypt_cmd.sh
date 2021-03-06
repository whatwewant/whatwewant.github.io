# @Author: eason
# @Date:   2017-08-04T01:23:29+08:00
# @Last modified by:   eason
# @Last modified time: 2017-08-15T00:34:40+08:00
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

FORCE="FALSE"
RENEW="FALSE"

# Key params
DOMAIN="" # 域名
DOMAIN_DIR=""
DOMAINS_DNS="" # 要签名的域名列表
DOMAINS_DNS_NGINX="" # NGINX CONFIG
DOMAINS_DNS_NGINX_REWRITE=""

CONF_DIR=/tmp/Letsencrypt
ACCOUNT_KEY=letsencrypt-acount.key

ACME_TINY=$CONF_DIR/acme_tiny.py

# ECC="TRUE" # ECC 证书支持

menu() {
    echo "Usage: $0 [option]=value"
    echo ""
    echo "OPTION"
    echo "  -h,--help     help"
    echo "  --domain      set domain, if value is @, dns is example.com"
    echo "  --domain-dir  set site dir"
    echo "  --dns         set sub domain"
    echo "  -r,--renew    renew let's encrypt."
    echo ""
    echo "Example: "
    echo "  $0 --domain=example.com --domain-dir=/var/www --dns=@ (DNS: example.com)"
    echo "  $0 --domain=example.com --domain-dir=/var/www --dns=static --dns=cdn (DNS: example.com, static.example.com, cdn.example.com)"
    echo ""
    # echo "More: "
    # echo "  Take care: DOMAIN/.well-known/acme-challenge/ must can be visited. You can use nginx location config.)"
    # echo "  Nginx server port 80 conf add: "
    # echo "    ..."
    # echo "    location /.well-known {"
    # echo "      alias DOMAIN_DIR/.well-known;"
    # echo "    }"
    # echo ""
}

for ov in $@
do
    option=$(echo $ov | cut -d "=" -f 1)
    value=$(echo $ov | cut -d "=" -f 2)
    case $option in
        -h|--help)
            menu
            exit 0
            ;;
        --domain)
            DOMAIN=$value
            ;;
        --domain-dir)
            DOMAIN_DIR=$value
            ;;
        --dns)
            if [ "$DOMAIN" = "" ]; then
              echo "Your should set domain first."
              exit -1
            fi

            if [ "$value" = "@" ]; then
              DOMAINS_DNS="$DOMAINS_DNS,DNS:$DOMAIN"
              DOMAINS_DNS_NGINX="$DOMAINS_DNS_NGINX $DOMAIN"
            elif [ "$DOMAINS_DNS" = "" ]; then
              DOMAINS_DNS="DNS:$value.$DOMAIN"
              DOMAINS_DNS_NGINX="$value.$DOMAIN"
              DOMAINS_DNS_NGINX_REWRITE="$value.$DOMAIN"
            else
              DOMAINS_DNS="$DOMAINS_DNS,DNS:$value.$DOMAIN"
              DOMAINS_DNS_NGINX="$DOMAINS_DNS_NGINX $value.$DOMAIN"
            fi
            ;;
        -f|--force)
            FORCE="TRUE"
            ;;
        -r|--renew)
            RENEW="TRUE"
            ;;
    esac
done

if [ "${DOMAIN}" = "" ]; then
    echo "You should set domain use '--domain=YOUR_DOMAIN'"
    exit -1
elif [ "${DOMAIN_DIR}" = "" ]; then
  echo "You should set domain-dir use '--domain_dir=YOUR_SITE_DIR'"
  exit -1
elif [ "${DOMAINS_DNS}" = "" ]; then
  echo "You should set dns use '--dns=YOUR_SITE_DNS"
  exit -1
fi

DOMAIN_KEY=${DOMAIN}.key
DOMAIN_CRT=${DOMAIN}.crt
APPLIED_SIGNED_CTR=${DOMAIN}.signed.crt
DOMAIN_CSR=${DOMAIN}.csr
DOMAIN_SSL_DIR=${DOMAIN_DIR}/.letsencrypt/${DOMAIN}
DOMAIN_SSL_DIR_ACME=${DOMAIN_DIR}/.letsencrypt/${DOMAIN}_ACME
#
NGINX_SERVER_CONF_DIR=${DOMAIN_DIR}/config;
NGINX_SERVER_CONF_BEFORE_VERIFY=${NGINX_SERVER_CONF_DIR}/${DOMAIN}.beforeVerify.nginx.conf
NGINX_SERVER_CONF_REGEXP=${NGINX_SERVER_CONF_DIR}/*.conf
NGINX_SERVER_CONF=${NGINX_SERVER_CONF_DIR}/${DOMAIN}.nginx.conf

#5.1 ACME Challenge Dir
ACME_CHALLENGE_DIR="$DOMAIN_DIR/.well-known/acme-challenge/"
[[ ! -d $ACME_CHALLENGE_DIR ]] && \
    (mkdir -p $ACME_CHALLENGE_DIR || \
        (echo "Error: #2 创建目录失败 $ACME_CHALLENGE_DIR" && exit -1))

BASE_CONFIG_BEFORE_VERIFY=$(cat <<EOF
# Basic Config:

server {
    listen 80;
    server_name $DOMAINS_DNS_NGINX;
    server_tokens off;
    client_max_body_size 100M;

    access_log /dev/null;

    if (\$request_method !~ ^(GET|HEAD|POST|PUT|DELETE)$) {
        return 444;
    }

    location ^~ /.well-known/acme-challenge/ {
        alias       $ACME_CHALLENGE_DIR;
        try_files   \$uri =404;
    }

    # location / {
    #    rewrite     ^/(.*)$ https://$DOMAINS_DNS_NGINX_REWRITE/\$1 permanent;
    # }
}

#########################
# Make sure you have the similar config like above !
# Include site config to nginx.conf (Default: /etc/nginx/nginx.conf)
#
# http {
#  ...
#  include $NGINX_SERVER_CONF_REGEXP;
# }
#########################
EOF
)

#
echo "$BASE_CONFIG_BEFORE_VERIFY"

if [ "$FORCE" != "TRUE" ] && [ "$RENEW" != "TRUE" ]; then
  read -p "Are you sure have the similar config ? (y|N): " ANSWER
  while [ "$ANSWER" != "Y" ] && [ "$ANSWER" != "y" ]; do

      if [ "$ANSWER" = "N" ] || [ "$ANSWER" = "n" ]; then
          echo "You have cancel the action."
          exit -1
      fi

      echo ""
      echo "Invalid Input. Try again. (C-c to quit)"
      read -p "Are you sure have the similar config ? (y|N): " ANSWER
  done
fi

# 0 创建 NGINX SERVER CONF DIR
[[ ! -d "$NGINX_SERVER_CONF_DIR" ]] && \
    (mkdir -p $NGINX_SERVER_CONF_DIR || \
        (echo "Error: #0 创建网站NGINX配置目录失败: $NGINX_SERVER_CONF_DIR" && exit -1))

# 0.1 Save config to
echo "$BASE_CONFIG_BEFORE_VERIFY" > $NGINX_SERVER_CONF_BEFORE_VERIFY

# 0.2 Reload nginx conf
sudo nginx -s reload

#1 创建临时配置目录, 并切换目录
[[ -d "$CONF_DIR" ]] && rm -rf $CONF_DIR
mkdir -p $CONF_DIR || \
      (echo "Error: #1 创建目录失败: $CONF_DIR" && exit -1)
# Change TEMP FILE DIR
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

# Openssl 生成CSR文件
# echo "openssl req -new -sha256 -key $DOMAIN_KEY -subj \"/\" -reqexts SAN -config <(cat $OPENSSL_CONF <(printf \"[SAN]\nsubjectAltName=$DOMAINS_DNS\")) > $DOMAIN_CSR"
if [ "${RENEW}" != "TRUE" ]; then
  openssl req -new -sha256 -key $DOMAIN_KEY -subj "/" -reqexts SAN -config <(cat $OPENSSL_CONF <(printf "[SAN]\nsubjectAltName=$DOMAINS_DNS")) > $DOMAIN_CSR
fi
# SAN_SSL_TEXT="$SSL_TEXT\n$SAN_TEXT"
# SSL_TEXT=$(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:yoursite.com,DNS:www.yoursite.com"))
# # SAN_TEXT=$(echo "[SAN]\nsubjectAltName=${DOMAINS_DNS}")
# # SAN_SSL_TEXT="$SSL_TEXT\n$SAN_TEXT"
# echo "XSA START"
# echo $SSL_TEXT
# echo "XSA END"
# openssl req -new -sha256 -key $DOMAIN_KEY -subj "/" -reqexts SAN -config <$(echo $SSL_TEXT) > $DOMAIN_CSR
# echo "XSA HHHHH"

#5 ACME_TINY Script
if [ ! -f $ACME_TINY ]; then
    wget https://raw.githubusercontent.com/diafygi/acme-tiny/master/acme_tiny.py -O $ACME_TINY -o /dev/null
fi

#5.1 ACME Challenge Dir
# ACME_CHALLENGE_DIR="$DOMAIN_DIR/.well-known/acme-challenge/"
# [[ ! -d $ACME_CHALLENGE_DIR ]] && \
#     (mkdir -p $ACME_CHALLENGE_DIR || \
#         (echo "Error: #2 创建目录失败 $ACME_CHALLENGE_DIR" && exit -1))

#5.2.2
echo "创建证书目录: "
[[ ! -d $DOMAIN_SSL_DIR ]] && \
    mkdir -p $DOMAIN_SSL_DIR # || \
#    (echo -e "Error: #7\n  创建目录失败 $DOMAIN_SSL_DIR" && exit -1)
echo "创建ACME目录: "
[[ ! -d $DOMAIN_SSL_DIR_ACME ]] && \
    mkdir -p $DOMAIN_SSL_DIR_ACME

#5.2 ACME TINY Script generate crt without signed
# 签名的CRT
if [ "$RENEW" != "TRUE" ]; then
  python $ACME_TINY --account-key $ACCOUNT_KEY --csr $DOMAIN_CSR --acme-dir $ACME_CHALLENGE_DIR > $APPLIED_SIGNED_CTR || \
    (echo -e "Error: #5.2 \n  acme_tiny.py generates $APPLIED_SIGNED_CTR failed." && exit -1)
else
  python $ACME_TINY --account-key $DOMAIN_SSL_DIR_ACME/account.key --csr $DOMAIN_SSL_DIR_ACME/domain.csr --acme-dir $ACME_CHALLENGE_DIR > $APPLIED_SIGNED_CTR || \
    (echo -e "Error: #5.2 \n  acme_tiny.py generates $APPLIED_SIGNED_CTR failed." && exit -1)
fi

# 5.3 Save account.key and domain.csr
if [ "$RENEW" != "TRUE" ]; then
  cp $ACCOUNT_KEY $DOMAIN_SSL_DIR_ACME/account.key
  cp $DOMAIN_CSR $DOMAIN_SSL_DIR_ACME/domain.csr
fi

#6 Letsencrypt 中间证书签名申请的证书, 否则手机浏览器不信任
LETENSCRIPT_SIGNED=lets-encrypt-x3-cross-signed.pem
if [ ! -f $LETENSCRIPT_SIGNED ] || [ "$RENEW" = "TRUE" ]; then
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
# sudo chmod 600 dhparams.pem
chmod 600 dhparams.pem

# 7 Move DOMAIN key and signed crt to DOMAIN_SSL_DIR
# sudo mkdir -p $DOMAIN_SSL_DIR # || \
echo ""
echo "Move $DOMAIN_CRT to $DOMAIN_SSL_DIR"
mv $DOMAIN_CRT $DOMAIN_SSL_DIR
echo "Move $DOMAIN_KEY to $DOMAIN_SSL_DIR"
mv $DOMAIN_KEY $DOMAIN_SSL_DIR
echo "Move full_chained.pem to $DOMAIN_SSL_DIR"
mv full_chained.pem $DOMAIN_SSL_DIR
echo "Move dhparams.pem to $DOMAIN_SSL_DIR"
mv dhparams.pem $DOMAIN_SSL_DIR
echo ""

# Remove verified conf
mv $NGINX_SERVER_CONF_BEFORE_VERIFY ${NGINX_SERVER_CONF_BEFORE_VERIFY}.backup

# 8 RENEW
if [ "$RENEW" = "TRUE" ]; then
  sudo nginx -s reload
  exit 0
fi

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
    listen 80;
    server_name $DOMAINS_DNS_NGINX;
    server_tokens off;
    client_max_body_size 100M;

    access_log /dev/null;

    if (\$request_method !~ ^(GET|HEAD|POST|PUT|DELETE)$) {
        return 444;
    }

    # open subdomain
    # if (\$http_host ~* \"^(.*).$DOMAIN$\") {
    #     set $domain $1;
    #     rewrite ^(.*) https://$DOMAINS_DNS_NGINX_REWRITE break;
    # }

    location ^~ /.well-known/acme-challenge/ {
        alias       $ACME_CHALLENGE_DIR;
        try_files   \$uri =404;
    }

    # location / {
    #     rewrite     ^/(.*)$ https://$DOMAINS_DNS_NGINX_REWRITE/\$1 permanent;
    # }
}

server {
    listen 443 ssl;
    server_name $DOMAINS_DNS_NGINX;
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

    # About Subdomain
    # if (\$host != '$DOMAIN') {
    #     rewrite ^/(.*)$ https://$DOMAIN/\$1 permanent;
    # }

    location ~* (robots\\.txt|favicon\\.ico|crossdomain\\.xml|google4c90d18e696bdcf8\\.html|BingSiteAuth\\.xml)\$  {
        root        $DOMAIN_DIR/static;
        expires     1d;
    }

    location ^~ /static {
        alias        $DOMAIN_DIR/static;
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
        proxy_set_header        Host        $DOMAINS_DNS_NGINX_REWRITE;
        proxy_set_header        X-Real_IP   \$remote_addr;
        proxy_set_header        X-Forwarded-For \$proxy_add_x_forwarded_for;

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

echo "
# Cron 定时更新证书(每月)
> crontab -e and add the following:
0 0 1 * * $PWD/$0 --domain=$DOMAIN --domain-dir=$DOMAIN_DIR --dns=$DOMAINS_DNS >> /var/log/lets-encrypt.log 2>&1
"
