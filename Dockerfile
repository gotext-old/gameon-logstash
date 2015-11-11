FROM ubuntu:latest

MAINTAINER Ben Smith (benjsmi@us.ibm.com)

ADD http://game-on.org:8081/jdk-8u65-x64.tar.gz /opt/
ADD http://game-on.org:8081/logstash-mtlumberjack.tgz /opt/

RUN cd /opt ; tar xzf jdk-8u65-x64.tar.gz ; tar xf logstash-mtlumberjack.tgz

COPY ./logstash.conf /opt/logstash/bin/logstash.conf


CMD ["/opt/startup.sh"]