#!/bin/bash
set -e


if [ "$1" == "supervisord" ]; then
    # Visible provisioning
    bash /opt/docker/bin/provision.sh entrypoint
else
    # Hidden provisioning
    bash /opt/docker/bin/provision.sh entrypoint > /dev/null
fi

#############################
## COMMAND
#############################

case "$1" in

    ## Supervisord (start daemons)
    supervisord)
        ## Register IP
        ETH0_IP=$(hostname -i)
        mkdir -p /data/dns/
        chmod 777 /data/dns/
        echo "${ETH0_IP}"               > /data/dns/main.ip
        echo "${ETH0_IP}   main main_1" > /data/dns/main.hosts

        ## Start services
        cd /
        exec supervisord -c /opt/docker/conf/supervisord.conf --logfile /dev/null --pidfile /dev/null --user root
        ;;

    ## Root shell
    root)
        if [ "$#" -eq 1 ]; then
            ## No command, fall back to shell
            exec bash
        else
            ## Exec root command
            shift
            exec "$@"
        fi
        ;;

    ## Defined cli script
    cli)
        if [ -n "${CLI_SCRIPT}" ]; then
            shift
            exec sudo -H -E -u "${CLI_USER}" ${CLI_SCRIPT} "$@"
        else
            echo "[ERROR] No CLI_SCRIPT in docker-env.yml defined"
            exit 1
        fi
        ;;

    ## All other commands
    *)
        ## Execute cmd
        exec sudo -H -E -u "${CLI_USER}" "$@"
        ;;
esac
