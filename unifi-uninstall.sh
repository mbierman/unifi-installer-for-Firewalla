#!/bin/bash
# v 2.4

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

# Start the uninstall process
echo -e "\n\nStarting uninstall...\n"

# Step 1: Check if the Unifi container exists
container_name="unifi"
if sudo docker ps -a --format '{{.Names}}' | grep -q "^$container_name$"; then
    echo "🔍 Unifi container found, stopping and removing..."
    
    # Step 2: Stop the container and disable restart
    sudo docker update --restart=no $container_name && sudo docker container stop $container_name
    
    # Ensure the container is fully stopped before removal
    if sudo docker ps -a --format '{{.Names}}' | grep -q "^$container_name$"; then
        echo "✅ Unifi container stopped, now removing..."
        
        # Force remove the container
        sudo docker container rm -f $container_name
        
        # Remove related images and network
        sudo docker image rm -f jacobalberty/unifi
        sudo docker network rm unifi_default
        
        echo "✅ Unifi container and images removed"
    else
        echo "❌ Failed to stop unifi container or it was removed."
    fi
else
    echo "❌ No such container: $container_name"
fi

# Step 3: Prune Docker system
sudo docker system prune -af && echo "✅ System pruned"

# Step 4: Restart DNS service to apply changes
echo -e "\nRestarting DNS...\n"
sudo systemctl restart firerouter_dns

# Step 5: Remove all traces of Unifi files and directories
sudo rm -rf /data/unifi 2> /dev/null
sudo ip route del 172.17.0.0/16 2> /dev/null
sudo rm -rf /home/pi/.firewalla/run/docker/unifi 2> /dev/null && echo "✅ Directory deleted" || echo "❌ No directory to delete"
sudo rm -rf /home/pi/.firewalla/config/dnsmasq_local/unifi 2> /dev/null && echo "✅ dnsmasq_local/unifi deleted" || echo "❌ No dnsmasq_local/unifi to delete"
sudo rm -rf /home/pi/.


echo -e "\n\nfin."
