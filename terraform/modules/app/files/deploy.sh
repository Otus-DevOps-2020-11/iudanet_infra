#!/bin/bash
set -e
APP_DIR=${1:-$HOME}
sleep 20
sudo apt-get -qqq install -y git
git clone --quiet -b monolith https://github.com/express42/reddit.git $APP_DIR/reddit
cd $APP_DIR/reddit
bundle install
sudo mv /tmp/puma.service /etc/systemd/system/puma.service
sudo systemctl start puma
sudo systemctl enable puma
sudo systemctl status puma
