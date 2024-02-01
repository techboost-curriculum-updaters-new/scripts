#!/bin/bash

cd ~

sudo yum update -y


# uninstall MariaDB, install MySQL 5.7
sudo service mariadb stop
sudo yum -y erase mariadb-config mariadb-common mariadb-libs mariadb
sudo yum -y localinstall https://repo.mysql.com/mysql80-community-release-el7-1.noarch.rpm
sudo yum-config-manager --disable mysql80-community
sudo yum-config-manager --enable mysql57-community
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
sudo yum -y install mysql-community-server mysql-community-devel
sudo systemctl start mysqld.service
sudo systemctl enable mysqld.service

DB_PASSWORD=$(sudo grep "A temporary password is generated" /var/log/mysqld.log | sed -s 's/.*root@localhost: //')
mysql -uroot -p${DB_PASSWORD} --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'TB@shibuya1';uninstall plugin validate_password;set password for root@localhost=password('');"

# install PostgreSQL11 (for heroku deploy)
sudo amazon-linux-extras install -y postgresql11
sudo yum -y install postgresql-devel

# uninstall rvm
if command -v rvm &> /dev/null; then
  rvm seppuku --force
  source ~/.bash_profile
fi


# install rbenv
if ! command -v rbenv &> /dev/null; then
  git clone https://github.com/sstephenson/rbenv.git .rbenv
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  echo 'export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
  source ~/.bash_profile
fi


# install ruby
export CONFIGURE_OPTS="--disable-install-doc --disable-install-rdoc"
rbenv install 2.7.3 -s
unset CONFIGURE_OPTS

rbenv global 2.7.3


# install rails
printf "install: --no-rdoc --no-ri\nupdate:  --no-rdoc --no-ri\n" >> ~/.gemrc
gem install rails -v 5.2.0


# install heroku
curl -OL https://cli-assets.heroku.com/heroku-linux-x64.tar.gz
tar zxf heroku-linux-x64.tar.gz && rm -f heroku-linux-x64.tar.gz
sudo mv heroku /usr/local
echo 'export PATH=/usr/local/heroku/bin:$PATH' >> $HOME/.bash_profile
source $HOME/.bash_profile
