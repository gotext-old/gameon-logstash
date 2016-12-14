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

echo Fetching docker image...
curl https://get.docker.com/builds/Linux/x86_64/docker-1.12.1.tgz | tar xz

echo Building the docker image...
sed -i s/PLACEHOLDER_DOWNLOAD_PASSWORD/$DOWNLOAD_PASSWORD/g ./startup.sh
sed -i s/PLACEHOLDER_DOWNLOAD_PASSWORD/$DOWNLOAD_PASSWORD/g ./Dockerfile
./docker/docker build -t gameon-logstash .
if [ $? != 0 ]
  then
    echo Docker Build failed.
    curl -X 'POST' --silent --data-binary '{"text":"Docker Build for the logstash service has failed."}' $WEBHOOK > /dev/null
    exit -2
  else
    echo Attempting to remove old containers.
    ./docker/docker stop -t 0 gameon-logstash || true
    ./docker/docker rm gameon-logstash || true
    echo Starting new container.
    ./docker/docker run -d -p $SL_HOST_IP:5043:5043 -p $SL_HOST_IP:514:514/udp -e ETCDCTL_ENDPOINT="http://etcd:4001" --link=etcd --name gameon-logstash gameon-logstash
    if [ $? != 0 ]
    then
      echo Docker Run failed.
      curl -X 'POST' --silent --data-binary '{"text":"Docker Run for the logstash service has failed."}' $WEBHOOK > /dev/null
      exit -3
    else
      cd ..
      rm -rf dockercfg
    fi
  fi
