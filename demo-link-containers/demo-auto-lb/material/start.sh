#!/bin/bash

haproxy_template=/etc/haproxy/haproxy.cfg
haproxy_cfg=${haproxy_template}.dyn

cp $haproxy_template $haproxy_cfg

sleep 3

for n in `seq 1 9`; do
        host web_$n | grep "has address" >/dev/null 2>&1
        if [ "$?" -eq "0" ]; then
                echo server web_$n web_$n:1337 check >> $haproxy_cfg
        fi
done

exec haproxy -f $haproxy_cfg
