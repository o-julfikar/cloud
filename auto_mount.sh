#!/bin/bash

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

echo Thank you! Reboot now.
