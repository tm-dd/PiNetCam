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

/bin/ps awux | /usr/bin/grep "${TEMPRECORDSCRIPT}" | /usr/bin/grep -v 'grep' | /usr/bin/awk '{ print $2 }' | /usr/bin/xargs kill 
sleep 3
/bin/ps awux | /usr/bin/grep "${STREAMRECORDURL}" | /usr/bin/grep -v 'grep' | /usr/bin/awk '{ print $2 }' | /usr/bin/xargs kill
exit 0 
