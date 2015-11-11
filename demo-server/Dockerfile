FROM	ubuntu:latest
MAINTAINER damien.plard@neofonie.de

RUN	apt-get update &&\
	apt-get install -qy vim nodejs &&\
	apt-get clean -y && rm -rf /var/lib/apt/lists/*

COPY	material/app.js /app/app.js

CMD	/usr/bin/nodejs /app/app.js
