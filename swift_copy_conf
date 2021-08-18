#!/bin/bash

sudo mkdir -p /etc/swift
cd /opt/swift/etc
sudo cp account-server.conf-sample /etc/swift/account-server.conf
sudo cp container-server.conf-sample /etc/swift/container-server.conf
sudo cp object-server.conf-sample /etc/swift/object-server.conf
sudo cp proxy-server.conf-sample /etc/swift/proxy-server.conf
sudo cp drive-audit.conf-sample /etc/swift/drive-audit.conf
sudo cp swift.conf-sample /etc/swift/swift.conf

swift-init -h
