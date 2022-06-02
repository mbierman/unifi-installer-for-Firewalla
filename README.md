# Install UniFi Controller in Docker on Firewalla Gold 

<hr>Note, although this installer also works on Firewalla Purple, I have seen people having trouble running large docker images on Purple and so be warned that this may be too taxing for Puprle. To my knowlege, Firewalla hasn't made any official statement about this, but I felt a warning was justified. 
<hr>

This is a script for installing the UniFi docker container on Firewalla Gold. It is based on the [Firewalla tutorial](https://help.firewalla.com/hc/en-us/articles/360053441074-Guide-How-to-run-UniFi-Controller-on-the-Firewalla-Gold-or-Purple) and has been tested on 1.974.

To install:
1. SSH into your Firewalla ([learn how](https://help.firewalla.com/hc/en-us/articles/115004397274-How-to-access-Firewalla-using-SSH-) if you don't know how already.)

2. Copy the line below and paste into the Firewalla shell and then hit enter.

```
curl -s -L -C- https://raw.githubusercontent.com/mbierman/unifi-installer-for-Firewalla/main/unifi_docker_install.sh | cat <(cat <(bash))
```

**Standard disclaimer:** I can not be responsible for any issues that may result. Nothing in the script should in any way, affect firewalla as a router or comprimise security. Happy to answer questions though if I can. :)

# Uninstalling
The [installer script](https://raw.githubusercontent.com/mbierman/unifi-installer-for-Firewalla/main/unifi-uninstall.sh) will remove the unifi docker and ALL related data. If you want to start from square one, you can use this. But be warned, I mean square one. It is currently set to remove all the docker data. I may make it more forgiving in the future, but if things aren't working and you need to start over, this should get you there.

If you want more of a piecemeal approach, see below.

## Using an uninsall script

1. ssh to your firewalla. User is always `pi` and the password comes from the Firewalla app. 
1. Save the uninstall script on your firewalla:
   - `cd /home/pi/.firewalla/run/docker/`
   - `curl https://raw.githubusercontent.com/mbierman/unifi-installer-for-Firewalla/main/unifi-uninstall.sh > \ /data/unifi-uninstall.sh`
4. Make it executable:
   - `chmod a+x /home/pi/.firewalla/run/docker/unifi-uninstall.sh`
6. Run the script:
   - `/home/pi/.firewalla/run/docker/unifi-uninstall.sh`

You should now be back to a clean slate and ready to re-install if you choose do do so. 

## Uninsalling Manually

If you want something less severe, the commands below give you more discresion. 

If you need to reset the container (stop and remove and try again) run the following commands. 

WARNING: if you use these commands you are stopping and removing the container. Don't do this unless you are sure that you don't mind potentially losing stuff. If you haven't managed to get the Controller running then there is probably no harm in going forward. Otherwise, only do this if you know at least a little bit about what you are doing. 

```
sudo docker container stop unifi && sudo docker container rm unifi
rm /home/pi/.firewalla/config/post_main.d/start_unifi.sh
rm ~/.firewalla/config/dnsmasq_local/unifi
rm -rf /home/pi/.firewalla/run/docker/unifi
```

There are lots of UniFi communities on [Reddit](https://www.reddit.com/r/Ubiquiti/) and [Facebook](https://www.facebook.com/groups/586080611853291). If you have UniFi questions, please check there. 
