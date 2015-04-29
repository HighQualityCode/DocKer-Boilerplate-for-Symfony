#!/bin/bash

###################
# Storage directories
###################

mkdir -p /data/solr/
mkdir -p /data/dns/
mkdir -p /data/cache/

find /data/ -type d -print0 | xargs -0 --no-run-if-empty chmod 777

###################
# DNS
###################

find /data/dns/ -type f -exec rm -rf {} \;

#############################
## COMMAND
#############################

if [ "$1" = 'noop' ]; then
    exec sleep 10000d
fi

exec "$@"
