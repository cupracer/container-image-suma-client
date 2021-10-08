#!/usr/bin/env python3

import time

uptime = 0

while True:
    with open('/tmp/uptime', 'w') as f:
        f.write(str(uptime) + ' ' + str(uptime))
    time.sleep(1)
    uptime += 1

