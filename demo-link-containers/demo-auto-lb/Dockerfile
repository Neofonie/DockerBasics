FROM	haproxy

MAINTAINER andre.hirsinger@neofonie.de

RUN apt-get update &&\
    apt-get install -qy vim bind9-host &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

ADD material/haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
ADD material/start.sh /
RUN ln -s /start.sh /usr/local/sbin/reload

ENTRYPOINT ["/start.sh"]

