FROM alpine:3.4
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
      supervisor \
    # download rutorrent
    && mkdir -p /var/www \
    && wget -O /tmp/ruTorrent.zip https://bintray.com/artifact/download/novik65/generic/ruTorrent-3.7.zip \
    && unzip -d /tmp /tmp/ruTorrent.zip \
    && mv /tmp/ruTorrent-master /rutorrent \
    && rm /tmp/ruTorrent.zip \
    && chown -R nginx /rutorrent \
    && chown -R nginx /var/lib/nginx

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
