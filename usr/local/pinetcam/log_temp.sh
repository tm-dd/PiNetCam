#!/bin/bash
#
# with notes from: https://www.raspberrypi.org/forums/viewtopic.php?t=141082
#
# Copyright (C) 2019 Thomas Mueller <developer@mueller-dresden.de>
#
# This code is free software. You can use, redistribute and/or
# modify it under the terms of the GNU General Public Licence
# version 2, as published by the Free Software Foundation.
# This program is distributed without any warranty.
# See the GNU General Public Licence for more details.
#

for i in {1..2}
do
	echo -n "date: " >> $SYSLOGFILE
	date >> $SYSLOGFILE
	cat /sys/class/thermal/thermal_zone0/temp | awk -v t=$1 '{ print "CPU: " $1/1000 "°C" }' >> $SYSLOGFILE
	/opt/vc/bin/vcgencmd measure_temp | awk -F "=|'" '{ print "GPU: " $2 " °C" }' >> $SYSLOGFILE
	echo -n "uptime:" >> $SYSLOGFILE
	uptime >> $SYSLOGFILE
	echo >> $SYSLOGFILE
	free -h >> $SYSLOGFILE
	echo >> $SYSLOGFILE
	/usr/sbin/iftop -t -s 10 >> $SYSLOGFILE
	echo '############################################################################################' >> $SYSLOGFILE
	echo >> $SYSLOGFILE
	sleep 20
done

exit 0

# example CRON configuration
# */2 * * * * sleep 10; /usr/local/pinetcam/log_temp.sh > /dev/null 2>/dev/null
# 59 23 * * 0 sleep 55; mv /var/log/sysstatus.txt /var/log/sysstatus.txt.0
