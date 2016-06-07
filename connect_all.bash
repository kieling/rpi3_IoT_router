#!/bin/bash

# Verbose 
#set -x 

FILE="result.txt"
COMMAND="cat result.txt"
 
echo "Scan and connect to all devices..."

# Tries to kill hcitool first, in case any remaining scan is still active
sudo pkill --signal SIGINT hcitool

# Lescan for 5 seconds, then kill it
sudo hcitool lescan | grep -v "LE" > $FILE & sleep 3s
sudo pkill --signal SIGINT hcitool

sleep 3s 

# Parse result file 
$COMMAND | while read -r arg1 arg2; 
	do sudo echo "connect $arg1 1" > /sys/kernel/debug/bluetooth/6lowpan_control; 
	#sleep 0.5s
done

rm -f $FILE

echo "Connection done"
