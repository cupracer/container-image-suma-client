#!/bin/bash

if ! [ -f /etc/machine-id ] || ! [ -s /etc/machine-id ]; then
	echo "* No machine id. Starting init"
	/usr/local/bin/SLE-15-SP3-x86_64-basic.sh
	/usr/bin/systemd-machine-id-setup
else
	echo "* Machine already initialized."
fi

echo "* Starting salt-minon"
/usr/bin/salt-minion -d

echo "* Enter dummy loop"

COUNTER=0

while :; 
do 
	sleep 1
	let COUNTER=$COUNTER+1

	if [ $COUNTER -eq 200 ]; then
		cp /usr/lib/python3.6/site-packages/salt/modules/status.py.fake /usr/lib/python3.6/site-packages/salt/modules/status.py
	fi
done

