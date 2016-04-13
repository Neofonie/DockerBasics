#!/bin/bash

docker events --filter "event=start" --filter "event=kill" | while read line
do
        docker exec ${COMPOSE_PROJECT}_loadbalancer_1 reload
done
