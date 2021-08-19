#!/bin/bash

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
python setup.py install

cd /opt
sudo git clone https://github.com/openstack/swift.git
cd /opt/swift
sudo python setup.py install
cd ..
