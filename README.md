# Install Pi-hole Controller in Docker on Firewalla Gold and Purle

<hr>Note, although this installer also works on Firewalla Purple, I have seen people having trouble running large docker images on Purple and so be warned that this may be too taxing for Puprle hardware. To my knowlege, Firewalla hasn't made any official statement about this, but I felt a warning was justified. 
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
TBD 

There are lots of pi-hole communities like [Reddit](https://www.reddit.com/r/pihole/). If you have pihole questions, please check there. 
