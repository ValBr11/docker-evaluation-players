#!/bin/bash
# DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#
# CONTAINER=${DIR##*/}
# DOCKERFILE=${CONTAINER}.docker

DOCKERFILE='docker-tc-players.docker'
CONTAINER='valbr11/docker-evaluation-system-debug'

#NO_CACHE=--no-cache

#docker build -t $DOCKER_ACC/$DOCKER_REPO:$IMG_TAG .
#Build your image by executing the docker build command. 
#$DOCKER_ACC is the name of your account 
#$DOCKER_REPO is your image name and 
#$IMG_TAG is your tag

# docker pull monroe/base
#docker selenium/standalone-chrome-debug:3.141.0-actinium

docker build --network=host $NO_CACHE --rm=true --file ${DOCKERFILE} --tag ${CONTAINER} . && echo "Finished building ${CONTAINER}"
