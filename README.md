# docker-evaluation-players

Evaluation of the Performance of Adaptive HTTP Streaming Players System in Docker.


## Client Side

### Building the Docker Image

Run `sudo ./bash build.sh` if you want to create the docker image locally

### Pushing the Docker Image

Run `sudo ./bash push.sh` if you want to push the docker image on Docker Hub

### Readily Compiled Docker Image

Or you can use this Docker image : https://cloud.docker.com/u/valbr11/repository/docker/valbr11/docker-evaluation-system 

Pull by running `docker pull valbr11/docker-evaluation-system`.

A debug mode exist, if you use it you can check inside the container to see your test running on the Chrome browser. Docker image : https://cloud.docker.com/u/valbr11/repository/docker/valbr11/docker-evaluation-system-debug

Pull by running `docker pull valbr11/docker-evaluation-system-debug`.


## Configuring and Running an Experiment

Put your configuration in the bash script : 
 - debug mode (yes/no)
 - url of the player
 - number of experiments
 - all the network emulation settings (number of stage, duration, delay, bandwidth, packet lost)  


# Run a test

An experiment can be started with the following command:
`sudo bash ./bash-script.sh`


## Monitoring

Every second, you can see the status of you experiment in the terminal with the time to end the experiment.  


## Result

The result of the experiment can be find on Bitmovin Analytics if you use the Bitmovin player. 


## Warning

This project is not finished, for the moment you can run only on player (no parallel mode) and only the bandwidth can be changed. 

# Components 

## Docker Traffic Control (Docker-tc) 
https://github.com/lukaszlach/docker-tc

## Selenium Docker 
https://github.com/SeleniumHQ/docker-selenium

## Bitmovin Player and Analitycs 
https://bitmovin.com/

## Software Certificates and Keys

Bitmovin Player and Bitmovin Analytics keys can be acquired free of charge for a trial period, see [Bitmovin signup](https://bitmovin.com/dashboard/signup).


