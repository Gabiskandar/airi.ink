#!/usr/bin/env bash

curl -X POST "https://api.digitalocean.com/v2/droplets" \
     -d'{"name":"airi.ink","region":"ams3","size":"512mb","image":"ubuntu-16-04-x64","private_networking":true,"ipv6":true,"ssh_keys":null,"user_data":null,"backups":false}' \
     -H "Authorization: Bearer $TOKEN" \
     -H "Content-Type: application/json"
