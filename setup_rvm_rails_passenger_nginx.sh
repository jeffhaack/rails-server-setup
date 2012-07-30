#!/bin/bash

sudo apt-get update
sudo apt-get -y install aptitude

sudo aptitude -y install curl git-core
sudo aptitude -y install build-essential bison openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev nodejs
sudo aptitude -y install libcurl4-openssl-dev
sudo aptitude -y install mysql-server