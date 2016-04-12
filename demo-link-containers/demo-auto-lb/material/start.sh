#!/bin/bash

haproxy_template=/usr/local/etc/haproxy/haproxy.cfg
haproxy_cfg=${haproxy_template}.dyn
backend=web

test -n "$COMPOSE_PROJECT" && backend=${COMPOSE_PROJECT}_$backend

cp $haproxy_template $haproxy_cfg

backends=0
for n in `seq 1 10`; do
        backend_n=${backend}_$n
        host -t A -W 1 $backend_n | grep "has address" >/dev/null 2>&1
        if [ "$?" -eq "0" ]; then
            echo server $backend_n $backend_n:1337 check >> $haproxy_cfg
            let backends=$backends+1
        else
            test $backends -gt 0 && break
        fi
done

diff -d $haproxy_template $haproxy_cfg && { echo no backend found.; exit 1; }

pid=`pidof haproxy-systemd-wrapper`
if [ "$?" -eq "0" ]; then
    kill -1 $pid
else
    exec /usr/local/sbin/haproxy-systemd-wrapper -p /run/haproxy.pid -f $haproxy_cfg
fi
