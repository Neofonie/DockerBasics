FROM    haproxy

MAINTAINER andre.hirsinger@neofonie.de

RUN apt-get update &&\
    apt-get install -qy vim bind9-host wget &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN ln -s /start.sh /usr/local/sbin/reload &&\
    ln -s /start.sh /usr/local/sbin/reconfigure

ADD root /

RUN groupadd -g 42001 haproxy && useradd -g haproxy -u 42001 haproxy &&\
    chown -R haproxy:haproxy /run

USER haproxy

VOLUME ["/tmp"]

ENTRYPOINT ["/entrypoint"]

