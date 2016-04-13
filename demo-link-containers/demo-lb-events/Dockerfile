FROM	haproxy

MAINTAINER andre.hirsinger@neofonie.de

RUN apt-get update &&\
    apt-get install -qy vim bind9-host

RUN apt-get purge docker.io* &&\
    apt-get update && apt-get install -qy apt-transport-https ca-certificates &&\
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D 

RUN echo "deb https://apt.dockerproject.org/repo debian-jessie main" >> /etc/apt/sources.list.d/docker.list &&\
    apt-get update && apt-get install -qy docker-engine

ADD material/haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
ADD material/start.sh /
RUN ln -s /start.sh /usr/local/sbin/reload

ENTRYPOINT ["/start.sh"]

