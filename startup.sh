#!/bin/bash

echo Setting up etcd...
wget https://github.com/coreos/etcd/releases/download/v2.2.2/etcd-v2.2.2-linux-amd64.tar.gz -q
tar xzf etcd-v2.2.2-linux-amd64.tar.gz etcd-v2.2.2-linux-amd64/etcdctl --strip-components=1
rm etcd-v2.2.2-linux-amd64.tar.gz
mv etcdctl /usr/local/bin/etcdctl

echo Obtaining dependencies.
export HOST=$(etcdctl get /proxy/docker-host)
mkdir -p /opt
wget --no-check-certificate https://admin:PLACEHOLDER_DOWNLOAD_PASSWORD@${HOST}:8982/jdk-8u66-linux-x64.gz -O /tmp/jdk.gz && tar xvzf /tmp/jdk.gz -C /opt && rm /tmp/jdk.gz
wget --no-check-certificate https://admin:PLACEHOLDER_DOWNLOAD_PASSWORD@${HOST}:8982/logstash-mtlumberjack.tgz -O /tmp/logstash.gz && tar xvzf /tmp/logstash.gz -C /opt && rm /tmp/logstash.gz

echo Starting logstash...
etcdctl get /logstash/cert > /opt/logstash-forwarder.crt
etcdctl get /logstash/key > /opt/logstash-forwarder.key
sleep 0.5
JAVA_HOME=/opt/jdk1.8.0_66 /opt/logstash/bin/logstash -f /opt/logstash/bin/logstash.conf > /dev/null
