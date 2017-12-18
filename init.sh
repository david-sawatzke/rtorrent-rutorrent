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
mkdir -p /config/rutorrent
chown -R nginx:share /config/rutorrent
chown -R rtorrent /watch /config/.rtorrent.rc
chown -R rtorrent:share /downloads

rm -f /downloads/.session/rtorrent.lock

rm /rutorrent/.htpasswd

# Check if .htpasswd presents
if [ -e /config/.htpasswd ]; then
	cp /config/.htpasswd /rutorrent/ && chmod 755 /rutorrent/.htpasswd && chown nginx /rutorrent/.htpasswd
	# enable basic auth
	sed -i 's/#auth_basic/auth_basic/g' /etc/nginx/nginx.conf
else
	# disable basic auth
	sed -i 's/auth_basic/#auth_basic/g' /etc/nginx/nginx.conf
fi

# Create a pipe to filter the "reaped unknown pid" messages out as they just
# pollute the logs and don't add anything meaningfull
# As tmp doesn't get cleared with restart, remove any leftovers
rm /tmp/output 2> /dev/null
mkfifo /tmp/output
grep -v "INFO reaped unknown pid" < /tmp/output &

exec supervisord -c /etc/supervisor/supervisord.conf > /tmp/output
