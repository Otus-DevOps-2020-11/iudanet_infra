#!/bin/bash
set -e

useradd -m -u 10000 -d /opt/reddit reddit

cd /opt/reddit
sudo -u reddit git clone -b monolith https://github.com/express42/reddit.git app
cd app/
sudo -u reddit bundle install --path vendor/bundle

ls /tmp/*
mv /tmp/puma.service /etc/systemd/system/puma.service
ls /tmp/*
ls /etc/systemd/system/

systemctl daemon-reload
systemctl enable puma
systemctl start puma
