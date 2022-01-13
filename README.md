# unifi-installer

This is a 1.0 script for installing the UniFi container on Firewalla Gold or Purple. It should get you up and running. It is based on the [Firewalla tutorial](https://help.firewalla.com/hc/en-us/articles/360053441074-Guide-How-to-run-UniFi-Controller-on-the-Firewalla-Gold-or-Purple-).

To isntall, [learn how to ssh into your firewalla](https://help.firewalla.com/hc/en-us/articles/115004397274-How-to-access-Firewalla-using-SSH-) if you don't know how already. 

Next, copy the line below and paste into the Firewalla shell. 

 ```
 curl -s -L -C- https://raw.githubusercontent.com/mbierman/unifi-installer/main/unifi_docker_install.sh | cat <(cat <(bash))
```

Standard disclaimer, I can not be responsible for any issues that result. Happy to answer questions though. :) 
