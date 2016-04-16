#!/bin/bash

mkdir /downloads/.session
mkdir /watch
mkdir /config
cp /downloads/.htpasswd /var/www/rutorrent/
cp /etc/rtorrent.rc /config/.rtorrent.rc
mkdir -p /config/rutorrent/torrents
chown -R www-data:www-data /config/rutorrent
chown -R "nobody":"users" /downloads/.session /watch /config/.rtorrent.rc

rm -f /downloads/.session/rtorrent.lock

rm -f /etc/nginx/sites-enabled/*

rm -rf /etc/nginx/ssl

rm /var/www/rutorrent/.htpasswd

# Basic auth enabled by default
site=rutorrent-basic.nginx

# Check if TLS needed
if [[ -e /downloads/nginx.key && -e /downloads/nginx.crt ]]; then
mkdir -p /etc/nginx/ssl
cp /downloads/nginx.crt /etc/nginx/ssl/
cp /downloads/nginx.key /etc/nginx/ssl/
site=rutorrent-tls.nginx
fi

cp /root/$site /etc/nginx/sites-enabled/

# Check if .htpasswd presents
if [ -e /config/.htpasswd ]; then
cp /config/.htpasswd /var/www/rutorrent/ && chmod 755 /var/www/rutorrent/.htpasswd && chown www-data:www-data /var/www/rutorrent/.htpasswd
else
# disable basic auth
sed -i 's/auth_basic/#auth_basic/g' /etc/nginx/sites-enabled/$site
fi

nginx -g "daemon off;"

