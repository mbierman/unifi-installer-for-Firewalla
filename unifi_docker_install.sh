#!/bin/bash 

path1=/data/unifi
if [ ! -d "$path1" ]; then
        sudo mkdir $path1
fi

path2=/home/pi/.firewalla/run/docker/unifi/
if [ ! -d "$path2" ]; then
        mkdir $path2
fi

curl https://gist.githubusercontent.com/mbierman/f678519a3f5db2b478fc506726d84a46/raw/c899d19409c665d57964dd1ec0d7de393c78914f/docker-compose.yaml \
> $path2/docker-compose.yaml

cd $path2

sudo systemctl start docker-compose@unifi

sudo docker ps

echo -n "Starting docker"
while [ -z "$(sudo docker ps | grep unifi | grep Up)" ]
do
        echo -n "."
        sleep 2s
done
echo "Done"

sudo ip route add 172.16.1.0/24 dev br-$(sudo docker network ls | awk '$2 == "unifi_default" {print $1}') table lan_routable
sudo ip route add 172.16.1.0/24 dev br-$(sudo docker network ls | awk '$2 == "unifi_default" {print $1}') table wan_routable
echo address=/unifi/172.16.1.2 > ~/.firewalla/config/dnsmasq_local/unifi
sudo systemctl restart firerouter_dns
sudo docker-compose down

path3=/home/pi/.firewalla/config/post_main.d
if [ ! -d "$path3" ]; then
        mkdir $path3
fi

echo "#!/bin/bash
sudo systemctl start docker
sudo systemctl start docker-compose@unifi
sudo ipset create -! docker_lan_routable_net_set hash:net
sudo ipset add -! docker_lan_routable_net_set 172.16.1.0/24
sudo ipset create -! docker_wan_routable_net_set hash:net
sudo ipset add -! docker_wan_routable_net_set 172.16.1.0/24" >  /home/pi/.firewalla/config/post_main.d/start_unifi.sh

chmod a+x /home/pi/.firewalla/config/post_main.d/start_unifi.sh

sudo docker stop unifi
sudo docker start unifi

echo -n "Restarting docker"
while [ -z "$(sudo docker ps | grep unifi | grep Up)" ]
do
        echo -n "."
        sleep 2s
done
echo -e "Done!\n\nYou can open https://172.16.1.2:8443/ in your favorite browser and set up your UniFi Controller.\n\n"
