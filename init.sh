#!/bin/bash

# exit script if return code != 0
set -eu


# set user nobody to specified user id (non unique)
usermod -o -u "${PUID}" rtorrent
echo "[info] Env var PUID  defined as ${PUID}"

# set group users to specified group id (non unique)
groupmod -o -g "${PGID}" share
echo "[info] Env var PGID defined as ${PGID}"

echo "[info] Starting Supervisor..."

supervisord
