#!/bin/bash
set -x

echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
service radvd restart
modprobe bluetooth_6lowpan

echo 1 > /sys/kernel/debug/bluetooth/6lowpaw_enable

#echo "connect 00:E5:19:57:F2:19 1" > /sys/kernel/debug/bluetooth/6lowpan_control

# connect all devices
sudo bash connect_all.bash

# wait 2 seconds
sleep 2

# cannot set interfaces if no module is connected!

# configure interfaces
ifconfig bt0 add 2005::1/128
ifconfig bt0 add 2005::/64
ifconfig eth0 add 2004:abc::1/128
ifconfig eth0 add 2004:abc::/64

