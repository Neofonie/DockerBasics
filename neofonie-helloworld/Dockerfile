FROM alpine:latest

MAINTAINER Dennis Winter (dennis.winter@neofonie.de) | Neofonie GmbH

RUN apk update && \
    apk add apache2 bash

EXPOSE 80

RUN mkdir -p /run/apache2

COPY httpd.conf /etc/apache2/httpd.conf
COPY index.html /var/www/localhost/htdocs/
COPY entrypoint.sh /

ADD root /

# HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost/ || exit 1

ENTRYPOINT /entrypoint.sh
