#!/bin/bash
apt update
apt install -y ruby-full ruby-bundler build-essential git
ruby -v
bundler -v
