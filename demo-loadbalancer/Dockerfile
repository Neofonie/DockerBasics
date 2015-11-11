FROM	alpine
MAINTAINER damien.plard@neofonie.de

RUN	apk update &&\
	apk add vim bash haproxy &&\
	rm /var/cache/apk/*

COPY material/haproxy.cfg /etc/haproxy/haproxy.cfg
COPY material/start.sh /

ENTRYPOINT ["/start.sh"]

