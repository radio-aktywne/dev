#!/bin/sh

cd /etc/my-certs/ssl/ || exit 1

while true; do
  wget traefik.me/fullchain.pem -O cert.pem
  wget traefik.me/privkey.pem -O privkey.pem
  sleep 86400
done
