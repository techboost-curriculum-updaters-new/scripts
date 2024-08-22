#!/bin/bash

# スクリプト開始時刻を記録
START_TIME=$SECONDS

# キャッシュメモリ を解放
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"

# swap領域 を拡張
sudo dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo chmod 600 /var/swap.1
sudo mkswap /var/swap.1
sudo swapon /var/swap.1
sudo cp -p /etc/fstab /etc/fstab.ORG
sudo sh -c "echo '/var/swap.1 swap swap defaults 0 0' >> /etc/fstab"

# パッケージ情報の更新
sudo yum update -y

# 必要なツールとライブラリのインストール
sudo yum install -y git bzip2 libffi-devel amazon-linux-extras curl

# 開発ツールのインストール（主要な開発ライブラリを含む）
sudo yum groupinstall -y "Development Tools"
sudo yum install -y openssl-devel readline-devel zlib-devel

# MariaDB のアンインストールと MySQL 5.7 のインストール
sudo service mariadb stop
sudo yum -y erase mariadb-config mariadb-common mariadb-libs mariadb
sudo yum -y localinstall https://repo.mysql.com/mysql80-community-release-el7-1.noarch.rpm
sudo yum-config-manager --disable mysql80-community
sudo yum-config-manager --enable mysql57-community
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
sudo yum -y install mysql-community-server
sudo systemctl start mysqld.service
sudo systemctl enable mysqld.service
DB_PASSWORD=$(sudo grep "A temporary password is generated" /var/log/mysqld.log | sed -s 's/.*root@localhost: //')
mysql -uroot -p"${DB_PASSWORD}" --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'NewSecurePassword123!'; uninstall plugin validate_password; set password for root@localhost=password('');"

# PostgreSQL 11 のインストール
sudo amazon-linux-extras install -y postgresql11
sudo yum -y install postgresql-devel

# rbenv のインストール
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

# ruby-build のインストール
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Ruby 2.7.3 のインストール
rbenv install 2.7.3
rbenv global 2.7.3

# RubyGems の更新
gem install rubygems-update -v 3.3.22
update_rubygems

# Rails 5.2.0 のインストール
gem install nokogiri -v 1.15.6
gem install rails -v 5.2.0

# Node.js のインストール
curl -fsSL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo yum install -y nodejs

# Yarn のインストール
sudo npm install --global yarn

# PHP 8.2 のインストール
sudo yum remove -y php php-*
sudo amazon-linux-extras disable lamp-mariadb10.2-php7.2
sudo amazon-linux-extras enable php8.2
sudo yum clean metadata
sudo yum install -y php-cli php-pdo php-mbstring php-mysqlnd php-json php-gd php-openssl php-curl php-xml php-intl
sudo rm -f /etc/php.d/30-xdebug.ini

# composer のインストール
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/bin/composer

# mysql2 gem のインストール
sudo yum install -y mysql-devel
gem install mysql2 -v '0.5.5' --source 'https://rubygems.org/'

# ターミナルのプロンプト表示設定
echo '#!/bin/sh' > /home/ec2-user/prompt.sh
echo 'parse_git_branch() {' >> /home/ec2-user/prompt.sh
echo '    git branch 2> /dev/null | sed -e '\''/^[^*]/d'\'' -e '\''s/* \(.*\)/ (\1)/'\''' >> /home/ec2-user/prompt.sh
echo '}' >> /home/ec2-user/prompt.sh
echo 'export PS1="\[\033[01;32m\]\u\[\033[00m\]:\[\033[34m\]\w\[\033[00m\]\$(parse_git_branch) $ "' >> /home/ec2-user/prompt.sh

sudo chmod 755 /home/ec2-user/prompt.sh
echo 'source ~/prompt.sh' >> /home/ec2-user/.bashrc
echo 'source ~/prompt.sh' >> /home/ec2-user/.bash_profile

# シェルの設定を再読み込み
source ~/.bashrc
source ~/.bash_profile

echo "環境構築が完了しました。"

# 経過時間を計算
ELAPSED_TIME=$(($SECONDS - $START_TIME))

echo "実行時間: ${ELAPSED_TIME}秒"