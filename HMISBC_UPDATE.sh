###Update Tar required for nodeJS package manager
mv /bin/tar /bin/tar.orginal
curl -L -o /bin/tar 'https://github.com/polaco1782/linux-static-binaries/raw/master/armv8-aarch64/tar'  
chmod 777 /bin/tar

###Back up old NodeJs 
mkdir -p /home/node_backup/usr/bin 
mv /usr/bin/*node* /home/node_backup/usr/bin 
mv /usr/bin/npm /home/node_backup/usr/bin | mv /usr/bin/npx /home/node_backup/usr/bin
mkdir -p /home/node_backup/usr/lib
mv /usr/lib/node_modules /home/node_backup/usr/lib

###Install package manager for nodeJS with verison lastest 16
curl -L https://bit.ly/n-install | bash -s -- -y 16.9.1
###Set Path in current sh shell
PATH=$PATH:/home/root/n/bin
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
##start nodered service
systemctl start nodered

