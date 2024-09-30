#!/bin/bash
version="2.6"

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

echo -e "WARNING! This will uninstall unifi from your Firewalla and remove all settings files.\n\nThere is no way to recover any lost files. Do not proceed unless you are sure!\n"
echo -e "version: $version"


# Perform countdown for 10 seconds
countdown 10

echo -e "\n\nStarting uninstall...\n"

container_name="unifi"

if sudo docker ps -a --format '{{.Names}}' | grep -q "^$container_name$"; then
    echo "🔍 Unifi container found, attempting to stop..."

    sudo docker update --restart=no $container_name
    stop_output=$(sudo docker container stop $container_name 2>&1)

    if [[ $? -eq 0 ]]; then
        echo "✅ Unifi container stop command issued."

        echo "🔄 Waiting for the Unifi container to stop..."
        while sudo docker ps --format '{{.Names}}' | grep -q "^$container_name$"; do
            sleep 1  # Wait for 1 second before checking again
            echo -n "."  # Print a dot for each check to indicate progress
        done
        echo -e "\n✅ Unifi container has stopped."

        echo "🔍 Removing Unifi container..."
        sudo docker container rm -f $container_name
        echo "✅ Unifi container removed."

        sudo docker image rm -f jacobalberty/unifi
        sudo docker network rm unifi_default
    else
        echo "❌ Error stopping Unifi container: $stop_output"
    fi
else
    echo "❌ No such container: $container_name"
fi

sudo docker system prune -af && echo "✅ System pruned"

echo -e "\nRestarting DNS...\n"
sudo systemctl restart firerouter_dns

sudo rm -rf /data/unifi 2> /dev/null
sudo ip route del 172.17.0.0/16 2> /dev/null
sudo rm -rf /home/pi/.firewalla/run/docker/unifi 2> /dev/null && echo "✅ Directory deleted" || echo "❌ No directory to delete"
sudo rm -rf /home/pi/.firewalla/config/dnsmasq_local/unifi 2> /dev/null && echo "✅ dnsmasq_local/unifi deleted" || echo "❌ No dnsmasq_local/unifi to delete"
sudo rm -rf /home/pi/.firewalla/config/post_main.d/start_unifi.sh 2> /dev/null && echo "✅ start_unifi.sh deleted" || echo "❌ No start_unifi.sh to delete"
sudo rm -rf /home/pi/.firewalla/run/docker/updatedocker.sh 2> /dev/null && echo "✅ updatedocker.sh deleted" || echo "❌ No updatedocker.sh to delete"

echo -e "\n\nfin."
