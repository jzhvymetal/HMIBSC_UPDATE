#! /bin/bash
<<INFO_COMMENTS
This script will install on HMIBSBC NodeRed Docker Headless and use SE current settings and flow.
It will install docker if not installed.  It will install the latest version
of NodeRed and restart at boot.  This also disables the native OS NodeRed. 

More information can be found here and also the summarized below:
https://nodered.org/docs/getting-started/docker

##### Reattach to the terminal (to see logging) run:
docker attach mynodered

##### Stop and sart the container 
docker start mynodered
docker stop mynodered

##### Container Shell to run additional commands or NPM inside the docker.  To exit type exit
docker exec -it mynodered /bin/bash

####################################################################
##### Everything Past this point can be copied and pasted to SSH#####
curl -L https://raw.githubusercontent.com/jzhvymetal/HMIBSC_UPDATE/main/HMIBSC_INSTALL_NODERED_DOCKER.sh | sh -x
#####
###After Install of the Docker active NodeRed can be switch with the following: 
##### Use Native OS NodeRed
curl -L https://raw.githubusercontent.com/jzhvymetal/HMIBSC_UPDATE/main/HMIBSC_USE_NODERED.sh | sh -s -- -u OS
##### Use Docker NodeRed
curl -L https://raw.githubusercontent.com/jzhvymetal/HMIBSC_UPDATE/main/HMIBSC_USE_NODERED.sh | sh -s -- -u DOCKER
####################################################################

INFO_COMMENTS

if [[ $(which docker) && $(docker --version) ]]; then
    echo "Docker is installed"
    # command
  else
    echo "Installing Docker"
    curl -L https://raw.githubusercontent.com/jzhvymetal/HMIBSC_UPDATE/main/HMIBSC_INSTALL_DOCKER.sh | sh -x
fi

##stop OS nodered service
systemctl stop nodered
##disable OS nodred service
systemctl disable nodered

##Change rights or folder so docker can read them
chown -R 1000:1000 /home/root/.node-red
chown -R 1000:1000 /cer

##Install NodeRed Docker Headless and use SE current settings and flow
##User will have to install any nodes that where additionally OS installed nodered
docker run --hostname hmibsc --restart=always -d -p 1880:1880 -v /home/root/.node-red:/data -e FLOWS=/data/flows_$HOSTNAME.json -e NODE_OPTIONS="--max_old_space_size=256"  -v /cer:/cer --name mynodered nodered/node-red:latest 
