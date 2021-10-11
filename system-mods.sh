#!/bin/bash

if [ "$ACTIVATION_KEY" != "" ] && [ "$SUMA_HOSTNAME" != "" ];
then
	if ! [ -f /registered ]; 
	then
		DELAY=$(shuf -i${MIN_DELAY_SEC}-${MAX_DELAY_SEC} -n1)

		if [ $DELAY -gt 0 ]; 
		then
			echo "* Delaying boostrap script execution for $DELAY seconds"
			sleep $DELAY
		fi

		curl -Sks "https://${SUMA_HOSTNAME}/pub/bootstrap/${BOOTSTRAP_FILE}" | /bin/bash
		touch /registered
	else
		echo "* Machine already registered."
	fi

	echo "* Use fake uptime in Salt module"
	sed -i 's/\/proc\/uptime/\/tmp\/uptime/' /usr/lib/python3.6/site-packages/salt/modules/status.py
else
	echo "* Registration disabled."
fi

