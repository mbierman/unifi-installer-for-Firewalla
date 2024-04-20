#!/bin/bash
# v 2.3c

# Countdown function
countdown() {
    seconds=$1
    while [ $seconds -gt 0 ]; do
        echo -ne "Press Ctrl+C to stop execution. Continuing in $seconds seconds...\r"
        sleep 1
        : $((seconds--))
    done
    echo ""
}

# Display warning message
echo -e "WARNING! This will uninstall unifi from your Firewalla and remove all settings files.\n\nThere is no way to recover any lost files. Do not proceed unless you are sure!\n"

# Perform countdown for 10 seconds
countdown 10

echo -e "\n\nStarting uninstall...\n"
sudo docker container stop unifi && sudo docker container rm unifi
sudo docker network rm unifi_default

sudo rm -rf /home/pi/.firewalla/run/docker/unifi  2> /dev/null && echo ✅ Directory deleted || echo "❌ No directory to delete"
sudo rm -rf /home/pi/.firewalla/config/dnsmasq_local/unifi  2> /dev/null && echo ✅ dnsmasq_local/unifi deleted || echo "❌ No dnsmasq_local/unifi to delete"
sudo rm -rf /home/pi/.firewalla/config/post_main.d/start_unifi.sh  2> /dev/null && echo ✅ start_unifi.sh deleted || echo "❌ No start_unifi.sh to delete"
sudo rm -r /home/pi/.firewalla/run/docker/updatedocker.sh 2> /dev/null && echo ✅ updatedocker.sh deleted || echo "❌ No updatedocker.sh to delete"
sudo docker ps 
sudo docker system prune -af && echo system pruned
sudo docker image prune -af && image pruned
sudo docker volume prune -af && volume pruned
sudo docker ps
sudo rm -rf /data/unifi  2> /dev/null
sudo ip route del 172.17.0.0/16 2> /dev/null
sudo systemctl restart firerouter_dns

echo -e "\n\nfin."
