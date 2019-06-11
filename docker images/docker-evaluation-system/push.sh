#!/bin/bash
# DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#
# CONTAINER=${DIR##*/}

CONTAINER='valbr11/docker-evaluation-system'
CONTAINERTAG='valbr11/docker-evaluation-system:latest'

#docker login --username=yourhubusername --password=yourpassword
docker login --username= --password= && docker push ${CONTAINERTAG} && echo "Finished uploading ${CONTAINERTAG}"
