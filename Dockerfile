FROM ubuntu:latest

MAINTAINER Ben Smith (benjsmi@us.ibm.com)

ADD https://admin:PLACEHOLDER_ADMIN_PASSWORD@game-on.org:8443/jdk-8u66-linux-x64.gz /opt/
ADD https://admin:PLACEHOLDER_ADMIN_PASSWORD@game-on.org:8443/logstash-mtlumberjack.tgz /opt/

RUN cd /opt ; tar xzf jdk-8u66-linux-x64.gz ; tar xf logstash-mtlumberjack.tgz ; \
	rm jdk-8u66-linux-x64.gz ; rm logstash-mtlumberjack.tgz

COPY ./logstash.conf /opt/logstash/bin/logstash.conf
COPY ./patterns/nginx /opt/logstash/patterns/
COPY ./patterns/haproxy /opt/logstash/patterns/
COPY ./patterns/liberty /opt/logstash/patterns/
COPY ./patterns/winston /opt/logstash/patterns/
COPY ./startup.sh /opt/startup.sh

CMD ["/opt/startup.sh"]