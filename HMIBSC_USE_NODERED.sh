#! /bin/bash
<<INFO_COMMENTS
This script which NodeRed is active on the HMIBSC.  If using Docker,
Docker and NodeRed Container needs to be preinstalled.

####################################################################
##### Use Native OS NodeRed
curl -L https://raw.githubusercontent.com/jzhvymetal/HMIBSC_UPDATE/main/HMIBSC_USE_NODERED.sh | sh -x -- -o
##### Use Docker NodeRed
curl -L https://raw.githubusercontent.com/jzhvymetal/HMIBSC_UPDATE/main/HMIBSC_USE_NODERED.sh | sh -x -- -d
####################################################################

INFO_COMMENTS
####Install additional CLI passed nodes and opkg packages
### For NodeJS node use -n
### For SE Node use -s
### For opkg packages use -o
while getopts "d:o:" opt
do
   case "$opt" in
      o )   echo "Enabling OS NodeRed" 
            ##stop NodeRed Docker
            docker stop mynodered
            ##update docker restart
            docker update --restart=no mynodered
            ##start and enable OS nodered service
            systemctl enable --now nodered
            ;;
      d )   echo "Enabling Docker NodeRed" 
            ##stop OS nodered service
            systemctl stop nodered
            ##disable OS nodred service
            systemctl disable nodered
            ##update docker restart
            docker update --restart=always mynodered
            ##stop NodeRed Docker
            docker start mynodered   
            ;;
   esac
done
