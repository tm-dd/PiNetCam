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

# stop, if option is missing
if [ -z "$1" ]
then
    echo 'USAGE: $0 [ h264 | mjpeg | audio ]'
    exit -1
fi

# start the video broadcasting
case "$1" in

audio)

    if [ ! "`ps awux | grep omxplayer | grep audio | grep -v grep`" ]
    then
       echo -e '\n*** try to start to connect to a separate audio streaming url (the signal can be unstable the first minutes) ...\n'
       ${PLAYERCOMMAND} ${PLAYERGLOBALOPTIONS} ${PLAYERAUDIOOPTIONS} ${STREAMAUDIOURL}
    else
        echo -e '\nIt looks like there is a audio output running with omxplayer.'
    fi
    
    ;;

h264)

    if [ ! "`ps awux | grep omxplayer | grep video | grep -v grep`" ]
    then
        echo -e '\n*** try to start to the video streaming url ...\n'
        ${PLAYERCOMMAND} ${PLAYERGLOBALOPTIONS} ${PLAYERVIDEOOPTIONS} ${PLAYERAUDIOOPTIONS} ${STREAMH264URL}
    else
        echo -e '\nIt looks like there is a video running with omxplayer.'
    fi
    
    ;;

mjpeg)

    if [ ! "`ps awux | grep omxplayer | grep video | grep -v grep`" ]
    then
       echo -e '\n*** try to start to the video streaming url ...\n'
       ${PLAYERCOMMAND} ${PLAYERGLOBALOPTIONS} ${PLAYERVIDEOOPTIONS} ${PLAYERAUDIOOPTIONS} ${STREAMMJPEGURL}
    else
        echo -e '\nIt looks like there is a video running with omxplayer.'
    fi
    
    ;;

esac

exit 0
