#IoT Gateway-Router for the Raspberry Pi 3
The base codes used here were provided by Nordic Semiconductors and Bluetooth SIG. This project aims to combine the two concepts introduced by them on a Raspberry Pi 3: IPv6 Headless Router and Bluetooth Gateway Smart. Codes were adapted to make em functional on a Raspberry Pi 3.

###Todo:
- [x] Finish SETUP.md
- [x] Add IPv6 connected modules to the front-end 
- [x] Add Reconnect service to support failures (X tries)
- [ ] Fix HCI LESCAN error @ connect_all.bash - Try to update Bluez and check if it solves the problem
- [ ] Test functionality with gateway and router on (router seems to be unstable)
- [ ] Analyse how to secure BT handshake (before stablishing connection)

###Functionality:
- Router: provide a global IPv6 to every connected device (BT 4.2), making it accessible from outside. Other functionalities are provided by upper level protocols (CoAP).
- Gateway: make older BT devices (BTLE 4.0) accessable and manageable from outside, providing BT functionalities of every connected module over internet. 
- Navible Front-End: front-end for managing BT devices connected to the gateway and have an overview of connected IPv6 devices. 

###Installation:
- Check `SETUP.md` or get a img dump of the microSD I used (link to be provided). 

###Starting the router
- Turn the Pi on with everything installed, run `setup_all.sh`. You can also add it to `/etc/rc.local/` or `/etc/init.d/` to start it on boot. 

###Workaround: 
Because of problems between the Router and the Gateway we have to do the following:
- First start IPv6 router
- Connect all IPv6 modules and start daemon to control them
- Start Gateway and Navible front-end

###Problems:
Headless router seems to be unstable, sometimes it works fine for hours, sometimes connection keeps dropping, not sure why.

If IPv6 started and then Navible:
- It works, and Navible dosnt see the IPv6 modules

If Navible started and then IPv6 Router: 
- We can connect to the IPv6 module, but we cannot ping it, it is still showing on Navible
and once we try to use it with Navible the IPv6 connection turns off

###Scripts:
- `setup_all.sh`:<br>
	Start the IPv6 router, connect to all IPv6 devices, start the bt gateway and the front end. 
- `start_gateway.sh`:<br>
	Start the BT Gateway and NaviBLE front end. 
- `start_nordic.sh`:<br>
	Start the Nordic Headless Router
- `reset_hci.sh`:<br>
	Reset HCI0 communication due to some bugs with lescan
- `ping_broadcast.sh`:<br>
	Ping broadcast to IPv6 local interface
- `connect_all.bash`:<br>
	Tries to connect to all devices found by a hcitool lescan
- `connect_to_device.sh`:<br>
	Connects to a single device
- `nordic commands`:<br>
	Shows some commands to be used with the Headless router
- `ipv6_status_service.bash`: <br>
	Daemon that manages active connections and search for new modules
