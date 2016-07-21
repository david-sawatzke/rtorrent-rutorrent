FROM ubuntu
USER root

# add ffmpeg ppa
ADD ./ffmpeg-next.list /etc/apt/sources.list.d/ffmpeg-next.list

# install
RUN apt-get update && \
    apt-get install -y --force-yes rtorrent unzip unrar-free mediainfo curl php5-fpm php5-cli php5-geoip nginx wget ffmpeg supervisor && \
    rm -rf /var/lib/apt/lists/*

# configure nginx
ADD nginx.conf /etc/nginx/

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
	groupadd share && \
	useradd -d /home/rtorrent -m -s /bin/bash rtorrent && \
	usermod -aG share www-data && \
	usermod -aG share rtorrent && \
	./config.php /var/www/rutorrent/conf/ && \
	chown -R www-data:www-data /var/www/rutorrent

# add init script
ADD init.sh /root/

# configure supervisor
ADD supervisord.conf /etc/supervisor/conf.d/

EXPOSE 80
EXPOSE 49160
EXPOSE 49161
VOLUME /downloads
VOLUME /watch
VOLUME /config

CMD ["/root/init.sh"]
