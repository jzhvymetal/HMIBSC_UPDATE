#! /bin/bash

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
#####Everything Past this point can be copied and pasted to SSH#####
#####                   OR                                    ######
#####Execute Use this script run the following                ######
#curl -L https://raw.githubusercontent.com/jzhvymetal/HMIBSC_UPDATE/main/HMIBSC_UPDATE.sh | sh -x
####################################################################

###Update Tar required for nodeJS package manager
mv /bin/tar /bin/tar.orginal
curl -L -o /bin/tar 'https://github.com/jzhvymetal/HMIBSC_UPDATE/blob/main/tar?raw=true'  
chmod 777 /bin/tar

###Install Missing argparse.py
curl -L -o argparse-1.4.0.tar.gz 'https://files.pythonhosted.org/packages/18/dd/e617cfc3f6210ae183374cd9f6a26b20514bbb5a792af97949c5aacddf0f/argparse-1.4.0.tar.gz'
tar -xvf argparse-1.4.0.tar.gz argparse-1.4.0/argparse.py --strip-components 1 
mv argparse.py /usr/lib/python2.7
rm argparse-1.4.0.tar.gz

###Back up old NodeJs 
mkdir -p /home/node_backup/usr/bin 
mv /usr/bin/*node* /home/node_backup/usr/bin 
mv /usr/bin/npm /home/node_backup/usr/bin | mv /usr/bin/npx /home/node_backup/usr/bin
mkdir -p /home/node_backup/usr/lib
mv /usr/lib/node_modules /home/node_backup/usr/lib

###Install package manager for nodeJS with verison lastest 16
curl -L https://bit.ly/n-install | bash -s -- -y 16.9.1
###Set Path in current sh shell
[[ "$PATH" == *:/home/root/n/bin* ]] || PATH=$PATH:/home/root/n/bin
##Add path to sh PATH
grep -qxF 'PATH=$PATH:/home/root/n/bin' /etc/profile || echo 'PATH=$PATH:/home/root/n/bin' >> /etc/profile

###Install node-red
##Install node-gyp required for node-red install
npm install --g --unsafe-perm -f --no-package-lock node-gyp
##stop nodered service
systemctl stop nodered
##install latest node-red
npm install --g --unsafe-perm -f --no-package-lock node-red
##install symbolic links so service does not need modification
ln -s /home/root/n/bin/* /usr/bin

##Install Other NodeRed Nodes
#Uncomment to install other nodes
#npm install --no-audit --no-update-notifier --no-fund --save --save-prefix=~ --production --engine-strict node-red-contrib-modbus

#npm install se-node-red-palette_manager --registry https://ecostruxure-data-expert-essential.se.app:4873/ --strict-ssl false
#npm install se-node-red-modbus --registry https://ecostruxure-data-expert-essential.se.app:4873/ --strict-ssl false
#npm install se-node-red-machine_advisor --registry https://ecostruxure-data-expert-essential.se.app:4873/ --strict-ssl false
#npm install se-node-red-harmony_hub --registry https://ecostruxure-data-expert-essential.se.app:4873/ --strict-ssl false
#npm install se-node-red-aveva_insight --registry https://ecostruxure-data-expert-essential.se.app:4873/ --strict-ssl false

##start nodered service
systemctl start nodered
