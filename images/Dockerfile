FROM httpd

RUN apt-get -qq update && \
    apt-get install -yq procps wget dnsutils && \
    rm -rf /var/lib/apt/lists/*

ADD entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]

