#!/bin/bash

# Verbose 
#set -x 

FILE="result.txt"
COMMAND="cat result.txt"
 
echo "Scan and connect to all devices..."

# Added sleep to avoid Lescan bugs (when too frequently)
# seems to fix them 
#sleep 1s

# Lescan for 5 seconds, then kill it
eval "sudo hcitool lescan --passive | grep -v "LE" > $FILE & sleep 3s"

sudo pkill --signal SIGINT hcitool

# same as above
#sleep 1s

# Parse result file
$COMMAND | while read -r arg1 arg2; 
	do sudo echo "connect $arg1 1" > /sys/kernel/debug/bluetooth/6lowpan_control; 
	#sleep 0.5s
done

sleep 3s 

rm -f $FILE
echo "Connection done"
