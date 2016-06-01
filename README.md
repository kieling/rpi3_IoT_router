
Todo:
- add IPv6 connected modules to the front-end 
- test last created scripts
- test functionality with gateway and router on 
- Installation Guide

Workaround: 
- start IPv6
- connect to all IPv6 modules (or something different?) 
- start gateway and navible

Status: 
If IPv6 started and then Navible:
- It works, and Navible dosnt see the IPv6 modules

If Navible started and then IPv6 Router: 
- We can connect to the IPv6 module, but we cannot ping it, it is still showing on Navible
and once we try to use it with Navible the IPv6 connection turns off

Scripts:
- setup_all.sh:<br>
	Start the IPv6 router, connect to all IPv6 devices, start the bt gateway and the front end. 
- start_gateway.sh:<br>
	Start the BT Gateway and NaviBLE front end. 
- start_nordic.sh<br>
	Start the Nordic Headless Router
- reset_hci.sh:<br>
	Reset HCI0 communication due to some bugs with lescan
- ping_broadcast.sh:<br>
	Ping broadcast to IPv6 local interface
- connect_all.bash:<br>
	Tries to connect to all devices found by a hcitool lescan
- connect_to_device.sh:<br>
	Connects to a single device
- nordic commands:<br>
	Shows some commands to be used with the Headless router

