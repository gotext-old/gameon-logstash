#!/bin/bash 
echo Starting logstash...
echo -e $LOGSTASH_CERT > /opt/logstash-forwarder.crt
echo -e $LOGSTASH_KEY > /opt/logstash-forwarder.key
sleep 0.5
JAVA_HOME=/opt/jdk1.8.0_65 /opt/logstash/bin/logstash -f /opt/logstash/bin/logstash.conf
