#!/bin/bash

cd /etc/swift
sudo swift-ring-builder account.builder create 17 3 1
sudo swift-ring-builder container.builder create 17 3 1
sudo swift-ring-builder object.builder create 17 3 1
sudo swift-ring-builder object-1.builder create 17 3 1
sudo swift-ring-builder object-2.builder create 17 3 1


echo Adding device 1...
sudo swift-ring-builder account.builder add r1z1-127.0.0.1:6002/d1 100
sudo swift-ring-builder container.builder add r1z1-127.0.0.1:6001/d1 100
sudo swift-ring-builder object.builder add r1z1-127.0.0.1:6000/d1 100
sudo swift-ring-builder object-1.builder add r1z1-127.0.0.1:6000/d1 100
sudo swift-ring-builder object-2.builder add r1z1-127.0.0.1:6000/d1 100

echo Adding device 1...
sudo swift-ring-builder account.builder add r1z2-127.0.0.2:6012/d2 100
sudo swift-ring-builder container.builder add r1z2-127.0.0.2:6011/d2 100
sudo swift-ring-builder object.builder add r1z2-127.0.0.2:6010/d2 100
sudo swift-ring-builder object-1.builder add r1z2-127.0.0.2:6010/d2 100
sudo swift-ring-builder object-2.builder add r1z2-127.0.0.2:6010/d2 100

echo Adding device 1...
sudo swift-ring-builder account.builder add r1z3-127.0.0.3:6022/d3 100
sudo swift-ring-builder container.builder add r1z3-127.0.0.3:6021/d3 100
sudo swift-ring-builder object.builder add r1z3-127.0.0.3:6020/d3 100
sudo swift-ring-builder object-1.builder add r1z3-127.0.0.3:6020/d3 100
sudo swift-ring-builder object-2.builder add r1z3-127.0.0.3:6020/d3 100

cd /etc/swift
sudo swift-ring-builder account.builder rebalance
sudo swift-ring-builder container.builder rebalance
sudo swift-ring-builder object.builder rebalance
sudo swift-ring-builder object-1.builder rebalance
sudo swift-ring-builder object-2.builder rebalance


sudo bash -c 'echo local0.* /var/log/swift/all0.log > /etc/rsyslog.d/0-swift.conf'
sudo bash -c 'echo local1.* /var/log/swift/all1.log > /etc/rsyslog.d/1-swift.conf'
sudo bash -c 'echo local2.* /var/log/swift/all2.log > /etc/rsyslog.d/2-swift.conf'

cat /etc/rsyslog.d/0-swift.conf /etc/rsyslog.d/1-swift.conf /etc/rsyslog.d/2-swift.conf

sudo mkdir /var/log/swift

sudo chown -R syslog.adm /var/log/swift
sudo chmod -R g+w /var/log/swift

sudo service rsyslog restart

echo Done! Proceed to Proxy Configuration...
