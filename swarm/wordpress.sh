#!/bin/bash

internal_network=internal
external_network=external
mysql_root_pw=n30n30
nodes="node01 node02 node03"

for node in $nodes; do
    ssh $node "docker pull registry.neofonie.de/neo-website/wordpress:swarm.0.1"
    ssh $node "docker pull registry.neofonie.de/neo-website/varnish:swarm.0.1"
done

docker network ls -f name=$internal_network | grep $internal_network || \
docker network create -d overlay $internal_network

docker service ls -f name=mysql | grep mysql || \
docker service create           \
    --name mysql            \
    --network $internal_network     \
    --env MYSQL_ROOT_PASSWORD=$mysql_root_pw \
    mariadb

docker service ls -f name=wordpress | grep wordpress || \
docker service create           \
    --name wordpress        \
    --network $internal_network     \
    --env WORDPRESS_DB_PASSWORD=$mysql_root_pw \
    registry.neofonie.de/neo-website/wordpress:swarm.0.1

docker service ls -f name=varnish | grep varnish || \
docker service create           \
    --name varnish          \
    --env BACKEND_SERVICE=wordpress \
    --env BACKEND_PORT=80       \
    --env VARNISH_TEST_URL=/    \
    --network $internal_network     \
    --publish "80:8080"         \
    registry.neofonie.de/neo-website/varnish:swarm.0.1


