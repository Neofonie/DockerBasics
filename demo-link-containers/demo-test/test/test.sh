#!/bin/bash
set -e

sleep 5s

echo "Starting tests"
for n in {0..9}; do
	curl -s ${TARGET_PORT_8080_TCP_ADDR}:${TARGET_PORT_8080_TCP_PORT} 2>/dev/null | cut -d\  -f4 >>/result/result.txt
	echo "Test $n"
done
echo "Test done"
