#!/bin/bash

haproxy_template=/usr/local/etc/haproxy/haproxy.cfg
haproxy_cfg=${haproxy_template}.dyn
backend=web

test -n "$COMPOSE_PROJECT" && backend=${COMPOSE_PROJECT}_$backend

cp $haproxy_template $haproxy_cfg

for n in `seq 1 19`; do
        backend_n=${backend}_$n
        host $backend_n | grep "has address" >/dev/null 2>&1 && echo server $backend_n $backend_n:1337 check >> $haproxy_cfg
done

diff -d $haproxy_template $haproxy_cfg && { echo no backend found.; exit 1; }

exec /usr/local/sbin/haproxy-systemd-wrapper -p /run/haproxy.pid -f $haproxy_cfg
