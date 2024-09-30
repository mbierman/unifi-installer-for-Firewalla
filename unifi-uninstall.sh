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

# Set the container name
container_name="unifi"

# Step 1: Check if the Unifi container exists
if sudo docker ps -a --format '{{.Names}}' | grep -q "^$container_name$"; then
    echo "🔍 Unifi container found, attempting to stop..."

    # Step 2: Stop the container and disable restart
    sudo docker update --restart=no $container_name
    stop_output=$(sudo docker container stop $container_name 2>&1)

    # Check if the stop command was successful
    if [[ $? -eq 0 ]]; then
        echo "✅ Unifi container stop command issued."

        # Step 3: Loop until the container is stopped
        echo "🔄 Waiting for the Unifi container to stop..."
        while sudo docker ps --format '{{.Names}}' | grep -q "^$container_name$"; do
            sleep 1  # Wait for 1 second before checking again
            echo -n "."  # Print a dot for each check to indicate progress
        done
        echo -e "\n✅ Unifi container has stopped."

        # Step 4: Remove the container
        echo "🔍 Removing Unifi container..."
        sudo docker container rm -f $container_name
        echo "✅ Unifi container removed."

        # Remove related images and network
        sudo docker image rm -f jacobalberty/unifi
        sudo docker network rm unifi_default
    else
        echo "❌ Error stopping Unifi container: $stop_output"
    fi
else
    echo "❌ No such container: $container_name"
fi

# Step 5: Prune Docker system
sudo docker system prune -af && echo "✅ System pruned"

# Step 6: Restart DNS service to apply changes
echo -e "\nRestarting DNS...\n"
sudo systemctl restart firerouter_dns

# Step 7: Remove all traces of Unifi files and directories
sudo rm -rf /data/unifi 2> /dev/null
sudo ip route del 172.17.0.0/16 2> /dev/null
sudo rm -rf /home/pi/.firewalla/run/docker/unifi 2> /dev/null && echo "✅ Directory deleted" || echo "❌ No directory to delete"
sudo rm -rf /home/pi/.firewalla/config/dnsmasq_local/unifi 2> /dev/null && echo "✅ dnsmasq_local/unifi deleted" || echo "❌ No dnsmasq_local/unifi to delete"
sudo rm -rf /home/pi/.firewalla/config/post_main.d/start_unifi.sh 2> /dev/null && echo "✅ start_unifi.sh deleted" || echo "❌ No start_unifi.sh to delete"
sudo rm -rf /home/pi/.firewalla/run/docker/updatedocker.sh 2> /dev/null && echo "✅ updatedocker.sh deleted" || echo "❌ No updatedocker.sh to delete"

echo -e "\n\nfin."
