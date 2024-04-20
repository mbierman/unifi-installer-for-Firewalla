#!/bin/bash
# v 2.2

echo -e "WARNING! this will uninstall unifi from your Firewalla and remove all settings files.\n\nThere is no way to recover any lost files. Do not do this unless you are sure! "

# Providing 'Y' as input to the first prompt
now="Y"


echo -e "\n\nStarting uninstall...\n"
sudo docker container stop unifi && sudo docker container rm unifi
sudo docker network rm unifi_default

sudo rm -rf /home/pi/.firewalla/run/docker/unifi  2> /dev/null  && echo Directory deleted || echo "No directory to delete"
sudo rm -rf /home/pi/.firewalla/config/dnsmasq_local/unifi  2> /dev/null
sudo rm -rf /home/pi/.firewalla/config/post_main.d/start_unifi.sh  2> /dev/null
sudo rm -r /home/pi/.firewalla/run/docker/updatedocker.sh 2> /dev/null
sudo docker ps 
sudo docker system prune -a
sudo docker image prune -a
sudo docker volume prune
sudo docker ps
sudo rm -rf /data/unifi  2> /dev/null
sudo ip route del 172.17.0.0/16 2> /dev/null
sudo systemctl restart firerouter_dns

echo -e "\n\n"
read -p "Do you want to remove the uninstall script? Please press 'Y' to continue or any key to stop: " -n1 now

if  [[ "$now" = "Y" || "$now" = "y" ]]; then
        sudo rm -rf /data/unifi-uninstall.sh && echo -e "\nUninstall script removed.\n\n"
        exit
fi

echo -e  "\n\nfin."
