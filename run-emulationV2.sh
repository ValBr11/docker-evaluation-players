#!/bin/bash

#-------------Configuration-------------
#Modes
parallelMode=no # run several players in a parallel (yes/no)

#Players
numberOfPlayers=0 # number of players running in a parallel
player_1_url="http://demo.itec.aau.at/monroe/dash-players/bitmovin-tc/"
player_2_url=""
player_3_url=""

#Experiments
numberOfExperiments=2 # the number of experiments

#Network emulation settings
numberOfStages=5
shaperDurationArray=(10,20,50,100,40) #sec
shaperDelayArray=(70,70,70,70,70) #ms
shaperBWArray=(500,1000,3000,500,100) #kbits
shaperPacketLossArray=(0,0,0,0,0) # percentage

#---------------Initialization--------------

#Creating docker network
sudo docker network create test-net

#Running Docker Traffic Control in Docker
sudo docker run --rm -it --name docker-tc --network host --cap-add NET_ADMIN -v /var/run/docker.sock:/var/run/docker.sock -v /var/docker-tc:/var/docker-tc lukaszlach/docker-tc

#Running Docker Containers with a Players (number of containers = numberOfPlayers)
sudo docker run --rm  -ti --name dtc-player-experiment --net test-net -p 4444:4444 -p 5900:5900 --label "com.docker-tc.enabled=1" --label "com.docker-tc.limit=1mbps" --label "com.docker-tc.delay=70ms" -v /dev/shm:/dev/shm valbr11/docker-evaluation-system/latest 

#---------------Applying network----------- 
#--------------emulation settings----------
let "durationOfExperiment = $( echo "${shaperDurationArray[@]/,/+}" | bc)"
t=0

sudo docker exec -ti dtc-player-experiment python /home/seluser/run-scripts/python-head.py <player_1_url> <numberOfExperiments> <durationOfExperiment>

#----------------Monitoring----------------
for j in $(seq $numberOfExperiment)

        
        do for i in $(seq $durationOfExperiment)
        do echo "Status: in progress"
        echo "Experiment $j/$numberOfExperiment"
        t=$((t+1))
        min=$((t / 60))
        sec=$((t % 60))
        Time=$(($durationOfExperiment*$numberOfExperiment))
        min_exp=$(($Time/60))
        sec_exp=$(($Time%60))
        echo "Time = $min:$sec min / $min_exp:$sec_exp min" 
        echo " "
        sleep 1
        done
        i=0
done

#------------Container Shutdown--------------
echo "Status: Finished"

#delete network and contain


