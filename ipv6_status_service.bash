#!/bin/bash

# Daemon that monitors active connections, check for connection drops and new modules.

# Verbose
#set -x

MYIP="fe80::ba27:ebff:febe:1501"

PINGRESULT="connected_modules.txt"

LIST="gateway/navible/public/data.csv"

SLEEPTIME=5s

CONNECTED=0
CONNECTED_AUX=0

CHECK_NEW=0

function ping_and_log {
	# write result of a ipv6 broadcast to file
	rm -f $PINGRESULT
        echo "$(ping6 -I bt0 -c 2 ff02::1 | grep "64 bytes from" | grep -v "$MYIP" | awk '{print substr($4,1,length($4)-1)}')" > $PINGRESULT

	# clean file and variables
	rm -f $LIST
	CONNECTED_AUX=0

	# bug = check if arg == NULL
        echo "Local IP, Global IP" > $LIST
	while read -r arg;
        do
		if [[ $arg ]]; then
                	echo "$arg,2005${arg:4:${#arg}}" >> $LIST;
                	CONNECTED_AUX=$((CONNECTED_AUX+1));
		fi 
	done <<< "$(cat $PINGRESULT)"

#	echo "Connected aux: $CONNECTED_AUX   Connected: $CONNECTED"
}

# Main loop
while true;
do
	echo " "
	echo "Connected Modules: "
	echo "Router IP Address: $MYIP"

	ping_and_log

	# Handles reconnection, retries 3 times
	if [ "$CONNECTED_AUX" -lt "$CONNECTED" ]; then

		echo "At least one module was disconnected, trying to reconnect..."
		bash connect_all.bash
		sleep 3s
		ping_and_log
		
		if [ "$CONNECTED_AUX" -lt "$CONNECTED" ]; then
			bash connect_all.bash
			sleep 3s
			ping_and_log

			if [ "$CONNECTED_AUX" -lt "$CONNECTED" ]; then
                        	bash connect_all.bash
                     		sleep 3s
				ping_and_log
	  		fi
		fi
	fi 

	# set new connected var (give up on retrying)
	CONNECTED=$CONNECTED_AUX
	

	cat $LIST
	sleep $SLEEPTIME;

	# Handles new modules every X sleeptimes
	CHECK_NEW=$[CHECK_NEW+1];
	if [ "$CHECK_NEW" == 5 ]; then
		echo " " 
		echo "Checking for new connected modules..."
		bash connect_all.bash
		CHECK_NEW=0
	fi
done
