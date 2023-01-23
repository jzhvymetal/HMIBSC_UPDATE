#! /bin/bash
<<INFO_COMMENTS

The script installs Docker on HMIBSC.  It does not require anything
preinstalled and can be run with or without ENTWARE.
It does not install any docker containers.  In the comments of the script
are additonal commands that can be executed to install NodeRed Docker 
and disable the native NodeRed installation.

####Fisrt Login#### 
####login: root password:IIoTB#r8
####NodeRed Password:NodeRed#0123

###NodeRed URL:https://IP:1880/
###Nodered username:NR_account

####How To Enable root login over SSH
########1. vi  /etc/ssh/sshd_config
########2. press insert key
########3. change PermitRootLogin no -> PermitRootLogin yes
########4. ESC ESC :wq 
####GET IP ADDRESS
########5. ifconfig
########6. reboot

########Download a SSH Client use IP from step 5.####################
https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html
https://mobaxterm.mobatek.net/

####################################################################
#####Everything Past this point can be copied and pasted to SSH#####
#####                   OR                                    ######
#####Execute this script by run the following                 ######
curl -L https://raw.githubusercontent.com/jzhvymetal/HMIBSC_UPDATE/main/HMIBSC_INSTALL_DOCKER.sh | sh -x
#####After Docker install to install NodeRed-Docker           ######
#####Execute this script by run the following                 ######
curl -L https://raw.githubusercontent.com/jzhvymetal/HMIBSC_UPDATE/main/HMIBSC_INSTALL_NODERED_DOCKER.sh | sh -x
#####Portainer is Docker manager.  It can be installed by 	  ######
#####running the following                                    ######
docker pull portainer/portainer-ce:latest
docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest


INFO_COMMENTS

#Download and unzip aarch64 static binaries of Docker
curl -L -o docker-20.10.9.tgz 'https://download.docker.com/linux/static/stable/aarch64/docker-20.10.9.tgz' 
tar xzvf docker-20.10.9.tgz  
mv docker/* /usr/bin/ 
rm -r docker
rm docker-20.10.9.tgz 
#Add docker usergroup and root user
groupadd docker
usermod -aG docker $USER
newgrp docker 
#download containerd service file.  Modify it as loction of binary is different
curl -L -o /lib/systemd/system/containerd.service 'https://raw.githubusercontent.com/containerd/containerd/main/containerd.service'
sed -i 's/\/usr\/local\/bin\/containerd/\/usr\/bin\/containerd/g' /lib/systemd/system/containerd.service
#download docker service files
curl -L -o  /lib/systemd/system/docker.service 'https://raw.githubusercontent.com/moby/moby/master/contrib/init/systemd/docker.service' 
curl -L -o /lib/systemd/system/docker.socket 'https://raw.githubusercontent.com/moby/moby/master/contrib/init/systemd/docker.socket'
#Docker service waits for systemd-networkd-wait-online.service default timeout is 2min......Changed to 10s...Remove 1st on double run of script
sed -i 's/\/systemd-networkd-wait-online  --timeout=10/\/systemd-networkd-wait-online/g' /lib/systemd/system/systemd-networkd-wait-online.service
sed -i 's/\/systemd-networkd-wait-online/\/systemd-networkd-wait-online --timeout=10/g' /lib/systemd/system/systemd-networkd-wait-online.service
#Reload all service files
systemctl daemon-reload
#Start alll new services
systemctl enable --now containerd
systemctl enable --now docker.socket
systemctl enable --now docker
