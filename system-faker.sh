#!/bin/bash

if ! [ -f /registered ]; then
	curl -Sks https://${SUMA_HOSTNAME}/pub/bootstrap/bootstrap-podman.sh | /bin/bash
	touch /registered
else
	echo "* Machine already registered."
fi

echo "* Use fake uptime in Salt module"
sed -i 's/\/proc\/uptime/\/tmp\/uptime/' /usr/lib/python3.6/site-packages/salt/modules/status.py

echo "* Enter dummy loop to fake uptime"
/usr/local/sbin/uptime.py

