#!/bin/bash

echo Setting up etcd...
wget https://github.com/coreos/etcd/releases/download/v2.2.2/etcd-v2.2.2-linux-amd64.tar.gz -q
tar xzf etcd-v2.2.2-linux-amd64.tar.gz etcd-v2.2.2-linux-amd64/etcdctl --strip-components=1
rm etcd-v2.2.2-linux-amd64.tar.gz
mv etcdctl /usr/local/bin/etcdctl

#setup logmet credentials.
SPACE_ID=$(etcdctl get /logmet/tenant)
LOGGING_TOKEN=$(etcdctl get /logmet/pwd)
sed -i "s/LSF_TENANT_ID/${SPACE_ID}/g" /opt/logstash/bin/logstash.conf
sed -i "s/LSF_PASSWORD/${LOGGING_TOKEN}/g" /opt/logstash/bin/logstash.conf

echo Obtaining dependencies.
export HOST=$(etcdctl get /proxy/docker-host)
mkdir -p /opt
wget --no-check-certificate https://admin:PLACEHOLDER_DOWNLOAD_PASSWORD@${HOST}:8982/jdk-8u66-linux-x64.gz -O /tmp/jdk.tgz && tar xvzf /tmp/jdk.tgz -C /opt && rm /tmp/jdk.tgz
wget --no-check-certificate https://admin:PLACEHOLDER_DOWNLOAD_PASSWORD@${HOST}:8982/logstash-mtlumberjack.tgz -O /tmp/logstash.tar && tar xvf /tmp/logstash.tar -C /opt && rm /tmp/logstash.tar

echo Starting logstash...
etcdctl get /logstash/cert > /opt/logstash-forwarder.crt
etcdctl get /logstash/key > /opt/logstash-forwarder.key
sleep 0.5
JAVA_HOME=/opt/jdk1.8.0_66 /opt/logstash/bin/logstash -f /opt/logstash/bin/logstash.conf > /dev/null
