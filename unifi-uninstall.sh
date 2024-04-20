#!/bin/bash
# v 2.3

echo -e "\n\nStarting uninstall...\n"
sudo docker container stop unifi && sudo docker container rm unifi
sudo docker network rm unifi_default

sudo rm -rf /home/pi/.firewalla/run/docker/unifi  2> /dev/null && echo Directory deleted || echo "No directory to delete"
sudo rm -rf /home/pi/.firewalla/config/dnsmasq_local/unifi  2> /dev/null && echo dnsmasq_local/unifi deleted || echo "No dnsmasq_local/unifi to delete"
sudo rm -rf /home/pi/.firewalla/config/post_main.d/start_unifi.sh  2> /dev/null && echo start_unifi.sh deleted || echo "No start_unifi.sh to delete"
sudo rm -r /home/pi/.firewalla/run/docker/updatedocker.sh 2> /dev/null && echo updatedocker.sh deleted || echo "No updatedocker.sh to delete"
sudo docker ps 
sudo docker system prune -a && echo system pruned
sudo docker image prune -a && image pruned
sudo docker volume prune && volume pruned
sudo docker ps
sudo rm -rf /data/unifi  2> /dev/null
sudo ip route del 172.17.0.0/16 2> /dev/null
sudo systemctl restart firerouter_dns

echo -e "\n\nfin."
