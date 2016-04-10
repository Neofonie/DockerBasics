FROM	ubuntu:latest

MAINTAINER damien.plard@neofonie.de

RUN apt-get update &&\
    apt-get install -qy vim haproxy bind9-host &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

ADD material/haproxy.cfg /etc/haproxy/haproxy.cfg
ADD material/start.sh /

ENTRYPOINT ["/start.sh"]

