#!/bin/bash
set -e
DEBIAN_FRONTEND=noninteractive
sleep 30
sudo apt-get -qqq update
sudo apt-get install -qqq -y apt-transport-https ca-certificates gnupg libssl-dev
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
sudo apt-get -qqq update
sudo apt-get -qqq install -y mongodb-org
sudo sed -i 's@bindIp: 127.0.0.1@bindIp: 0.0.0.0@' /etc/mongod.conf
sudo systemctl restart mongod
sudo systemctl enable mongod
sudo systemctl status mongod --no-pager
