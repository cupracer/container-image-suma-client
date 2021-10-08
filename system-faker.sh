#!/bin/bash

if ! [ -f /registered ]; then
	/usr/local/sbin/bootstrap.sh
	touch /registered
else
	echo "* Machine already registered."
fi

echo "* Use fake uptime in Salt module"
sed -i 's/\/proc\/uptime/\/tmp\/uptime/' /usr/lib/python3.6/site-packages/salt/modules/status.py

echo "* Enter dummy loop to fake uptime"

COUNTER=1

while :; 
do 
	sleep 1
	let COUNTER=$COUNTER+1
	echo "${COUNTER} ${COUNTER}" > /tmp/uptime
done

