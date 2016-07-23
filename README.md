Docker container with rTorrent and ruTorrent (stable and latest from github)
============================================================================

(To get github's latests pick 64-latest and 32-latest tags)
----------

Multiple processes inside the container managed by supervisor:

- nginx
- php5-fpm
- rtorrent

----------
Exposed:

 - Web UI ports: 80 and 443
 - DHT UDP port: 49160
 - Incoming connections port: 49161
 - Downloads volume: /downloads
 - rtorrent scratch files (watch and .session will be created automatically): /downloads
 - ruTorrent ui config (config will be created automatically): /config/rutorrent
 - rTorrent config: /config/.rtorrent.rc

----------
ruTorrent UI configuration stored outside the container in /config/rutorrent to ease the container upgrades.


----------
Adding basic auth:

Put .htpasswd into your /config volume root, the container will re-read .htpasswd each time it starts. To remote auth, simply remove .htpasswd and restart your container.

Instructions on how to generate .htpasswd can be found here: [Nginx FAQ][1]

    $ printf "John:$(openssl passwd -crypt V3Ry)\n" >> .htpasswd # this example uses crypt encryption

    $ printf "Mary:$(openssl passwd -apr1 SEcRe7)\n" >> .htpasswd # this example uses apr1 (Apache MD5) encryption

    $ printf "Jane:$(openssl passwd -1 V3RySEcRe7)\n" >> .htpasswd # this example uses MD5 encryption

    $ PASSWORD="SEcRe7PwD";SALT="$(openssl rand -base64 3)";SHA1=$(printf "$PASSWORD$SALT" | openssl dgst -binary -sha1 | sed 's#$#'"$SALT"'#' | base64);printf "Jim:{SSHA}$SHA1\n" >> .htpasswd) # this example uses SSHA encryption

----------
Basic auth:

Apparently, put .htpasswd, nginx.key and nginx.crt into /downloads root.

----------
Example

    $ docker run -dt --name rtorrent-rutorrent -p 8080:80 -p 49160:49160/udp -p 49161:49161 -v ~/test:/downloads $CONTAINERNAME

Access web-interface: enter http://your_host_address:8080 in a browser
