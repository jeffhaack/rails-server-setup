#!/bin/bash

readonly USERNAME=jeff
readonly USERPASS=pleh

readonly POSTGRES_USER=blog
readonly POSTGRES_PASS=blog_pass
readonly POSTGRES_DB=blog_production

readonly WEBUSER=nginx
readonly WEBGROUP=web

# Install requisite packages
apt-get update
apt-get -y install curl git-core python-software-properties
add-apt-repository ppa:nginx/stable
add-apt-repository ppa:pitti/postgresql
add-apt-repository ppa:chris-lea/node.js
apt-get update
apt-get -y install nginx
apt-get -y install postgresql libpq-dev
apt-get -y install nodejs
apt-get -y install build-essential openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev
apt-get -y install libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf
apt-get -y install libc6-dev ncurses-dev automake libtool bison subversion

# If you want to send mail, install postfix
# apt-get -y install postfix

# Create users and groups
groupadd $WEBGROUP
useradd -s /sbin/nologin -r $WEBUSER
usermod -a -G $WEBGROUP $WEBUSER
useradd -s /bin/bash -m $USERNAME -p $USERPASS
usermod -a -G sudo $USERNAME
usermod -a -G $WEBGROUP $USERNAME

# Setup postgresql database for project
sudo -u postgres psql -c "create user $POSTGRES_USER with password '$POSTGRES_PASS';"
sudo -u postgres psql -c "create database $POSTGRES_DB owner $POSTGRES_USER;"

# Install RVM
sudo bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
umask g+w
source /etc/profile.d/rvm.sh
usermod -a -G rvm $USERNAME # add USERNAME to rvm group

# Install 1.9.3 and set as default
rvm install 1.9.3
source "/usr/local/rvm/scripts/rvm"
rvm --default use 1.9.3

# Install rails
gem install rails --no-ri --no-rdoc
gem install unicorn --no-ri --no-rdoc

cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
cp config/nginx.conf /etc/nginx/
service nginx start

# Setup web directory
mkdir /var/www
chgrp -R web /var/www # set /var/www owner group to "web"
chmod -R 775 /var/www # group write permission
usermod -a -G web $USERNAME  # if you need to add user to web group



# To get the unicorn config file
#curl -o config/unicorn.rb https://raw.github.com/defunkt/unicorn/master/examples/unicorn.conf.rb

#apt-get -y install ruby
#git clone git://github.com/rubygems/rubygems.git
#cd rubygems
#ruby setup.rb
#ln -s /usr/bin/gem1.8 /usr/bin/gem
#gem install rails


