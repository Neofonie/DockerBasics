#!/bin/bash

internal_network=wordpress
mysql_root_pw=ichsinge1234

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
    wordpress
