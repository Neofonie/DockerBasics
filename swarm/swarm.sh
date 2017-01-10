#!/bin/bash

export DIGITALOCEAN_SIZE=1gb
export DIGITALOCEAN_ACCESS_TOKEN=1dd58ba58c1beebccf5a8e24c1a83b3abeb09b2b074e01f6114fb0bb394e0bb6
export DIGITALOCEAN_IMAGE=debian-8-x64

ssh_opt=" -o PasswordAuthentication=no -o BatchMode=yes -o StrictHostKeyChecking=no -o CheckHostIP=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=10 -o LogLevel=quiet "

nodes="swarm01 swarm02 swarm03"
#nodes="node01"

create() {
for node in $nodes; do
    docker-machine create --driver digitalocean --engine-opt cluster-store=consul://127.0.0.1:8500 --engine-opt cluster-advertise=eth0:2376 $node
done
}

consul_setup() {
    consul_join_ips=$(docker-machine ip $nodes) 
    retry_opts=$(echo $consul_join_ips | sed -e 's#^\| # -retry-join=#g')
    for node in $nodes; do
        eval $(docker-machine env $node)
        node_ip=$(docker-machine ip $node)
        cmd="docker run --net=host -d --name=host-consul --restart=always consul agent -server -ui -bootstrap-expect=3 $retry_opts -bind=$node_ip -client=0.0.0.0  -advertise=$node_ip"
        echo $cmd
        $cmd
    done
}

swarm_setup() {
for node in $nodes; do
    eval $(docker-machine env $node)
    node_ip=$(docker-machine ip $node)
    cmd="docker run --net=host -d -v /.swarm -v /etc/docker:/etc/docker --restart=always --name=swarm-agent-master swarm manage --tlsverify --tlscacert=/etc/docker/ca.pem --tlscert=/etc/docker/server.pem --tlskey=/etc/docker/server-key.pem -H tcp://0.0.0.0:3376 --strategy spread --replication --advertise $node_ip:3376 consul://$node_ip:8500"
    echo $cmd
    $cmd
    cmd="docker run --net=host -d -v /.swarm --name=swarm-agent --restart=always swarm join --advertise $node_ip:2376 consul://$node_ip:8500"
    echo $cmd
    $cmd
done
}

iptables_init() {
node_ips=$(docker-machine ip $nodes)
node_ips=$(echo $node_ips | sed -e 's/ /,/g')
node_ips=${node_ips},91.213.91.28,91.213.91.29,127.0.0.1,172.17.0.0/16,172.18.0.0/16,10.0.0.0/8
for node in $nodes; do
    cat << EOF | docker-machine ssh $node "cat - > /root/iptables.sh"
#!/bin/bash
    iptables -X
    iptables -F
    iptables -N TCP
    iptables -N UDP 
    iptables -P INPUT       DROP
    iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT
    iptables -A INPUT -p udp -m conntrack --ctstate NEW -j UDP
    iptables -A INPUT -p tcp --syn -m conntrack --ctstate NEW -j TCP
    iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable
    iptables -A INPUT -p tcp -j REJECT --reject-with tcp-rst
    iptables -A INPUT -j REJECT --reject-with icmp-proto-unreachable
    iptables -A TCP -p tcp --dport 22 -j ACCEPT
    iptables -A TCP -p tcp --dport 2376 -j ACCEPT
    iptables -A TCP -p tcp --dport 3376 -j ACCEPT
    iptables -A TCP -p tcp -s $node_ips -j ACCEPT
    iptables -A UDP -s $node_ips -j ACCEPT
EOF
    docker-machine ssh $node "bash /root/iptables.sh &"
done
}

add_keys() {
ssh-add -L || return
for node in $nodes; do
    node_ip=$(docker-machine ip $node)
    echo "workshop:ichsinge1234:1042:1042:,,,:/home/workshop:/bin/bash" | docker-machine ssh $node "newusers"
    docker-machine ssh $node "adduser workshop sudo; adduser workshop docker"
    docker-machine ssh $node 'su workshop -c "docker login -u neofonie -p uesk98 registry.neofonie.de"'
    docker-machine ssh $node 'curl -L "https://github.com/docker/compose/releases/download/1.8.1/docker-compose-$(uname -s)-$(uname -m)" > /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose'
    ssh-add -L | docker-machine ssh $node "cat - >> /root/.ssh/authorized_keys"
    ssh $ssh_opt root@$node_ip "mkdir -p /root/docker-magic/infrastructure/machine/machines/" && \
    rsync -avP -e "ssh $ssh_opt" ~/.docker/machine/machines/$node root@$node_ip:/root/docker-magic/infrastructure/machine/machines/
    ssh $ssh_opt root@$node_ip "chown -R 2222:2222 /root/docker-magic"
done
}

cleanup_docker() {
for node in $nodes; do
    eval $(docker-machine env $node)
    docker rm -f -v $(docker ps -qa)
done
}

case $1 in
rm)
    cleanup_docker
    docker-machine rm $nodes
;;
init)
    docker-machine ip $nodes || create
    consul_setup
    swarm_setup
    iptables_init
    add_keys
;;
create)
    docker-machine ip $nodes || create
;; 
iptables)
    iptables_init
;;
addkeys)
    add_keys
;;
esac
