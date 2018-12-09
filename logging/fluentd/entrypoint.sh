#!/bin/sh

function stoptheworld() {
    echo "shutdown"
    echo "kill all pids != 1"
    kill $(ps -eo pid | egrep -v "[[:space:]]*1$") >/dev/null 2>&1
    echo "exiting"
    exit 0
}

get_node_info() {
  node_id=$(curl -s --unix-socket /var/run/docker.sock "http:/v1.24/info" | jq -r ".Swarm.NodeID")
  node_hostname=$(curl -s --unix-socket /var/run/docker.sock "http:/v1.24/info" | jq -r ".Name")
}

update_config() {
  file=$1
  sed -i'' -e "s/## NODE ID ##/$node_id/g" $file
  sed -i'' -e "s/## NODE HOSTNAME ##/$node_hostname/g" $file
}
  
trap 'stoptheworld' EXIT

get_node_info
update_config /fluentd/etc/$FLUENTD_CONF

fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT &

wait $!

