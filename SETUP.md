# How to install the IoT Gateway-Router

### Installing Dependencies
- Run a full update on your RPI:<br>
`sudo apt-get update`<br>
`sudo apt-get upgrad`<br>
`sudo apt-get dist-upgrade`<br>
`sudo rpi-update`<br>

- Dependencies for Nordic Headless Router:<br>
`sudo apt-get install bluez radvd libcap-ng0`<br>

- Dependencies for SIG Gateway Router<br>
`sudo apt-get install curl`<br>
`curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash - `<br>
`sudo apt-get install nodejs bluetooth bluez libbluetooth-dev libudev-dev`<br>

- Dependencies to compile the kernel: <br>
`sudo apt-get install git kernel-package build-essential bc`<br>

### Compiling the 6LoWPAN kernel
You can try to use the pre-compiled kernels available on kernel_imgs, not sure if they will work on other kernel versions. 
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
Restart Radvd: `sudo service radvd restart`

