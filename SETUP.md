<h1> How to install the router/gateway</h1>

- Run a full update on your RPI:<br>
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo rpi-update

- Dependencies for IPv6 Router:<br>
sudo apt-get install bluez radvd libcap-ng0

- Dependencies for SIG Gateway Router<br>
sudo apt-get install curl
curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash - 
sudo apt-get install nodejs bluetooth bluez libbluetooth-dev libudev-dev

- Dependencies to compile the kernel: <br>
sudo apt-get install git kernel-package build-essential bc

- Compile the new 6lowpan_kernel needed for the IPv6 Router and install it
Clone the kernel repository
git clone https://github.com/raspberrypi/linux.git
Configure the build inside the raspbian/kernel/linux folder. 
For RPI 1: make bcmrpi_defconfig
For RPI 2 and 3: make bcm2709_defconfig
Compile the modules with: 
make -j5 && -j5 modules (j5 is to speedup using multicore)
CONCURRENCY_LEVEL=5 DEB_HOST_ARCH=ahmhf fake-root make kpkg --append-to-version -kernelname --revision `date+\%Y\%m\%d\%H\%M\%S` --initrd kernel_image kernel_headers
On the parent directory will be the generated .deb files.
Install the kernel and set it on boot cfg:
sudo dpkg -i linux-header*.deb linux-image*.deb
Go to /boot and execute:
ls | grep vmlinuz
"vmlinuz-4.4.8-kernelimg-v7+" will show up (version may differ)
Append it to the config.txt:
sudo sh -c 'echo "kernel=vmlinuz-4.4.8-kernelimg-v7+" >> config.txt'
Reboot your Pi and its done. 
If something goes wrong you can edit the config.txt in your sd card and comment the line with the new kernel.

