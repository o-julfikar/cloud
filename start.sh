#!/bin/bash

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
