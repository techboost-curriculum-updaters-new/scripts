#!/bin/bash

# java-21 install
sudo yum -y remove "java*"
sudo yum -y localinstall https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.rpm
echo 'export JAVA_HOME=/usr/lib/jvm/jdk-21-oracle-x64' >> /home/ec2-user/.bashrc

# tomcat9 install
sudo amazon-linux-extras install tomcat9 -y

# modify tomcat service script to load setenv.sh
TM_SVC=/usr/lib/systemd/system/tomcat.service
sudo sh -c "cat > $TM_SVC <<EOF
# Systemd unit file for default tomcat
# 
# To create clones of this service:
# DO NOTHING, use tomcat@.service instead.

[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target

[Service]
Type=simple
EnvironmentFile=/etc/tomcat/tomcat.conf
Environment=\"NAME=\"
EnvironmentFile=-/etc/sysconfig/tomcat
EnvironmentFile=-/usr/share/tomcat/bin/setenv.sh
ExecStart=/usr/bin/java -jar /usr/share/tomcat/webapps/app.jar
SuccessExitStatus=143
User=tomcat

[Install]
WantedBy=multi-user.target
EOF"

# The configuration to not delete uploaded tmp images in Tomcat
NOT_DELETE_TMP_IMG_CONF_FILE=/etc/tmpfiles.d/not_delete_tmp_img.conf
sudo sh -c "cat > $NOT_DELETE_TMP_IMG_CONF_FILE <<EOF
# DO NOT DELETE tmp/tomcat-docbase.8080.*/
x /tmp/tomcat-docbase.8080.*/*
EOF"

sudo systemd-tmpfiles --create

# create setenv.sh
sudo touch /usr/share/tomcat/bin/setenv.sh
sudo chmod 666 /usr/share/tomcat/bin/setenv.sh

# enable tomcat
sudo systemctl enable tomcat

# create ~/environment/setenv.sh
touch ~/environment/setenv.sh
sudo chmod 666 ~/environment/setenv.sh
sudo chown tomcat:tomcat ~/environment/setenv.sh

# postgres13 install
sudo amazon-linux-extras install postgresql13 -y
sudo yum install postgresql-server postgresql-devel -y

# PostgreSQL データディレクトリの確認と初期化
if [ -d /var/lib/pgsql/data/ ]; then
    echo "PostgreSQL data directory exists. Removing existing data."
    sudo rm -rf /var/lib/pgsql/data/*  # 既存のデータを削除
else
    echo "PostgreSQL data directory does not exist. Creating it."
    sudo mkdir -p /var/lib/pgsql/data
fi

# PostgreSQL データディレクトリの所有者を変更
sudo chown postgres:postgres /var/lib/pgsql/data

# PostgreSQL 初期化
sudo postgresql-setup initdb

# change postgres user password
sudo sh -c "echo 'postgres:postgres' | chpasswd"

# modify /var/lib/pgsql/data/postgresql.conf
PSQL_CONF=/var/lib/pgsql/data/postgresql.conf
sudo cp ${PSQL_CONF} ${PSQL_CONF}.$(date +%Y%m%d%H%M%S)
sudo ed - ${PSQL_CONF} <<EOF
,s/^timezone.*$/timezone = 'Asia\/Tokyo'/g
,s/^lc_messages.*$/lc_messages = 'C'/g
,s/^lc_monetary.*$/lc_monetary = 'C'/g
,s/^lc_numeric.*$/lc_numeric = 'C'/g
,s/^lc_time.*$/lc_time = 'C'/g
wq
EOF

# modify /var/lib/pgsql/data/pg_hba.conf
PG_CONF=/var/lib/pgsql/data/pg_hba.conf
sudo cp ${PG_CONF} ${PG_CONF}.$(date +%Y%m%d%H%M%S)
sudo ed - ${PG_CONF} <<EOF
/peer$/ s/peer/trust/
/ident$/ s/ident/trust/
/ident$/ s/ident/trust/
wq
EOF

# enable and start postgresql
sudo systemctl start postgresql
sudo systemctl enable postgresql

# remove apache
sudo yum remove httpd -y

# nginx install
sudo amazon-linux-extras install nginx1 -y
sudo systemctl enable nginx

# modify /etc/nginx/nginx.conf
# backup
NGINX_CONF=/etc/nginx/nginx.conf
if [ ! -f ${NGINX_CONF}.org ]; then
  sudo cp ${NGINX_CONF} ${NGINX_CONF}.org
fi

sudo cp ${NGINX_CONF} ${NGINX_CONF}.$(date +%Y%m%d%H%M%S)

if [ -f ${NGINX_CONF}.org ]; then
  sudo cp ${NGINX_CONF}.org ${NGINX_CONF}
fi
# create /etc/nginx/nginx.conf
sudo tee ${NGINX_CONF} <<'EOF' >/dev/null
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;
        client_max_body_size 20M;

        location / {
            proxy_read_timeout 300;
            proxy_connect_timeout 300;
            proxy_redirect off;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header Host $http_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_pass http://localhost:8080/;
        }

    }
}
EOF

# modify /etc/tomcat/server.xml
# backup
SV_CONF=/etc/tomcat/server.xml
if [ ! -f ${SV_CONF}.org ]; then
  sudo cp ${SV_CONF} ${SV_CONF}.org
fi

sudo cp ${SV_CONF} ${SV_CONF}.$(date +%Y%m%d%H%M%S)

if [ -f ${SV_CONF}.org ]; then
  sudo cp ${SV_CONF}.org ${SV_CONF}
fi

sudo ed - ${SV_CONF} <<EOF > /dev/null
/\/Host/ 
i
<Valve className="org.apache.catalina.valves.RemoteIpValve" protocolHeader="x-forwarded-proto"/>
.
wq
EOF

sudo chown tomcat:tomcat ${SV_CONF}

# start nginx
sudo systemctl start nginx

# disable php-pfm
if systemctl list-unit-files | grep -q php-fpm.service; then
  sudo systemctl stop php-fpm
  sudo systemctl disable php-fpm
fi

# create tomcat test page
sudo mkdir -p /usr/share/tomcat/webapps/ROOT
sudo tee /usr/share/tomcat/webapps/ROOT/index.html <<EOF
Hello EC2 tomcat! 
EOF

# install Let's Encrypt certbot
sudo amazon-linux-extras install epel -y  # EPELを有効化
sudo yum install -y certbot python2-certbot-nginx  # Certbotをインストール

# create cron.txt
CRON_TXT=~/environment/cron.txt
tee ${CRON_TXT} <<'EOF' >/dev/null
# cron configuration
## MyDNS User/Password ###########
MYDNS_USER="your_mydns_id"
MYDNS_PASSWORD="your_password"
##################################

## Invalidate Mail notification
MAILTO=""

# mydns notification, at 04:00 everyday
0 4 * * * ///usr/bin/wget -O - "http://$MYDNS_USER:$MYDNS_PASSWORD@www.mydns.jp/login.html" > /dev/null 2>&1

# renew let's encrypt certificates, at 03:00 1st of every month
0 3 1 * * sudo /usr/bin/certbot renew --no-self-upgrade > /dev/null 2>&1
EOF

# final checks
COMPLETED=1
# java
JV=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | awk -F'.' '{print $1}')
if [[ ! "$JV" =~ 21 ]]; then
  echo "Java version 21 is not installed!"
  COMPLETED=0
fi
# nginx
which nginx >/dev/null 2>&1
if [ $? -eq  1 ]; then
  echo "Nginx is not installed!"
  COMPLETED=0
fi

# certbot
which certbot >/dev/null 2>&1
if [ $? -eq  1 ]; then
  echo "Certbot is not installed!"
  COMPLETED=0
fi

if [ ${COMPLETED} -eq 1 ]; then
  echo "All components have been successfully installed!"
else
  echo "Some components failed to install. Check the logs."
fi