#!/bin/bash
set -e

DEBIAN_FRONTEND=noninteractive

sleep 20
ps aux | grep -i apt | grep -v grep
apt-get update
apt-get install -y ruby-full ruby-bundler build-essential git
ruby -v
bundler -v
