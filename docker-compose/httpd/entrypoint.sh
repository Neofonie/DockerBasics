#!/bin/bash

shutdown() {
    # kill all pids != 1
    kill $(ps --no-headers -eo pid | egrep -v "[[:space:]]*1$") >/dev/null 2>&1
    exit
}

trap shutdown 15 

apachectl start

sleep infinity & 

wait
