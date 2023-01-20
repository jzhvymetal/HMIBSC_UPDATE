#! /bin/bash
### This script updates HMISBC NodeJs/NodeRed using ENTWARE packages. 
### It uninstalls the old NodeJS/NodeRed from the orginal image.  
### Then it installs from ENTWARE Nodejs, Pyton3, Tar, and Nano. 
###
### Entware is a software repository for embedded devices 
### which use the Linux kernel, primarily routers and network 
### attached storages. It has long been the practice of 
### manufacturers for these devices to "overpower" them relative 
### to the functions they are designed to perform. (It's generally
### more profitable to provide the extra computational margin 
### than bear the cost of increased support for those who more 
### heavily tax them.) Installing Entware can allow users to 
### take advantage of this extra computing power by adding 
### software to the device which permits it to perform new tasks 
### or provide other features besides those they were marketed 
### for, or simply to perform those functions better.
###
### https://github.com/Entware/Entware/wiki
###
### Browse Entware repository of 2500+ packages
###
### https://bin.entware.net/armv7sf-k3.2/Packages.html

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
########https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html
########https://mobaxterm.mobatek.net/

####################################################################
##### Everything Past this point can be copied and pasted to SSH#####
#####                    OR                                    ######
##### Execute Use this script run the following                ######
# curl -L https://raw.githubusercontent.com/jzhvymetal/HMIBSC_UPDATE/main/HMIBSC_UPDATE_ENTWARE.sh | sh -x
### Also possible to pass parameters to install nodes
### For NodeJS node use -n
### For SE Node use -s
# curl -L  https://raw.githubusercontent.com/jzhvymetal/HMIBSC_UPDATE/main/HMIBSC_UPDATE_ENTWARE.sh | sh -s -- -n node-red-contrib-modbus -s se-node-red-palette_manager -s se-node-red-modbus -s se-node-red-machine_advisor -s se-node-red-harmony_hub -s se-node-red-aveva_insight
####################################################################

###Install Entware Package Addon
wget http://bin.entware.net/aarch64-k3.10/installer/generic.sh
chmod +x generic.sh
./generic.sh
rm generic.sh

###Set /opt/sbin Path in current sh shell
[[ "$PATH" == */opt/sbin* ]] || export PATH=/opt/sbin:$PATH
##Add path to sh PATH
grep -qxF 'PATH=/opt/sbin:$PATH' /etc/profile || echo 'PATH=/opt/sbin:$PATH' >> /etc/profile

###Set /opt/bin Path in current sh shell
[[ "$PATH" == */opt/bin* ]] || export PATH=/opt/bin:$PATH
##Add path to sh PATH
grep -qxF 'PATH=/opt/bin:$PATH' /etc/profile || echo 'PATH=/opt/bin:$PATH' >> /etc/profile

###Backup old opkg so new entware opkg is used.  Do only once if script is run again
test ! -f /usr/bin/opkg-old && mv /usr/bin/opkg /usr/bin/opkg-old

###Remove All Old NodeJs/NPM/NodeRed Installs
test ! -f /bin/tar.orginal && mv /bin/tar /bin/tar.orginal
opkg-old remove nodejs --force-removal-of-dependent-packages
opkg-old remove nodejs-dev --force-removal-of-dependent-packages
opkg-old remove nodejs-npm  --force-removal-of-dependent-packages
opkg-old remove node-red --force-removal-of-dependent-packages
rm /usr/bin/node
rm /usr/bin/npm
rm /usr/bin/npx
rm /usr/bin/node-red
rm /usr/bin/node-red-pi

###Install Entware updated NodeJs/NPM/Python/Tar....Also installs nano because vi is pain to use
###Add any additional 2500+ packages which can be found https://bin.entware.net/armv7sf-k3.2/Packages.html
opkg install node
opkg install node-npm
opkg install python3
opkg install tar
opkg install nano

##stop nodered service
systemctl stop nodered

##install latest node-red
npm install --g --unsafe-perm -f --no-package-lock node-red

###install symbolic links so service does not need modification also fixes node-red palette as it has to see NPM as usr bin 
###Service File /lib/systemd/system/nodered.service it can also be modified
ln -s /opt/bin/node /usr/bin/node
ln -s /opt/bin/npm /usr/bin/npm
ln -s /opt/bin/npx /usr/bin/npx
ln -s /opt/bin/node-red-pi /usr/bin/node-red-pi
ln -s /opt/bin/node-red /usr/bin/node-red
ln -s /opt/bin/tar /bin/tar

####Install additional Nodes....Uncomment any below or add some
#npm install -g --no-audit --no-update-notifier --no-fund --save --save-prefix=~ --production --engine-strict node-red-contrib-modbus

####Install additional CLI passed nodes
### For NodeJS node use -n
### For SE Node use -s
while getopts "s:n:" opt
do
   case "$opt" in
      n )   echo "Installing NodeJS Node:" "$OPTARG" 
            npm install -g --no-audit --no-update-notifier --no-fund --save --save-prefix=~ --production --engine-strict "$OPTARG" 
            ;;
      s )   echo "Installing SE Node:" "$OPTARG" 
            npm install -g --strict-ssl false --registry https://ecostruxure-data-expert-essential.se.app:4873/ "$OPTARG" 
            ;;
   esac
done

##start nodered service
systemctl start nodered
