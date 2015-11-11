FROM ubuntu:latest

MAINTAINER Ben Smith (benjsmi@us.ibm.com)

ADD http://game-on.org:8081/jdk-8u65-x64.tar.gz /opt/
ADD http://game-on.org:8081/logstash-mtlumberjack.tgz /opt/
ADD http://game-on.org:8081/logstashneeds.tar /opt/logstashneeds.tar

RUN cd /opt ; tar xzf jdk-8u65-x64.tar.gz ; tar xf logstash-mtlumberjack.tgz ; \
	tar xf logstashneeds.tar ; rm jdk-8u65-x64.tar.gz ; rm logstash-mtlumberjack.tgz ; \
	rm logstashneeds.tar

COPY ./logstash.conf /opt/logstash/bin/logstash.conf
COPY ./patterns/nginx /opt/logstash/patterns/
COPY ./patterns/haproxy /opt/logstash/patterns/
COPY ./startup.sh /opt/startup.sh

CMD ["/opt/startup.sh"]