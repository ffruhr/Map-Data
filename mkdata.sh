#!/bin/bash

# Alfred Daten 
alfred-json -r 158 -f json > /var/www/alfred_158.json
alfred-json -r 159 -f json > /var/www/alfred_159.json
jq -s '.[0] * .[1]' /var/www/alfred_158.json /var/www/alfred_159.json > /var/www/alfred_merged.json 

# Node Daten 
/etc/ffmap/bat2nodes.py -A -a /etc/ffmap/aliases.json -a /var/www/alfred_merged.json -o -d /var/www

# fastd Daten 
/etc/fastd/status.pl /tmp/fastd.sock | jq . | sed -r 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/127\.0\.0\.1/ > /var/www/fastd.json


