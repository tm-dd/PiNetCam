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
    echo 'USAGE: $0 [ h2640 | h2641 | h2642 | mjpeg | audio ]'
    exit -1
fi

function trySignal {

    # stop, if function parameter is missing
    if [ -z "$1" ]
    then
        echo 'ERROR: The function trySignal need 3 parameters.'
        exit -1
    fi

    STREAMURL=$1        # the URL to PLAY the video/audio
    VIDEOFORMAT=$2      # if not nessesary, set to "ignore"
    AUDIOFORMAT=$3      # if not nessesary, set to "ignore"
    VURL=$4             # the URL to SEND the video/audio
    TEMPFILESTREAM=$5   # a temp file to try the video stream

    echo "Trying streaming signal ..."
    # fetch the stream
    ${FFPROBEBIN} ${STREAMURL} > /dev/null 2> ${TEMPFILESTREAM}
    cat ${TEMPFILESTREAM} | grep " Video: \| Audio: "

    # analyse the stream
    VERROR=0; AERROR=0
    VIDEOTEST=`cat ${TEMPFILESTREAM} | grep ' Video: ' | grep "${VIDEOFORMAT}"`
    AUDIOTEST=`cat ${TEMPFILESTREAM} | grep ' Audio: ' | grep "${AUDIOFORMAT}"`
    if [ -z "${VIDEOTEST}" ] && [ "${VIDEOFORMAT}" != 'ignore' ]; then echo "ERROR ON VIDEO SIGNAL."; VERROR="1"; else VERROR="0"; fi
    if [ -z "${AUDIOTEST}" ] && [ "${AUDIOFORMAT}" != 'ignore' ]; then echo "ERROR ON AUDIO SIGNAL."; AERROR="1"; else AERROR="0"; fi
    
    # if anythink is wrong, kill the processes
    if [ "${VERROR}" != "0" ] || [ "${AERROR}" != "0" ]
    then
        echo "Restart of all ffmpeg processes, because there is a problem with the signal."
        OLDPROCESS=`ps awux | grep "${VURL}" | grep -v 'grep ' | awk '{ print $2 }'`
        if [ -n "${OLDPROCESS}" ]; then ( set -x; kill "${OLDPROCESS}"; sleep 30 ); fi
    else
        echo "The streams looks OK. Exit now."; exit
    fi   

}

# check the uptime of the system and wait, if it is to short
UPTIMESEC=`cat /proc/uptime | awk '{ print $1 }' | awk -F '.' '{ print $1 }'`
while [ "$UPTIMESEC" -lt "$MINUPTIMESEC" ]
do
    echo "wait to get an uptime ($UPTIMESEC) of at least $MINUPTIMESEC seconds ..."
    sleep 5
    UPTIMESEC=`cat /proc/uptime | awk '{ print $1 }' | awk -F '.' '{ print $1 }'`
done

echo '---'
date

# start the video broadcasting
case "$1" in

h2640)

    # -- USB H.264 send video and the build-in audio signal from the camera in ONE stream -- #

    # try the current video stream and restart ffmpeg, if problems exists
    trySignal "${STREAMH264URL}" 'yuv420p(progressive), 1920x1080' '44100 Hz, mono, fltp' "${SENDVIDEOURL1}" '/tmp/h2640_signal.tmp'

    echo 'Send the audio and video as one stream from the H.264 camera.'

    # stop, if this process is still running
    if [ "`ps awux | grep 'ffmpeg' | grep 'icecast://video:' | grep ' -c:v copy ' | grep -v grep`" != "" ]
    then
        echo -e '\nERROR: It looks like the video signal is still sending.\n'
        exit -1
    fi
    
    $FFMPEG -i ${VDEVH264} -r 30 -f alsa -ac 1 -ar 44100 -ss $AOFFSET -i ${ADEVH264} -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -ab 64k -strict 2 -f mpegts ${SENDVIDEOURL1} 2> /dev/null > /dev/null ;;
    
