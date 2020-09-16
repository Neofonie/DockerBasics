FROM httpd as original
FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8

RUN apt-get update

RUN apt-get install -y vim apache2

COPY --from=original --chown=www-data /usr/local/apache2/conf /conf

ENTRYPOINT ["apachectl","start"]

