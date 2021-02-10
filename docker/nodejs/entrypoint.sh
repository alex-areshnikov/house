#!/bin/bash
set -e

cd /var/www/house

yarn copart_watcher

# exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
