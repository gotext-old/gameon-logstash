#!/bin/bash

SCRIPT_PATH=`which $0`
SCRIPT_DIR=`dirname $SCRIPT_PATH`

DATA=`curl -k --silent -XPOST -d"user=${1}&passwd=${2}&organization=${3}&space=${4}" https://logmet.ng.bluemix.net/login`
LOGGING_TOKEN=`echo $DATA | grep -oP "logging_token\": \"\K[a-zA-Z0-9._-]*"`
SPACE_ID=`echo $DATA | grep -oP "space_id\": \"\K[a-zA-Z0-9._-]*"`

# mt-lsf-config.sh
sed -i "s/LSF_TENANT_ID=\".*\"/LSF_TENANT_ID=\"${SPACE_ID}\"/g" ${SCRIPT_DIR}/logstash.conf
sed -i "s/LSF_PASSWORD=\".*\"/LSF_PASSWORD=\"${LOGGING_TOKEN}\"/g" ${SCRIPT_DIR}/logstash.conf
