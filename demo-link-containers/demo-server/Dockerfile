FROM	ubuntu:latest
MAINTAINER damien.plard@neofonie.de

RUN	apt-get update &&\
	apt-get install -qy vim nodejs &&\
	apt-get clean -y && rm -rf /var/lib/apt/lists/*

ADD	material/app.js /app/app.js
ADD	material/start.sh /start.sh

ENTRYPOINT ["/start.sh"]
