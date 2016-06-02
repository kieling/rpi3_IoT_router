#!/bin/bash

# Verbose 
#set -x 

MYMAC="fe80::ba27:ebff:febe:1501"

OUTPUT="connected_modules.txt"

SLEEPTIME=2s

# ping broadcast to the starting ipv6 of our modules
echo "Router MAC Address: $MYMAC"

# Variable bug, hardcoded, fix it later TODO
#COMMAND=$(ping6 -I bt0 -c 2 ff02::1 | grep "64 bytes from" | grep -v "$MYMAC" | awk '{print substr($4,1,length($4)-1)}')
#eval $COMMAND
#eval "$COMMAND"

while true; 
do
	rm -f $OUTPUT
	echo "$(ping6 -I bt0 -c 2 ff02::1 | grep "64 bytes from" | grep -v "$MYMAC" | awk '{print substr($4,1,length($4)-1)}')" > $OUTPUT
	cat $OUTPUT
	sleep $SLEEPTIME; 
done
