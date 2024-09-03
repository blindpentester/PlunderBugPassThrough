# monitor_plunderbug.sh
> In Debian, I am unable to defaulty have two Ethernet adapters enabled so sharing internet is not as easy as it is in Windows. I had tried to give the adapter a static IP, and it just was not working the way I was wanting it to and if you are attempting to use this on an actual audit, it will be important to have the victim machine to be able to connect to anything it would normally do (VPN/Proxy services the org has in place). For something like "Global Protect" there will need to be a secondary step in this attack such as the Bash Bunny. There will be other payloads for that in the future.
> This is how I share my attacker internet with the PlunderBug and get CAP file from what it is seeing.

Example:
```bash
Usage: ./monitor_plunderbug.sh {enable|disable}
blindpentester@wpad:~/Documents$ sudo ./monitor_plunderbug.sh enable
Enabling internet sharing and starting PlunderBug monitoring...
net.ipv4.ip_forward = 1
Starting tcpdump on br0...
tcpdump running with PID 223367
```
