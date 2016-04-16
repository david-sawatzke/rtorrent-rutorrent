#!/bin/bash

mkdir /downloads/.session
mkdir /watch
mkdir /config
cp /downloads/.htpasswd /var/www/rutorrent/
cp /etc/rtorrent.rc /config/.rtorrent.rc
mkdir -p /config/rutorrent/torrents
chown -R www-data:share /config/rutorrent
chown -R rtorrent /downloads/.session /watch /config/.rtorrent.rc

rm -f /downloads/.session/rtorrent.lock

rm -f /etc/nginx/sites-enabled/*

rm -rf /etc/nginx/ssl

rm /var/www/rutorrent/.htpasswd

# Basic auth enabled by default
site=rutorrent-basic.nginx
cp /root/$site /etc/nginx/sites-enabled/

# Check if .htpasswd presents
if [ -e /config/.htpasswd ]; then
cp /config/.htpasswd /var/www/rutorrent/ && chmod 755 /var/www/rutorrent/.htpasswd && chown www-data:www-data /var/www/rutorrent/.htpasswd
else
# disable basic auth
sed -i 's/auth_basic/#auth_basic/g' /etc/nginx/sites-enabled/$site
fi

nginx -g "daemon off;"

