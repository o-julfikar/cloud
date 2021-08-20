#!/bin/bash

read -p "Hello ${USER}, is Zulfikar your King? Type 'yes' or 'no' without quotations: " choice

if [[ $choice != 'yes' ]]; then
  exit
fi

echo Installing dependencies...
sudo apt update
sudo apt install curl gcc memcached rsync sqlite3 xfsprogs \
                     git-core libffi-dev python-setuptools \
                     liberasurecode-dev libssl-dev
sudo apt install python-coverage python-dev python-nose \
                     python-xattr python-eventlet \
                     python-greenlet python-pastedeploy \
                     python-netifaces python-pip python-dnspython \
                     python-mock

cd /opt 
sudo git clone https://github.com/openstack/python-swiftclient.git
cd /opt/python-swiftclient
sudo pip install -r requirements.txt
sudo python setup.py install

cd /opt
sudo git clone https://github.com/openstack/swift.git
cd /opt/swift
sudo python setup.py install
cd ..

sudo mkdir -p /etc/swift
cd /opt/swift/etc
sudo cp account-server.conf-sample /etc/swift/account-server.conf
sudo cp container-server.conf-sample /etc/swift/container-server.conf
sudo cp object-server.conf-sample /etc/swift/object-server.conf
sudo cp proxy-server.conf-sample /etc/swift/proxy-server.conf
sudo cp drive-audit.conf-sample /etc/swift/drive-audit.conf
sudo cp swift.conf-sample /etc/swift/swift.conf

sudo mkfs.xfs -f -L d1 /dev/sda
sudo mkfs.xfs -f -L d2 /dev/sdb
sudo mkfs.xfs -f -L d3 /dev/sdc

sudo mkdir -p /srv/node/d1
sudo mkdir -p /srv/node/d2
sudo mkdir -p /srv/node/d3

sudo useradd swift
sudo chown -R swift:swift /srv/node

sudo cp /opt/cloud/mount_devices.sh /opt/swift/bin/mount_devices.sh

sudo cp /opt/cloud/start_swift.service /etc/systemd/system/start_swift.service

sudo chmod +x /opt/swift/bin/mount_devices.sh

sudo systemctl start start_swift.service
sudo systemctl enable start_swift.service
sudo systemctl stop start_swift.service

sudo cp /opt/cloud/swift.conf /etc/swift/swift.conf

cd /etc/swift
sudo swift-ring-builder account.builder create 17 3 1
sudo swift-ring-builder container.builder create 17 3 1
sudo swift-ring-builder object.builder create 17 3 1
sudo swift-ring-builder object-1.builder create 17 3 1
sudo swift-ring-builder object-2.builder create 17 3 1

echo Adding device 1...
sudo swift-ring-builder account.builder add r1z1-127.0.0.1:6202/d1 100
sudo swift-ring-builder container.builder add r1z1-127.0.0.1:6201/d1 100
sudo swift-ring-builder object.builder add r1z1-127.0.0.1:6200/d1 100
sudo swift-ring-builder object-1.builder add r1z1-127.0.0.1:6200/d1 100
sudo swift-ring-builder object-2.builder add r1z1-127.0.0.1:6200/d1 100

echo Adding device 2...
sudo swift-ring-builder account.builder add r1z2-127.0.0.2:6202/d2 100
sudo swift-ring-builder container.builder add r1z2-127.0.0.2:6201/d2 100
sudo swift-ring-builder object.builder add r1z2-127.0.0.2:6200/d2 100
sudo swift-ring-builder object-1.builder add r1z2-127.0.0.2:6200/d2 100
sudo swift-ring-builder object-2.builder add r1z2-127.0.0.2:6200/d2 100

echo Adding device 3...
sudo swift-ring-builder account.builder add r1z3-127.0.0.3:6202/d3 100
sudo swift-ring-builder container.builder add r1z3-127.0.0.3:6201/d3 100
sudo swift-ring-builder object.builder add r1z3-127.0.0.3:6200/d3 100
sudo swift-ring-builder object-1.builder add r1z3-127.0.0.3:6200/d3 100
sudo swift-ring-builder object-2.builder add r1z3-127.0.0.3:6200/d3 100

echo Rebalancing builders...
cd /etc/swift
sudo swift-ring-builder account.builder rebalance
sudo swift-ring-builder container.builder rebalance
sudo swift-ring-builder object.builder rebalance
sudo swift-ring-builder object-1.builder rebalance
sudo swift-ring-builder object-2.builder rebalance

sudo bash -c 'echo local0.* /var/log/swift/all0.log > /etc/rsyslog.d/0-swift.conf'
cat /etc/rsyslog.d/0-swift.conf

sudo mkdir /var/log/swift

sudo chown -R syslog.adm /var/log/swift
sudo chmod -R g+w /var/log/swift

sudo service rsyslog restart

sudo pip install pyeclib
sudo pip install lxml
sudo pip install eventlet==0.25.0

usercred="user_${USER}_me = secretpassword .admin .reseller_admin"
sudo cp /opt/cloud/back-up-proxy-server.conf /opt/cloud/proxy-server.conf
sudo sed -i -e "s/usercred/$usercred/g" /opt/cloud/proxy-server.conf

sudo cp /opt/cloud/proxy-server.conf /etc/swift/proxy-server.conf

sudo swift-init proxy start
sudo swift-init account start
sudo swift-init container start
sudo swift-init object start
sudo swift-init proxy restart

sudo curl -v -H "X-Auth-User: ${USER}:me" -H 'X-Auth-Key: secretpassword' http://localhost:8080/auth/v1.0/

echo Enjoy! - Thank you Zulfikar, the KING!\
