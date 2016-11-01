FROM ubuntu:latest

MAINTAINER Ozzy (ozzy@ca.ibm.com)

RUN apt-get update && apt-get install -y wget

COPY ./logstash.conf /opt/logstash/bin/logstash.conf
COPY ./patterns/nginx /opt/logstash/patterns/
COPY ./patterns/haproxy /opt/logstash/patterns/
COPY ./patterns/liberty /opt/logstash/patterns/
COPY ./patterns/winston /opt/logstash/patterns/
COPY ./startup.sh /opt/startup.sh

CMD ["/opt/startup.sh"]
