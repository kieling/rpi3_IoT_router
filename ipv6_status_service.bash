#!/bin/bash

# Daemon that monitors active connections, check for connection drops and new modules.

# Verbose
#set -x

MYIP="fe80::ba27:ebff:febe:1501"

OUTPUT="connected_modules.txt"

OUTPUT2="gateway/navible/public/data.csv"

SLEEPTIME=2s

CONNECTED=0
CONNECTED_AUX=0

CHECK_NEW=0

function ping_and_log {
	rm -f $OUTPUT2

	# write result of a ipv6 broadcast to file
        echo "$(ping6 -I bt0 -c 2 ff02::1 | grep "64 bytes from" | grep -v "$MYIP" | awk '{print substr($4,1,length($4)-1)}')" > $OUTPUT

        echo "Local IP, Global IP" > $OUTPUT2;

        CONNECTED_AUX=0

	while read -r arg;
        do
                echo "$arg,2005${arg:4:${#arg}}" >> $OUTPUT2;
                CONNECTED_AUX=$((CONNECTED_AUX+1));
	done <<< "$(cat $OUTPUT)"

#	echo "Connected aux: $CONNECTED_AUX   Connected: $CONNECTED"
}

# Main loop
while true;
do
	echo "Connected Modules: "
	echo "Router IP Address: $MYIP"

	ping_and_log

	# Handles reconnection, retries 3 times
	if [ "$CONNECTED_AUX" -lt "$CONNECTED" ]; then

		echo "At least one module was disconnected, trying to reconnect..."
		bash connect_all.bash
		ping and log

		if [ "$CONNECTED_AUX" -lt "$CONNECTED" ]; then
			sleep 3s
			bash connect_all.bash
			ping and log

			if [ "$CONNECTED_AUX" -lt "$CONNECTED" ]; then
                     		sleep 3s
                        	bash connect_all.bash
                     		ping and log
	                fi
		fi
	else
		CONNECTED=$CONNECTED_AUX;
	fi

	rm -f $OUTPUT
	cat $OUTPUT2

	sleep $SLEEPTIME;

	# Handles new modules every X sleeptimes
	CHECK_NEW=$[CHECK_NEW+1];
	if [ "$CHECK_NEW" == 5 ]; then
		echo "Checking for new connected modules..."
		bash connect_all.bash
		CHECK_NEW=0
	fi
done
