#!/bin/bash

# Verbose 
#set -x 

COMMAND="cat result.txt"

echo "Scan and connect to all devices..."
# Lescan for 5 seconds, then kill it
sudo hcitool lescan > result.txt & sleep 5
sudo pkill --signal SIGINT hcitool
#cat result.txt

# Parse result file 
$COMMAND | while read -r arg1 arg2; 
	# do echo "$arg1"
	do sudo echo "connect $arg1 1" > /sys/kernel/debug/bluetooth/6lowpan_control; 
done

echo "Connection done"
