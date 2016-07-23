#!/bin/sh

deluser rtorrent
delgroup share
adduser -u $PUID -s /bin/sh -D -G nobody rtorrent
addgroup -g $PGID share
addgroup nginx share
addgroup rtorrent share

mkdir -p /downloads/.session
mkdir -p /watch
mkdir -p /config
mkdir -p /config/rutorrent/torrents
chown -R nginx:share /config/rutorrent
chown -R rtorrent /watch /config/.rtorrent.rc
chown -R rtorrent:share /downloads

rm -f /downloads/.session/rtorrent.lock

rm /var/www/rutorrent/.htpasswd

# Check if .htpasswd presents
if [ -e /config/.htpasswd ]; then
	cp /config/.htpasswd /var/www/rutorrent/ && chmod 755 /var/www/rutorrent/.htpasswd && chown nginx /var/www/rutorrent/.htpasswd
	# enable basic auth
	sed -i 's/#auth_basic/auth_basic/g' /etc/nginx/nginx.conf
else
	# disable basic auth
	sed -i 's/auth_basic/#auth_basic/g' /etc/nginx/nginx.conf
fi

exec supervisord -c /etc/supervisor/supervisord.conf
