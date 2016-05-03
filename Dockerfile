FROM ubuntu
USER root

# add ffmpeg ppa
ADD ./ffmpeg-next.list /etc/apt/sources.list.d/ffmpeg-next.list

# install
RUN apt-get update && \
    apt-get install -y --force-yes rtorrent unzip unrar-free mediainfo curl php5-fpm php5-cli php5-geoip nginx wget ffmpeg supervisor && \
    rm -rf /var/lib/apt/lists/*

# configure nginx
ADD rutorrent-*.nginx /root/

# download rutorrent
RUN mkdir -p /var/www && \
    wget https://bintray.com/artifact/download/novik65/generic/ruTorrent-3.7.zip && \
    unzip ruTorrent-3.7.zip && \
    mv ruTorrent-master /var/www/rutorrent && \
    rm ruTorrent-3.7.zip && \
    git clone https://github.com/xombiemp/rutorrentMobile.git /var/www/rutorrent/plugins/mobile && \
    rm -rf /var/www/rutorrent/plugins/mobile/.git
RUN groupadd share
RUN useradd -d /home/rtorrent -m -s /bin/bash rtorrent
RUN usermod -aG share www-data
RUN usermod -aG share rtorrent
ADD ./config.php /var/www/rutorrent/conf/
RUN chown -R www-data:www-data /var/www/rutorrent

# add startup and init script
ADD startup.sh /root/
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
