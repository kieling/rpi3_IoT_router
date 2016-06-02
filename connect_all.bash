#!/bin/bash

# Verbose 
#set -x 

COMMAND="cat result.txt"

# TODO : add grep to the hcitool lescan output to check if it is bugged, then restart hci 
echo "Scan and connect to all devices..."
# Lescan for 5 seconds, then kill it
sudo hcitool lescan | grep -v "LE" > result.txt & sleep 3s
sudo pkill --signal SIGINT hcitool

sleep 3s 

# Parse result file 
$COMMAND | while read -r arg1 arg2; 
	do sudo echo "connect $arg1 1" > /sys/kernel/debug/bluetooth/6lowpan_control; 
	#sleep 0.5s
done

echo "Connection done"
