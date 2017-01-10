#!/bin/bash

apt-get install glusterfs-server
gluster peer probe node02
gluster peer probe node03
mkdir -pv /data/glusterfs
gluster volume create gv0 replica 3 node01:/data/glusterfs node02:/data/glusterfs node03:/data/glusterfs force
gluster volume start gv0
echo "$(hostname -s):/gv0 /mnt glusterfs defaults,_netdev 0 0" | sudo tee -a /etc/fstab
mount /mnt
mkdir /mnt/wordpress
chmod 777 /mnt/wordpress
