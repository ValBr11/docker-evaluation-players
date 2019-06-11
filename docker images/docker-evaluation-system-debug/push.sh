#!/bin/bash
# DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#
# CONTAINER=${DIR##*/}

CONTAINER='valbr11/docker-evaluation-system-debug'
CONTAINERTAG='valbr11/docker-evaluation-system-debug:latest'

#docker login --username=yourhubusername --password=yourpassword
docker login --username= --password= && docker push ${CONTAINERTAG} && echo "Finished uploading ${CONTAINERTAG}"
