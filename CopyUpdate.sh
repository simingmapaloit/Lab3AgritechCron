#!/bin/bash
for var in "$@"
do
   echo  Replicating GitUpdate and Docker Image tp $var ....
   #Send Script to other nodes
    cat source_list.txt | while read line || [[ -n $line ]];
    do
     if [[ ! -z $line ]]; then
      scp  /home/pi/Lab3AgritechCron/$line  pi@$var:/home/pi/Lab3AgritechCron/
     fi
    done
    scp -r /home/pi/Lab3AgritechCron/.git pi@$var:/home/pi/Lab3AgritechCron/
    ssh -l pi $var chmod -R 755 /home/pi/Lab3AgritechCron/.git
    #Send Docker Image to other Nodes
    scp  /home/pi/bin/DockerImages/* pi@$var:/home/pi/bin/DockerImages/
    if [ $? -eq 0 ]; then
       ssh -l pi $var /home/pi/Lab3AgritechCron/LoadDockerImage.sh
    else
      echo Image transfer not completed
    fi	
    echo  Replication Completed ...    
done
chmod -R 755 /home/pi/Lab3AgritechCron/.git
echo Deleting Docker image fIles 
sudo rm -r  /home/pi/bin/DockerImages/*
echo "" > source_list.txt
echo File Deleted....
