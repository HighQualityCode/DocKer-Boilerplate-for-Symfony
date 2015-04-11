#!/bin/bash
set -e

#############################
## Init MySQL
#############################

echo "[client]
host=mysql
user=\"$MYSQL_USER\"
password=\"$MYSQL_PASSWORD\"

[mysql]
host=mysql
user=\"$MYSQL_USER\"
password=\"$MYSQL_PASSWORD\"
database=\"$MYSQL_DATABASE\"
default-character-set=utf8
local-infile=1
show-warnings
auto-rehash
sigint-ignore
reconnect

[mysqldump]
host=mysql
user=\"$MYSQL_USER\"
password=\"$MYSQL_PASSWORD\"

" | tee /root/.my.cnf > /home/.my.cnf

#############################
## Init SSMTP
#############################

sed -i "s/mailhub=.*/mailhub=${MAIL_GATEWAY}/" /etc/ssmtp/ssmtp.conf

#############################
## Init PHP-FPM
#############################

# Backup original
if [ ! -f "/usr/local/etc/.php-fpm.conf.default.original" ]; then
cp /etc/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/.www.original
fi

# Restore original
cp /etc/php5/fpm/pool.d/.www.original  /etc/php5/fpm/pool.d/www.conf
sed -i "s@listen = /var/run/php5-fpm.sock@listen = 9000@" /etc/php5/fpm/pool.d/www.conf

# Manipulate php-fpm configuration
echo "
; Server resource settings

pm.max_children = 10
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3

catch_workers_output = yes

access.log = /proc/self/fd/2
slowlog    = /proc/self/fd/2
request_slowlog_timeout = 30s

php_admin_value[error_log] = /proc/self/fd/2

env[TYPO3_CONTEXT]    = ${TYPO3_CONTEXT}
env[FLOW_CONTEXT]     = ${FLOW_CONTEXT}
env[FLOW_REWRITEURLS] = ${FLOW_REWRITEURLS}
" >> /etc/php5/fpm/pool.d/www.conf

#############################
## COMMAND
#############################

case "$1" in
    supervisord)
        exec supervisord
        ;;

    root)
        exec bash
        ;;

    *)
        export HOME=/home/
        sudo -E -u www-data "$@"
        ;;
esac
