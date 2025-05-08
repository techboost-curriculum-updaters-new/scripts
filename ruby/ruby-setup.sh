#!/bin/bash

# root へ移動
cd ~

# キャッシュメモリ を解放
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"

# swap領域 を拡張
sudo dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo chmod 600 /var/swap.1
sudo mkswap /var/swap.1
sudo swapon /var/swap.1
sudo cp -p /etc/fstab /etc/fstab.ORG
sudo sh -c "echo '/var/swap.1 swap swap defaults 0 0' >> /etc/fstab"

# yum を更新
sudo yum update -y

# MariaDB を削除
sudo service mariadb stop
sudo yum -y erase mariadb-config mariadb-common mariadb-libs mariadb

# ローカルでリポジトリを追加
sudo yum -y localinstall https://repo.mysql.com/mysql80-community-release-el7-11.noarch.rpm

# MySQL8.0をインストール
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
sudo yum -y install mysql-community-server mysql-community-devel

# MySQLサーバを起動
sudo systemctl start mysqld.service
sudo systemctl enable mysqld.service

# rootの初期パスワードを確認
DB_PASSWORD=$(sudo grep "A temporary password is generated" /var/log/mysqld.log | sed -s 's/.*root@localhost: //')

# 初期パスワードでMySQLにログインし、パスワードを空文字に変更
mysql -u root -p${DB_PASSWORD} --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'TB@shibuya1';SET PERSIST validate_password.policy = LOW;SET PERSIST validate_password.mixed_case_count = 0;SET PERSIST validate_password.number_count = 0;SET PERSIST validate_password.special_char_count = 0;SET PERSIST validate_password.length = 0;ALTER USER 'root'@'localhost' IDENTIFIED BY '';";

# rvm をアンインストール
if command -v rvm &> /dev/null; then
  rvm seppuku --force
  source ~/.bash_profile
fi

# rbenv をインストール
if ! command -v rbenv &> /dev/null; then
  git clone https://github.com/sstephenson/rbenv.git .rbenv
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  echo 'export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
  source ~/.bash_profile
fi

# ruby2.7 をインストール
export CONFIGURE_OPTS="--disable-install-doc --disable-install-rdoc"
rbenv install 2.7.3 -s
unset CONFIGURE_OPTS

rbenv global 2.7.3

# rails5.2 をインストール
printf "install: --no-rdoc --no-ri\nupdate:  --no-rdoc --no-ri\n" >> ~/.gemrc
gem install nokogiri -v 1.15.5
gem install rails -v 5.2.0

# .bash_profile を再読み込み
source $HOME/.bash_profile