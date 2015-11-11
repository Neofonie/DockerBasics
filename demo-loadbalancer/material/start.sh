#!/bin/bash

echo "/etc/hosts:"
cat /etc/hosts

exec haproxy -f /etc/haproxy/haproxy.cfg

