#!/bin/bash 
echo Setting up etcd...
wget https://github.com/coreos/etcd/releases/download/v2.2.2/etcd-v2.2.2-linux-amd64.tar.gz -q
tar xzf etcd-v2.2.2-linux-amd64.tar.gz etcd-v2.2.2-linux-amd64/etcdctl --strip-components=1
rm etcd-v2.2.2-linux-amd64.tar.gz
mv etcdctl /usr/local/bin/etcdctl

echo Starting logstash...
etcdctl get /logstash/cert > /opt/logstash-forwarder.crt
etcdctl get /logstash/key > /opt/logstash-forwarder.key
sleep 0.5
JAVA_HOME=/opt/jdk1.8.0_66 /opt/logstash/bin/logstash -f /opt/logstash/bin/logstash.conf
