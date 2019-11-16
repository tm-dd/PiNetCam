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

# delete old files
mkdir -p ${VIDEOTARGETDIR} ${VIDEOTEMPDIR}
rm -f ${VIDEOTEMPDIR}/* ${RECORDLOGFILE}
cd ${VIDEOTEMPDIR} || exit -1
df -h .

# start recording in a temporary script
rm -f ${RECORDLOGFILE}
echo "PATH="${PATH} > ${TEMPRECORDSCRIPT}
echo "cd ${VIDEOTEMPDIR}" >> ${TEMPRECORDSCRIPT}
echo 'while [ 1 ]' >> ${TEMPRECORDSCRIPT}
echo 'do ' >> ${TEMPRECORDSCRIPT}
echo "   wget ${STREAMRECORDURL} > /dev/null 2> /dev/null" >> ${TEMPRECORDSCRIPT}
echo "   echo -n 'temporary recording problem at time ' >> ${RECORDLOGFILE}; date >> ${RECORDLOGFILE}; echo >> ${RECORDLOGFILE} " >> ${TEMPRECORDSCRIPT}
echo "   sleep 5" >> ${TEMPRECORDSCRIPT}
echo 'done' >> ${TEMPRECORDSCRIPT}
/bin/bash ${TEMPRECORDSCRIPT}

# wait a moment to save the temporary videos files
sleep 30

# convert the video files (double ffmpeg was necessary, because without "-c copy" the converting don't stop in normal time)
(ls -lh ${VIDEOTEMPDIR}; echo; cat ${RECORDLOGFILE}) | mail -s "starting converting video(s)" ${MAILTO}
set -x
DATE=`date "+%Y-%m-%d"`
NR=`ls -l "${VIDEOTARGETDIR}" | grep "${VIDEONAME}_${DATE}_part_" 2> /dev/null | wc -l`
NR=$(($NR+1))
set +x
for i in *.mp4*
do
	(set -x ; pwd ; ${FFMPEG} -i $i -c copy "${i}_tmp.mp4" ; ${FFMPEG} -y -i "${i}_tmp.mp4" ${FFMPEGCONVERTSETTINGS} "${VIDEOTARGETDIR}/${VIDEONAME}_${DATE}_part_${NR}.mp4" ; rm -f "${i}_tmp.mp4")
	NR=$((${NR}+1))
done
chmod 644 ${VIDEOTARGETDIR}/*.mp4
ls -lh "${VIDEOTARGETDIR}/${VIDEONAME}_${DATE}_part_"* | mail -s "converting ${VIDEONAME} finished" ${MAILTO}

exit 0
