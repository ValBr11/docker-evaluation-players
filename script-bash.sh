#!/bin/bash

#-------------Configuration-------------
#Modes
parallelMode=no # run several players in a parallel (yes/no)
debug=yes        # run player in debugmode, debug = grafic interface in VNC (yes/no)

#Players
numberOfPlayers=0 # number of players running in a parallel
player_1_url="http://demo.itec.aau.at/monroe/dash-players/bitmovin-tc/"
player_2_url=""
player_3_url=""

#Experiments
numberOfExperiments=2 # the number of experiments

#Network emulation settings
numberOfStages=5
shaperDurationArray=(15 15 20 10 15) #sec
shaperDelayArray=(70 70 70 70 70) #ms
shaperBWArray=(500 1000 3000 500 100) #kbits
shaperPacketLossArray=(0 0 0 0 0) # percentage

#---------------Initialization--------------

#Creating docker network
sudo docker network create test-net

#Running Docker Traffic Control in Docker
sudo docker run -d --name docker-tc --network host --cap-add NET_ADMIN -v /var/run/docker.sock:/var/run/docker.sock -v /var/docker-tc:/var/docker-tc lukaszlach/docker-tc

#Running Docker Containers with a Players (number of containers = numberOfPlayers)

if [ $debug = "yes" ]
then sudo docker run --rm  -d --name dtc-player-experiment --net test-net -p 4444:4444 -p 5900:5900 --label "com.docker-tc.enabled=1" --label "com.docker-tc.limit=1mbps" --label "com.docker-tc.delay=70ms" -v /dev/shm:/dev/shm valbr11/docker-evaluation-system-debug

elif [ $debug = "no" ]
then sudo docker run --rm  -d --name dtc-player-experiment --net test-net -p 4444:4444 -p 5900:5900 --label "com.docker-tc.enabled=1" --label "com.docker-tc.limit=1mbps" --label "com.docker-tc.delay=70ms" -v /dev/shm:/dev/shm valbr11/docker-evaluation-system

fi

#---------------Applying network----------- 
#--------------emulation settings----------

for ((v = 0 ; v < numberOfStages ; v++ ));          #SUM
        do r=$( echo ${shaperDurationArray[$v]})
        let " durationOfExperiment= durationOfExperiment + r"
        done


sudo docker exec -d dtc-player-experiment python /home/seluser/run-scripts/python-head.py $player_1_url $numberOfExperiments $durationOfExperiment
echo "rate = ${shaperBWArray[0]}kbit"
        sudo curl -d'rate=${shaperBWArray[0]}kbit' localhost:4080/dtc-player-experiment

#----------------Monitoring------------------

for j in $(seq $numberOfExperiments)
        do m=0
        k=0
        for i in $(seq $durationOfExperiment)
                do let "time_seg = $( echo ${shaperDurationArray[$k]})"
                let "time_t = time_seg + m "
                if (($i == $time_t))
                        then let "m = i"
			k=$((k+1))
                        echo "rate = ${shaperBWArray[$k]}kbit"
			sudo curl -d'rate=${shaperBWArray[$k]}kbit' localhost:4080/dtc-player-experiment
                     
                fi
                echo "Status: in progress"
                echo "Experiment $j/$numberOfExperiments"
                t=$((t+1))
		Time=$(($durationOfExperiment*$numberOfExperiments))
		time_exp=$((Time - t))
                min=$((time_exp / 60))
                sec=$((time_exp % 60))
                min_exp=$(($Time/60))
                sec_exp=$(($Time%60))
                echo "Full time = $min_exp:$sec_exp min"
                echo "Time to end = $min:$sec min"
		echo " "
                sleep 1
                i=$((i+1))
        done
        i=0
done


#------------Container Shutdown--------------
echo "Status: Finished"
sleep 2 
sudo docker rm -f dtc-player-experiment

#delete network and contain
sudo docker rm -f docker-tc
