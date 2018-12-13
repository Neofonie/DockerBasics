FROM httpd

RUN apt-get -qq update && \
    apt-get install -yq procps wget dnsutils && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 8080

ADD entrypoint.sh /

ADD file /data/

VOLUME ["/data"]

ENTRYPOINT [ "/entrypoint.sh" ]

