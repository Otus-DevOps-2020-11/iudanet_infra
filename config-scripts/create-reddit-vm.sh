#!/bin/bash
yc compute instance create \
  --name reddit-app \
  --hostname reddit-app \
  --memory=2GB \
  --create-boot-disk image-family=reddit-full,size=10GB \
  --network-interface subnet-name=otus-net-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --ssh-key ~/.ssh/appuser.pub
