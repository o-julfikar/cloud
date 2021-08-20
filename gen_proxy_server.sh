#!/bin/bash
usercred="user_${USER}_me = secretpassword .admin .reseller_admin"
sudo sed -i -e 's/usercred/$usercred/g' /tmp/file.txt

