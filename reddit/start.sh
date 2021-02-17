#!/bin/bash
set -e
echo "Starting MongoDB....."

/usr/bin/mongod --fork --syslog
echo "MongoDB Started!!"


echo "RUN reddit!"
cd /app && puma || exit
