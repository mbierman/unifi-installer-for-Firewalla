#!/bin/bash

echo -e "WARNING! this will uninstall unifi from your Firewalla and remove all settings files.\n\nThere is no way to recover any lost files. Do not do this unless you are sure! "

read -p "Please press 'Y' to continue or any key to stop: " -n1 now

if ! [[ "$now" = "Y" || "$now" = "y" ]]; then
        echo -e "\nNo changes made.\n\n"
        exit
fi

echo "Starting uninstall"
cd ~/.firewalla/run/docker/unifi
sudo docker container stop unifi && sudo docker container rm unifi
sudo docker system prune -a
sudo docker image prune -a
sudo docker volume prune
sudo docker ps
rm /home/pi/.firewalla/config/post_main.d/start_unifi.sh
rm ~/.firewalla/config/dnsmasq_local/unifi
rm -rf /home/pi/.firewalla/run/docker/unifi
sudo rm -rf /data/unifi
sudo ip route del 172.17.0.0/16 
sudo systemctl restart firerouter_dns
