FROM alpine:3.5
MAINTAINER David Sawatzke <david@sawatzke.de>

# Install needed packages
# Geoip is currently in testing
RUN apk add --no-cache \
      rtorrent \
      unzip \
      unrar \
      curl \
      php5-fpm \
      php5-cli \
      php5-json \
      #	php-geoip \
      nginx \
      wget \
      ffmpeg \
      openssl \
      libressl \
      ca-certificates \
      supervisor \
    && mkdir -p /var/www \
    && wget -O /tmp/ruTorrent.tar.gz https://github.com/Novik/ruTorrent/archive/v3.8.tar.gz \
    && tar -xzf /tmp/ruTorrent.tar.gz -C /tmp \
    && rm /tmp/ruTorrent.tar.gz \
    && mv /tmp/ruTorrent-* /rutorrent \
    && chown -R nginx /rutorrent \
    && chown -R nginx /var/lib/nginx \
    && mkdir /home/rtorrent \
    && ln -s /config/.rtorrent.rc /home/rtorrent/.rtorrent.rc

# Add rutorrent config
ADD ./config.php /rutorrent/conf/

# Add nginx config
ADD nginx.conf /etc/nginx/

# Add php-fpm config
ADD php-fpm.conf /etc/php5/php-fpm.conf

# Add init script
ADD init.sh /

# Add supervisor config
ADD supervisord.conf /etc/supervisor/

EXPOSE 80
EXPOSE 49160
EXPOSE 49161
VOLUME ["/downloads", "/watch", "/config"]

CMD ["/init.sh"]
