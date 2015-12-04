#!/bin/bash

#
# This script is only intended to run in the IBM DevOps Services Pipeline Environment.
#

echo Informing slack...
curl -X 'POST' --silent --data-binary '{"text":"A new build for the Logstash server has started."}' $WEBHOOK > /dev/null
mkdir dockercfg ; cd dockercfg
echo Downloading Docker requirements..
wget --user=admin --password=$ADMIN_PASSWORD https://$BUILD_DOCKER_HOST:8443/dockerneeds.tar -q
echo Setting up Docker...
wget http://security.ubuntu.com/ubuntu/pool/main/a/apparmor/libapparmor1_2.8.95~2430-0ubuntu5.3_amd64.deb -O libapparmor.deb
sudo dpkg -i libapparmor.deb
tar xzf dockerneeds.tar ; mv docker ../ ; cd .. ; chmod +x docker ; \
	export DOCKER_HOST="tcp://$BUILD_DOCKER_HOST:2376" DOCKER_TLS_VERIFY=1 DOCKER_CONFIG=./dockercfg

echo Setting configuration to match with your Bluemix Org and Space information for Logmet...
./client-config.sh $BLUEMIX_USER $BLUEMIX_PASSWORD $BLUEMIX_ORG $BLUEMIX_SPACE

echo Building the docker image...
sed -i s/ADMIN_PASSWORD/$ADMIN_PASSWORD/g ./Dockerfile
./docker build -t gameon-logstash .
./docker stop -t 0 gameon-logstash
./docker rm gameon-logstash
./docker run -d -p 10.33.40.21:5043:5043 -p 10.33.40.21:514:514/udp -e LOGSTASH_CERT="$LOGSTASH_CERT" -e LOGSTASH_KEY="$LOGSTASH_KEY" --name gameon-logstash gameon-logstash
