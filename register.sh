#!/bin/bash

if ! [ -f /registered ]; then
	/usr/local/bin/SLE-15-SP3-x86_64-basic.sh
	touch /registered
else
	echo "* Machine already initialized."
fi

#echo "* Enter dummy loop"
#
#COUNTER=0
#
#while :; 
#do 
#	sleep 1
#	let COUNTER=$COUNTER+1
#
#	if [ $COUNTER -eq 200 ]; then
#		cp /usr/lib/python3.6/site-packages/salt/modules/status.py.fake /usr/lib/python3.6/site-packages/salt/modules/status.py
#	fi
#done

