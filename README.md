# Install UniFi Controller in Docker on Firewalla Gold Series Boxes

<hr>
<p>Note, although this installer also works on Firewalla Purple, I have seen people have trouble running some docker images on Purple so I caution that this may be too taxing for Puprle and very likely Purple SE. To my knowledge, Firewalla hasn't made any official statement about this, just my recommendation.</p>
<hr>

This is a script for installing the UniFi docker container on all Firewalla Gold series boxes (Gold, Gold SE, Gold Plus, Gold Pro). It is based on the [Firewalla tutorial](https://help.firewalla.com/hc/en-us/articles/360053441074-Guide-How-to-run-UniFi-Controller-on-the-Firewalla-Gold-or-Purple) and has been tested on 1.974 and above.

To install:
1. SSH into your Firewalla ([learn how](https://help.firewalla.com/hc/en-us/articles/115004397274-How-to-access-Firewalla-using-SSH-) if you don't know how already.)

2. Copy the line below and paste into the Firewalla shell and then hit enter.

```
curl -s -L -C- "https://raw.githubusercontent.com/mbierman/unifi-installer-for-Firewalla/main/unifi_docker_install.sh?$(date +%s)" | cat <(cat <(bash))
```

**Standard disclaimer:** I can not be responsible for any issues that may result. Nothing in the script should in any way, affect firewalla as a router or compromise security. Happy to answer questions though if I can. :)

# Updating docker
From time to time unifi will update the Controller. After vetting it for a while, the owner of the container will update the image. This is a good thing. It means you get some confidence it will run when you update it. I wrote a script to do the updates. I watch when the container is updated and then run the script. You could do this via a cron job (e.g. once a week run the update and if there isn't one it will just exit) but I don't tend to do that since if it goes poorly my controller could be down. 

To update the unifi docker container in the future, go to:
```
/home/pi/.firewalla/run/docker
```
and run
```
./updatedocker.sh unifi
```

# Uninstalling
This [uninstaller script](https://raw.githubusercontent.com/mbierman/unifi-installer-for-Firewalla/main/unifi-uninstall.sh) will remove the unifi docker and ALL related data. If you want to start from square one, you can use this. But be warned, I mean square one. It is currently set to remove all the docker data. I may make it more forgiving in the future, but if things aren't working and you need to start over, this should get you there.

## Using an uninsall script

1. ssh to your firewalla. User is always `pi` and the password comes from the Firewalla app. 
1. Run
```
curl -s -L "https://raw.githubusercontent.com/mbierman/unifi-installer-for-Firewalla/main/unifi-uninstall.sh?$(date +%s)" | bash
```

You should now be back to a clean slate and ready to re-install if you choose do do so.

There are lots of UniFi communities on [Reddit](https://www.reddit.com/r/Ubiquiti/) and [Facebook](https://www.facebook.com/groups/586080611853291). If you have UniFi questions, please check there. 

# Video

A video by Ethernet Blueprint showing how this works.
[![Video](https://img.youtube.com/vi/yMyHo1YpdKI/hqdefault.jpg)](https://www.youtube.com/watch?v=yMyHo1YpdKI)
