FROM debian

RUN	apt-get update &&\
	apt-get install -qy vim curl &&\
	apt-get clean -y && rm -rf /var/lib/apt/lists/*

CMD ["/test/test.sh"]

