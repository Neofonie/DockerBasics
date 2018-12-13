#!/bin/bash

id=$1

wget  --method=POST \
      --header="Content-Type:application/json" \
      --no-check-certificate \
      --certificate=$DOCKER_CERT_PATH/cert.pem \
      --private-key=$DOCKER_CERT_PATH/key.pem \
      --certificate=/cert.pem \
      https://192.168.99.100:2376/containers/$id/stats
