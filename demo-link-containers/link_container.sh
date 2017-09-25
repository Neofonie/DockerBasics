#!/bin/bash

function commands() {
cat << EOF
docker ps -a 
docker rm -v -f web01 web02 loadbalancer
docker run -d --name=web01 neoworkshop/demo-server
docker run -d --name=web02 neoworkshop/demo-server
docker run -d --name=loadbalancer --link web01:backend01 --link web02:backend02 -p 42080:8080 neoworkshop/demo-loadbalancer
docker ps -a 
docker exec loadbalancer bash -c "cat /etc/hosts"
docker exec loadbalancer bash -c "ping -c 1 web02"
docker exec loadbalancer bash -c "wget -O - -q http://127.0.0.1:8080/ && wget -O - -q http://127.0.0.1:8080/"
EOF
}

function runcmd() {
    OLD_IFS=$IFS
    NEW_IFS='
'
    IFS=$NEW_IFS

    for command in $(commands); do
        echo running: $command
        sh -c "$command"
        echo done.
        echo
    done
}

runcmd

