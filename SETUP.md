# How to install the IoT Gateway-Router

### Clone this repository
`git clone https://github.com/kieling/pi3_iot_router`

### Installing Dependencies
- Run a full update on your RPI:<br>
`sudo apt-get update`<br>
`sudo apt-get upgrade`<br>
`sudo apt-get dist-upgrade`<br>
`sudo rpi-update`<br>

- Dependencies for Nordic Headless Router:<br>
`sudo apt-get install bluez pi-bluetooth radvd libcap-ng0`<br> 
bluez package need to be updated manually, check below<br>

- Dependencies for SIG Gateway Router<br>
`sudo apt-get install curl`<br>
`curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash - `<br>
`sudo apt-get install nodejs bluetooth bluez libbluetooth-dev libudev-dev`<br>

- Dependencies to compile the kernel: <br>
`sudo apt-get install git kernel-package build-essential bc`<br>

### Compiling the 6LoWPAN kernel
You can try to use the pre-compiled kernels available on `/kernel_imgs`, I am not sure if they will work with different kernel versions. 
- Clone the kernel repository (takes a while)<br>
`git clone https://github.com/raspberrypi/linux.git`<br>
- Configure the build inside the raspbian/kernel/linux folder. <br>
For RPI 1: `make bcmrpi_defconfig`<br>
For RPI 2 and 3: `make bcm2709_defconfig`<br>
- Compile the modules with: <br>
`make -j5 && -j5 modules` (j5 is to speedup using multicore)<br>
``CONCURRENCY_LEVEL=5 DEB_HOST_ARCH=ahmhf fake-root make kpkg --append-to-version -kernelname --revision \`date+\%Y\%m\%d\%H\%M\%S\` --initrd kernel_image kernel_headers``<br>
On the parent directory will be the generated .deb files.<br>
- Install the kernel and set it on boot cfg:<br>
`sudo dpkg -i linux-header*.deb linux-image*.deb`<br>
Go to /boot and execute:<br>
`ls | grep vmlinuz`<br>
"vmlinuz-4.4.8-kernelimg-v7+" will show up (version may differ)<br>
- Append it to the config.txt:<br>
`sudo sh -c 'echo "kernel=vmlinuz-4.4.8-kernelimg-v7+" >> config.txt'`<br>
- Reboot your Pi and it's done. <br>
If something goes wrong you can edit the config.txt in your sd card and comment the line with the new kernel.<br>

### Updating Bluez
The current version available at the Raspbian repositories (5.23) is outdated and full of bugs. The version I used was 5.4.
Download: `http://www.kernel.org/pub/linux/bluetooth/bluez-5.40.tar.xz`<br>
Patch the sources to make them compatible with the Pi: <br>
```
cd bluez-5.40
wget https://gist.github.com/pelwell/c8230c48ea24698527cd/archive/3b07a1eb296862da889609a84f8e10b299b7442d.zip
unzip 3b07a1eb296862da889609a84f8e10b299b7442d.zip
git apply  -v c8230c48ea24698527cd-3b07a1eb296862da889609a84f8e10b299b7442d/*
```
To build Bluez we need: <br>  
`sudo apt-get install autoconf glib2.0 libglib2.0-dev libdbus-1-dev libudev-dev libical-dev libreadline-dev`
Configure the build: 
```
./configure --prefix=/usr \
            --mandir=/usr/share/man \
            --sysconfdir=/etc \
            --localstatedir=/var \
            --enable-experimental \
            --enable-maintainer-mode
```
Compile and install: 
`make && sudo make install`

### Configuring Radvd
Add bt0 and eth0 interface into the file /etc/radvd.conf, so that we provide a global ipv6 address for the bt modules. 
```
interface eth0
{
    AdvSendAdvert on;
    prefix 2004:abc::/64
    { 
        AdvOnLink on;
        AdvAutonomous on;
        AdvRouterAddr on;
    };
    route ::/0
    {
    };

};

interface bt0
{
    AdvSendAdvert on;
    prefix 2005::2/64
    {
        AdvOnLink off;
        AdvAutonomous on;
       AdvRouterAddr on; 
    };
};
```
After that restart the Pi. To start the router some things have to be configured but they are all done with the `start_nordic.sh` script. Check there if you want details. 
