#!/bin/bash

#
# This script is only intended to run in the IBM DevOps Services Pipeline Environment.
#

echo Informing slack...
curl -X 'POST' --silent --data-binary '{"text":"A new build for the Logstash server has started."}' $WEBHOOK > /dev/null
echo Setting up Docker...
mkdir dockercfg ; cd dockercfg
echo -e $KEY > key.pem
echo -e $CA_CERT > ca.pem
echo -e $CERT > cert.pem
cd ..
wget http://security.ubuntu.com/ubuntu/pool/main/a/apparmor/libapparmor1_2.8.95~2430-0ubuntu5.3_amd64.deb -O libapparmor.deb
sudo dpkg -i libapparmor.deb
rm libapparmor.deb
wget https://get.docker.com/builds/Linux/x86_64/docker-1.9.1 --quiet -O docker
chmod +x docker


echo Setting configuration to match with your Bluemix Org and Space information for Logmet...
./client-config.sh $BLUEMIX_USER $BLUEMIX_PASSWORD $BLUEMIX_ORG $BLUEMIX_SPACE

echo Building the docker image...
sed -i s/PLACEHOLDER_DOWNLOAD_PASSWORD/$DOWNLOAD_PASSWORD/g ./Dockerfile
./docker build -t gameon-logstash .
./docker stop -t 0 gameon-logstash
./docker rm gameon-logstash
./docker run -d -p 10.33.40.21:5043:5043 -p 10.33.40.21:514:514/udp -e ETCDCTL_ENDPOINT="http://etcd:4001" --link=etcd --name gameon-logstash gameon-logstash

rm -rf dockercfg