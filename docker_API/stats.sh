#!/bin/bash

id=$1

curl -s --unix-socket /var/run/docker.sock "http:/v1.30/containers/$id/stats?stream=false" | jq 
