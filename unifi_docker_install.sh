#!/bin/bash 
# v 1.7.1

path1=/data/unifi
if [ ! -d "$path1" ]; then
        sudo mkdir $path1
	sudo chown pi $path1
	sudo chmod +rw $path1
 	echo -e "\n✅ unifi directory created."
 else
 	echo -e "\n✅ unifi directory exists."
fi

path2=/home/pi/.firewalla/run/docker/unifi/
if [ ! -d "$path2" ]; then
        sudo mkdir $path2
	sudo chown pi $path2
	sudo chmod +rw $path2
  	echo -e "\n✅ unifi run directory created."
 else
 	echo -e "\n✅ unifi run directory exists."

fi

curl -s https://raw.githubusercontent.com/mbierman/unifi-installer/main/docker-compose.yaml > $path2/docker-compose.yaml
sudo chown pi $path2/docker-compose.yaml
sudo chmod +rw $path2/docker-compose.yaml
echo -e "\n✅ unifi yaml created."
cd $path2

sudo systemctl start docker-compose@unifi

sudo docker ps

function ready () {
echo -n "Starting docker (this can take ~ one minute)"
while [ -z "$(sudo docker ps | grep unifi | grep -o Up)" ]
do
        echo -n "."
        sleep 2s
done

echo -e "\n✅ unifi has started"
}

ready

echo "configuring networks..."
ID=$(sudo docker network ls | awk '$2 == "unifi_default" {print $1}')

if ! ip route show table lan_routable | grep -q '172.16.1.0'; then
    sudo ip route add 172.16.1.0/24 dev br-$ID table lan_routable
    else 
    echo -e "LAN route is already in place.\n"
fi

if ! ip route show table wan_routable | grep -q '172.16.1.0'; then
    sudo ip route add 172.16.1.0/24 dev br-$ID table wan_routable
else 
    echo -e "WAN route is already in place.\n"
fi

echo -e "\n✅ Networks configured"

dns_settings=/home/pi/.firewalla/config/dnsmasq_local/unifi
sudo touch $dns_settings
sudo chown pi $dns_settings
sudo chmod a+rw $dns_settings
echo address=/unifi/172.16.1.2 > $dns_settings
echo -e "\n✅ unifi network settings saved."
sleep 10
sudo systemctl restart firerouter_dns
echo -e "\n✅ Network service restarted..."
sleep 5

#Update 
update=/home/pi/.firewalla/run/docker/updatedocker.sh
touch $update
sudo chown pi $update
sudo chmod a+xrw $update
curl -s https://gist.githubusercontent.com/mbierman/6cf22430ca0c2ddb699ac8780ef281ef/raw/b2790767203e4ee49a250f46047a07c6d7a8a79b/updatedocker.sh > $update


path3=/home/pi/.firewalla/config/post_main.d
if [ ! -d "$path3" ]; then
        sudo mkdir $path3
	sudo chown pi $path3
	sudo chmod +rw $path3
fi

echo -e  "#!/bin/bash
        sudo systemctl start docker
        sudo systemctl start docker-compose@unifi
        sudo ipset create -! docker_lan_routable_net_set hash:net
        sudo ipset add -! docker_lan_routable_net_set 172.16.1.0/24
        sudo ipset create -! docker_wan_routable_net_set hash:net
        sudo ipset add -! docker_wan_routable_net_set 172.16.1.0/24" >  $path3/start_unifi.sh

[ -f /etc/update-motd.d/00-header ] && series=$(/etc/update-motd.d/00-header | grep "Welcome to" | sed -e "s|Welcome to ||g" -e "s|FIREWALLA ||g" -e "s|\s[0-9].*$||g") || series=""

if [[ "$series" == *"gold-se"* ]] && ! grep -q "MASQUERADE" "$path3/start_unifi.sh"; then
	echo "Adding Gold SE networking..."
	echo -e "sudo iptables -t nat -A POSTROUTING -s 172.16.1.0/16 -o eth0 -j MASQUERADE" >>  $path3/start_unifi.sh
fi

chmod a+x $path3/start_unifi.sh
chown pi  $path3/start_unifi.sh

echo -n "Restarting docker " && sudo docker start unifi
while [ -z "$(sudo docker ps | grep unifi | grep Up)" ]
do
        echo -n "."
        sleep 2s
done
echo -e "\nStarting the container, please wait....\n"

ready

echo -e "Done!\n\nYou can open https://172.16.1.2:8443 in your favorite browser and set up your UniFi Controller. \n\nNote it may not have a certificate so the browser may give you a security warning.\n\nAlso note the container may take a minute to be accessible as the web server starts. Give it a minute or two and refresh your browser.\n\n"
echo -e "\n\n To update the unifi docker container in the future, run\n/home/pi/.firewalla/run/docker/updatedocker.sh unifi\n\n"
