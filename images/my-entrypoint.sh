#!/bin/bash

shutdown() {
    # kill all pids != 1
    kill $(ps --no-headers -eo pid | egrep -v "[[:space:]]*1$") >/dev/null 2>&1
    wait
    exit
}

trap shutdown 15 

export MYSQL_ROOT_PASSWORD=$(cat /var/run/secrets/db_root_password)

docker-entrypoint.sh &

wait
