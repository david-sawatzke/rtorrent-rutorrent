FROM alpine
MAINTAINER David Sawatzke <david@sawatzke.de>

# Install needed packages
# Geoip is currently in testing
RUN apk add --no-cache \
	rtorrent \
	unzip \
	unrar \
	curl \
	php-fpm \
	php-cli \
	php-json \
#	php-geoip \
	nginx \
	wget \
	ffmpeg \
	supervisor

# download rutorrent
RUN mkdir -p /var/www && \
	wget -O /tmp/ruTorrent.zip https://bintray.com/artifact/download/novik65/generic/ruTorrent-3.7.zip && \
	unzip -d /tmp /tmp/ruTorrent.zip && \
	mv /tmp/ruTorrent-master /var/www/rutorrent && \
	rm /tmp/ruTorrent.zip && \
	wget -O /tmp/ruTorrentMobile.zip https://github.com/xombiemp/ruTorrentMobile/archive/master.zip && \
	unzip -d /tmp /tmp/ruTorrentMobile.zip && \
	mv /tmp/rutorrentMobile-master /var/www/rutorrent/plugins/mobile && \
	rm /tmp/ruTorrentMobile.zip && \
	chown -R nginx /var/www/rutorrent

# Add rutorrent config
ADD ./config.php /var/www/rutorrent/conf/

# Add nginx config
ADD nginx.conf /etc/nginx/

# Add php-fpm config
ADD php-fpm.conf /etc/php/php-fpm.conf

# Add init script
ADD init.sh /root/

# Add supervisor config
ADD supervisord.conf /etc/supervisor/

EXPOSE 80
EXPOSE 49160
EXPOSE 49161
VOLUME /downloads
VOLUME /watch
VOLUME /config

CMD ["/root/init.sh"]
