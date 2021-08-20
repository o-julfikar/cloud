#!/bin/bash
sudo touch proxy-server.conf
sudo chmod 777 proxy-server.conf
sudo bash -c "echo '' > proxy-server.conf"
i=0
input="/opt/cloud/back-up-proxy-server.conf"
while IFS= read -r line
do
  "$line" >> proxy-server.conf
  if [ $i -eq 406 ]; then;
    echo "user_${USER}_me = secretpassword .admin .reseller_admin"
  fi
  i=$(( $i + 1))
done
