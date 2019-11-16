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

echo -e "\naudio devices:\n"
arecord -L | grep -A 2 'hw:'

echo -e "\npress Enter to continue ..."
read

echo -e "video devices:"
for dev in /dev/video*
do
    echo -e "\ntry $dev:"
    ffprobe -v error -show_format -show_streams $dev
done
echo

exit 0