h2641)

    # -- USB H.264 send audio and video in ONE stream -- #

    echo 'Send the audio and video as one stream from the H.264 camera.'
    
    # try the current video stream and restart ffmpeg, if problems exists
    trySignal "${STREAMH264URL}" 'yuv420p(progressive), 1920x1080' '44100 Hz, mono, ' "${SENDVIDEOURL1}" '/tmp/h2641_signal.tmp'

    # stop, if this process is still running
    if [ "`ps awux | grep 'ffmpeg' | grep 'icecast://video:' | grep ' -c:v copy ' | grep -v grep`" != "" ]
    then
        echo -e '\nERROR: It looks like the video signal is still sending.\n'
        exit -1
    fi

    $FFMPEG -i ${VDEVH264} -r 30 -f alsa -ac 1 -ar 44100 -ss $AOFFSET -i ${ADEVUSB1} -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -ab 64k -strict 2 -f mpegts ${SENDVIDEOURL1} 2> /dev/null > /dev/null ;;

h2642)

    # -- USB H.264 send only the video to combine with the separate audio stream ($0 audio) -- #

    # try the current video stream and restart ffmpeg, if problems exists
    trySignal "${STREAMH264URL}" 'yuv420p(progressive), 1920x1080' 'ignore' "${SENDVIDEOURL1}" '/tmp/h2642_signal.tmp'
    
    echo 'Send the video from the H.264 camera, omly.'   

    # stop, if this process is still running
    if [ "`ps awux | grep 'ffmpeg' | grep 'icecast://video:' | grep ' -codec:v copy ' | grep -v alsa | grep -v grep`" != "" ]
    then
        echo -e '\nERROR: It looks like the video signal is still sending.\n'
        exit -1
    fi
    
    $FFMPEG -i ${VDEVH264} -r 30 -codec:v copy -f mpegts ${SENDVIDEOURL1} 2> /dev/null > /dev/null ;;

mjpeg)

    # -- USB MJPEG send audio and video in TWO streams (optional set: target-bitrate=10000000) -- #

    # try the current video stream and restart ffmpeg, if problems exists
    trySignal "${STREAMMJPEGURL}" 'yuv420p(progressive), 1920x1080' 'ignore' "${SENDVIDEOURL2}" '/tmp/mjpeg_signal.tmp'
    
    echo 'Send the video from the MJPEG camera, only.'
    
    # stop, if this script is still running
    if [ "`ps awux | grep 'ffmpeg' | grep 'icecast://video:' | grep '/videopipe ' | grep -v grep`" != "" ]
    then
        echo -e '\nERROR: It looks like the video signal is still sending.\n'
        exit -1
    fi

    set -x
    rm -f ~/videopipe
    mkfifo ~/videopipe
    gst-launch-1.0 v4l2src device=${VDEVMJPEG} ! omxh264enc target-bitrate=1400000 control-rate=3 ! filesink location=~/videopipe &
    sleep 10
    $FFMPEG -i ~/videopipe -r 30 -codec:v copy -f mpegts ${SENDVIDEOURL2} 2> /dev/null > /dev/null ;;

audio)

    # -- send audio signal -- #

    # try the current video stream and restart ffmpeg, if problems exists
    trySignal "${STREAMAUDIOURL}" 'ignore' '44100 Hz, mono, ' "${SENDAUDIOURL}" '/tmp/audio_signal.tmp'
    
    echo 'Send the audio signal, only.'   

    # stop, if this process is still running
    if [ "`ps awux | grep 'ffmpeg' | grep 'icecast://audio:' | grep -v grep`" != "" ]
    then
        echo -e '\nERROR: It looks like the audio signal is still sending.\n'
        exit -1
    fi
    
    $FFMPEG -use_wallclock_as_timestamps 1 -f alsa -ac 1 -ar 44100 -i ${ADEVUSB1} -c:a mp3 -ab 128k -f mpegts ${SENDAUDIOURL} 2> /dev/null > /dev/null ;;

esac

exit 0
