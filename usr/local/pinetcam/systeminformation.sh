#!/bin/bash
#
# Copyright (C) 2019 Thomas Mueller <developer@mueller-dresden.de>
#
# This code is free software. You can use, redistribute and/or
# modify it under the terms of the GNU General Public Licence
# version 2, as published by the Free Software Foundation.
# This program is distributed without any warranty.
# See the GNU General Public Licence for more details.
#

# read settings from the config file
source /usr/local/pinetcam/config.cfg

echo "SOME SYSTEM INFORMATION:"
echo
(set -x; date)
echo
(set -x; hostname)
echo
(set -x; ifconfig eth0 | grep ' inet \| ether ')
echo
uptime
echo
(set -x; df -h | grep '^/dev/\|Dateisystem')
echo
(set -x; free -h)
echo
echo "RUNNING STREAMING SERVICES:"
echo
ps awux | grep "omxplayer.bin" | grep -v grep | awk -F 'http://' '{ print $1 "http://..." }'
ps awux | grep "ffmpeg\|gst-launch" | grep -v grep | awk -F 'icecast://' '{ print $1 "icecast://..." }'
echo
echo "STATUS OF UPDATES:"
echo
(set -x; uname -a)
echo
(set -x; sudo apt update; sudo apt list --upgradable)
echo
