#!/bin/bash

curl -s --unix-socket /var/run/docker.sock "http:/v1.30/containers/json" | jq -r '.[] | { Names: .Names, Id: .Id }'
