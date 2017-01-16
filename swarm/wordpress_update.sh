#!/bin/bash

mkdir /home/workshop/mysql
docker service update --mount-add type=bind,source=/home/workshop/mysql,destination=/var/lib/mysql mysql
docker service update --constraint-add node.hostname==$(hostname) mysql

docker service update --mount-add type=bind,source=/mnt/glusterfs/wordpress,destination=/var/www/html wordpress
