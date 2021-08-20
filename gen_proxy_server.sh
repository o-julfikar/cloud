#!/bin/bash
usercred="user_${USER}_me = secretpassword .admin .reseller_admin"
sudo cp back-up-proxy-server.conf proxy-server.conf
sudo sed -i -e "s/usercred/$usercred/g" proxy-server.conf

