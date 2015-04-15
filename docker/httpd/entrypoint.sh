#!/bin/bash

###################
# httpd.conf
###################

# Backup original
if [ ! -f "/usr/local/apache2/conf/.httpd.conf.original" ]; then
    cp /usr/local/apache2/conf/httpd.conf /usr/local/apache2/conf/.httpd.conf.original
fi

cp /usr/local/apache2/conf/.httpd.conf.original /usr/local/apache2/conf/httpd.conf

echo "
Include conf/docker-vhost.conf
" >> /usr/local/apache2/conf/httpd.conf

###################
# vhost
###################

# Detect correct path of document root
DOCUMENT_ROOT=$(readlink -f "/docker/$DOCUMENT_ROOT")

cp /usr/local/apache2/conf/.docker-vhost.conf.original   /usr/local/apache2/conf/docker-vhost.conf
/bin/sed -i "s@<DOCUMENT_ROOT>@${DOCUMENT_ROOT}@"        /usr/local/apache2/conf/docker-vhost.conf
/bin/sed -i "s@<DOCUMENT_INDEX>@${DOCUMENT_INDEX}@"        /usr/local/apache2/conf/docker-vhost.conf
/bin/sed -i "s@<TYPO3_CONTEXT>@${TYPO3_CONTEXT}@"        /usr/local/apache2/conf/docker-vhost.conf
/bin/sed -i "s@<FLOW_CONTEXT>@${FLOW_CONTEXT}@"          /usr/local/apache2/conf/docker-vhost.conf
/bin/sed -i "s@<FLOW_REWRITEURLS>@${FLOW_REWRITEURLS}@"  /usr/local/apache2/conf/docker-vhost.conf
/bin/sed -i "s@<FPM_HOST>@${MAIN_PORT_9000_TCP_ADDR}@"   /usr/local/apache2/conf/docker-vhost.conf
/bin/sed -i "s@<FPM_PORT>@${MAIN_PORT_9000_TCP_PORT}@"   /usr/local/apache2/conf/docker-vhost.conf

#############################
## COMMAND
#############################

if [ "$1" = 'httpd' ]; then
    ## Register IP
    ETH0_IP=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
    mkdir -p /data/dns/
    chmod 777 /data/dns/
    echo "${ETH0_IP}"             > /data/dns/web.ip
    echo "${ETH0_IP}   web web_1" > /data/dns/web.hosts

    exec httpd -DFOREGROUND
fi

exec "$@"
