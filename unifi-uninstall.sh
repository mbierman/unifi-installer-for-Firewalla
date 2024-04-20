#!/bin/bash
# v 2.3

# Function to display script usage
usage() {
    echo "Usage: $0 [-y]"
    echo "  -y  Automatically answer 'yes' to all prompts"
    exit 1
}

# Default value for automatic 'yes' answer
automatic_yes=false

# Parse command-line options
while getopts ":y" opt; do
    case ${opt} in
        y )
            automatic_yes=true
            ;;
        \? )
            usage
            ;;
    esac
done
shift $((OPTIND -1))

# Display warning message
echo -e "WARNING! this will uninstall unifi from your Firewalla and remove all settings files.\n\nThere is no way to recover any lost files. Do not do this unless you are sure! "

# Prompt user to continue unless automatic 'yes' answer is enabled
if [ "$automatic_yes" = false ]; then
    read -p "Please press 'Y' to continue or any key to stop: " -n1 now
    echo ""
    if ! [[ "$now" = "Y" || "$now" = "y" ]]; then
        echo -e "\nNo changes made.\n\n"
        exit 0
    fi
fi

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

echo -e "\n\n"
if [ "$automatic_yes" = false ]; then
    read -p "Do you want to remove the uninstall script? Please press 'Y' to continue or any key to stop: " -n1 now
    echo ""
    if  [[ "$now" = "Y" || "$now" = "y" ]]; then
        sudo rm -rf /data/unifi-uninstall.sh && echo -e "\nUninstall script removed.\n\n"
    fi
fi

echo -e  "\n\nfin."
