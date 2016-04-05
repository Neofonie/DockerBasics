#!/bin/bash

#function shutdown() {
#    echo "Shutting down"
#    exit 0
#}

#trap shutdown SIGINT SIGTERM

httpd -D FOREGROUND &
pid="$!"
trap "echo 'Stopping PID $pid'; kill -SIGTERM $pid" SIGINT SIGTERM

# A signal emitted while waiting will make the wait command return code > 128
# Let's wrap it in a loop that doesn't end before the process is indeed stopped
while kill -0 $pid > /dev/null 2>&1; do
    wait
done
