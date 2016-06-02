#!/bin/sh
set -x

# Setup radvd forwarding and bt 6lowpan module
echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
service radvd restart

# Setup 6lowpan module
modprobe bluetooth_6lowpan
echo 1 > /sys/kernel/debug/bluetooth/6lowpaw_enable

# check if its active
#lsmod | grep bluetooth_6lowpan

# reset hci interface
hciconfig hci0 reset

# connect 1 device
#echo "connect 00:E5:19:57:F2:19 1" > /sys/kernel/debug/bluetooth/6lowpan_control

# connect All devices
bash connect_all.bash

# wait 2 seconds
sleep 2s

# configure interfaces, only works if at least one module is connected (bt0 active)
ifconfig bt0 add 2005::1/128
ifconfig bt0 add 2005::/64
ifconfig eth0 add 2004:abc::1/128
ifconfig eth0 add 2004:abc::/64

