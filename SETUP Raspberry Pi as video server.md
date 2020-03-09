# SETUP THE PINETCAM SERVER (VIDEO STATION) #

    This is a simple example setup of the PI as webcam.
    I use an USB sound card AND a h264 USB camera.

    Copyright (C) 2017 Thomas Mueller <developer@mueller-dresden.de>
    
    This code is free software. You can use, redistribute and/or
    modify it under the terms of the GNU General Public Licence
    version 2, as published by the Free Software Foundation.
    This program is distributed without any warranty.
    See the GNU General Public Licence for more details.

## EXAMPLE CONFIGURATION ##

    IP: 192.168.1.2
    Icecast accounts passwords: CHANGE ME PLEASE
    login for sending the signal to icecast: send
    password for sending the signal to icecast: sendingTheWorship
    login for view the signal from the pi: listen
    password for view the signal from the pi: listeningTheWorship
    h264 camera device: /dev/video2          # use /usr/local/pinetcam/search_audio_and_video_devices.sh to find the name
    usb audio device: hw:CARD=Device,DEV=0   # use /usr/local/pinetcam/search_audio_and_video_devices.sh to find the name

## ICECAST2 SERVER ##

### INSTALL AND SETUP ICECAST2 ###

    pi@raspberrypi:~ $ sudo apt install icecast2 vim

        Configure Icecast2?  ->  <No>

    pi@raspberrypi:~ $ sudo cp -a /etc/icecast2/icecast.xml /etc/icecast2/icecast.xml.org
    pi@raspberrypi:~ $ sudo vim /etc/icecast2/icecast.xml
    pi@raspberrypi:~ $ sudo cat /etc/icecast2/icecast.xml
    <icecast>
        <location>Your City</location>
        <admin>Your Name - user@example.org</admin>
        <limits>
            <clients>100</clients>
            <sources>5</sources>
            <queue-size>524288</queue-size>
            <client-timeout>20</client-timeout>
            <header-timeout>15</header-timeout>
            <source-timeout>10</source-timeout>
            <!-- If enabled, this will provide a burst of data when a client 
                 first connects, thereby significantly reducing the startup 
                 time for listeners that do substantial buffering. However,
                 it also significantly increases latency between the source
                 client and listening client.  For low-latency setups, you
                 might want to disable this. -->
            <burst-on-connect>0</burst-on-connect>
            <!-- same as burst-on-connect, but this allows for being more
                 specific on how much to burst. Most people won't need to
                 change from the default 64k. Applies to all mountpoints  -->
            <burst-size>0</burst-size>
        </limits>
    
        <authentication>
            <source-password>CHANGE ME PLEASE</source-password>
            <relay-password>CHANGE ME PLEASE</relay-password>
            <admin-user>admin</admin-user>
            <admin-password>CHANGE ME PLEASE</admin-password>
        </authentication>
    
        <hostname>pinetcam</hostname>
    
        <listen-socket>
            <port>8000</port>
        </listen-socket>
    
        <http-headers>
            <header name="Access-Control-Allow-Origin" value="*" />
        </http-headers>
    
        <mount>
                <mount-name>/audio.mp3</mount-name>
                <hidden>1</hidden>
                <max-listeners>100</max-listeners>
                <username>send</username>
                <password>sendingTheWorship</password>
                <authentication type="htpasswd">
                        <!-- in the following file you have to put the login and password to allow streaming --> 
                        <option name="filename" value="/etc/icecast2/htpasswd.clients"/>
                        <option name="allow_duplicate_users" value="1"/>
                </authentication>
        </mount>
        
        <mount>
                <mount-name>/video_h264.mp4</mount-name>
                <hidden>1</hidden>
                <max-listeners>100</max-listeners>
                <username>send</username>
                <password>sendingTheWorship</password>
                <authentication type="htpasswd">
                        <!-- in the following file you have to put the login and password to allow streaming --> 
                        <option name="filename" value="/etc/icecast2/htpasswd.clients"/>
                        <option name="allow_duplicate_users" value="1"/>
                </authentication>
        </mount>
        
        <mount>
                <mount-name>/video_mjpeg.mp4</mount-name>
                <hidden>1</hidden>
                <max-listeners>100</max-listeners>
                <username>send</username>
                <password>sendingTheWorship</password>
                <authentication type="htpasswd">
                        <!-- in the following file you have to put the login and password to allow streaming --> 
                        <option name="filename" value="/etc/icecast2/htpasswd.clients"/>
                        <option name="allow_duplicate_users" value="1"/>
                </authentication>
        </mount>
        
        <fileserve>1</fileserve>
    
        <paths>
            <basedir>/usr/share/icecast2</basedir>
            <logdir>/var/log/icecast2</logdir>
            <webroot>/usr/share/icecast2/web</webroot>
            <adminroot>/usr/share/icecast2/admin</adminroot>
            <alias source="/" destination="/status.xsl"/>
        </paths>
    
        <logging>
            <accesslog>access.log</accesslog>
            <errorlog>error.log</errorlog>
            <loglevel>3</loglevel>
            <logsize>10000</logsize>
        </logging>
    
        <security>
            <chroot>0</chroot>
        </security>
    </icecast>
    
    pi@raspberrypi:~ $ 

    pi@raspberrypi:~ $ sudo reboot

### SETUP THE CLIENT PASSWORDS ###
    
        pi@raspberrypi:~ $ sudo -i
        root@raspberrypi:~# echo -n 'listeningTheWorship' | md5sum | awk '{ print "listen:" $1 }' > /etc/icecast2/htpasswd.clients
    
    WARNING: Better do not use special symbols in the password.

### ENABLE ICECAST2 SERVICE AFTER REBOOTING ###

    pi@raspberrypi:~ $ sudo systemctl status icecast2
    ● icecast2.service - LSB: Icecast2 streaming media server
       Loaded: loaded (/etc/init.d/icecast2; generated)
       Active: inactive (dead)
         Docs: man:systemd-sysv-generator(8)
    pi@raspberrypi:~ $ sudo systemctl enable icecast2
    icecast2.service is not a native service, redirecting to systemd-sysv-install.
    Executing: /lib/systemd/systemd-sysv-install enable icecast2
    pi@raspberrypi:~ $
    
    pi@raspberrypi:~ $ sudo reboot
    
    pi@raspberrypi:~ $ sudo systemctl status icecast2
    ● icecast2.service - LSB: Icecast2 streaming media server
       Loaded: loaded (/etc/init.d/icecast2; generated)
       Active: active (running) since Mon 2020-03-09 21:23:12 GMT; 8s ago
         Docs: man:systemd-sysv-generator(8)
      Process: 514 ExecStart=/etc/init.d/icecast2 start (code=exited, status=0/SUCCESS)
        Tasks: 7 (limit: 4035)
       Memory: 13.5M
       CGroup: /system.slice/icecast2.service
               └─524 /usr/bin/icecast2 -b -c /etc/icecast2/icecast.xml
    
    Mar 09 21:23:12 raspberrypi systemd[1]: Starting LSB: Icecast2 streaming media server...
    Mar 09 21:23:12 raspberrypi icecast2[514]: Starting streaming media server: icecast2.
    Mar 09 21:23:12 raspberrypi systemd[1]: Started LSB: Icecast2 streaming media server.
    Mar 09 21:23:12 raspberrypi icecast2[514]: [2020-03-09  21:23:12] WARN auth/auth_get_authenticator unknown auth setting (comment)
    Mar 09 21:23:12 raspberrypi icecast2[514]: [2020-03-09  21:23:12] WARN auth/auth_get_authenticator unknown auth setting (comment)
    Mar 09 21:23:12 raspberrypi icecast2[514]: [2020-03-09  21:23:12] WARN auth/auth_get_authenticator unknown auth setting (comment)
    pi@raspberrypi:~ $ 


## INSTALL AND SETUP FFMPEG AND PINETCAM ##
    
    pi@raspberrypi:~ $ sudo apt install ffmpeg
    pi@raspberrypi:~ $ sudo apt install git

### GET AND INSTALL SCRIPTS ###

    pi@raspberrypi:~ $ git clone https://github.com/tm-dd/PiNetworkCamera
    Cloning into 'PiNetworkCamera'...
    remote: Enumerating objects: 74, done.
    remote: Counting objects: 100% (74/74), done.
    remote: Compressing objects: 100% (63/63), done.
    remote: Total 74 (delta 22), reused 0 (delta 0), pack-reused 0
    Unpacking objects: 100% (74/74), done.
    pi@raspberrypi:~ $

    pi@raspberrypi:~ $ sudo mv PiNetworkCamera/usr/local/pinetcam /usr/local/
    pi@raspberrypi:~ $ sudo chmod 755 /usr/local/pinetcam/*.sh

### FIND AUDIO AND VIDEO DEVICES ###

    pi@raspberrypi:~ $ /usr/local/pinetcam/search_audio_and_video_devices.sh
    
    audio devices:
    
    hw:CARD=Camera,DEV=0
        H264 USB Camera, USB Audio
        Direct hardware device without any conversions
    plughw:CARD=Camera,DEV=0
        H264 USB Camera, USB Audio
        Hardware device with all software conversions
    --
    hw:CARD=Device,DEV=0
        USB PnP Sound Device, USB Audio
        Direct hardware device without any conversions
    plughw:CARD=Device,DEV=0
        USB PnP Sound Device, USB Audio
        Hardware device with all software conversions
    
    press Enter to continue ...
    
    video devices:
    
    try /dev/video0:
    [STREAM]
    index=0
    codec_name=rawvideo
    codec_long_name=raw video
    ...
    width=800
    height=600
    ...
    
    try /dev/video2:
    [STREAM]
    index=0
    codec_name=h264
    codec_long_name=H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10
    ...
    width=1920
    height=1080
    ...
    
    try /dev/video3:
    [video4linux2,v4l2 @ 0x6ada00] ioctl(VIDIOC_G_INPUT): Inappropriate ioctl for device
    /dev/video3: Inappropriate ioctl for device
    
    pi@raspberrypi:~ $ 

### SETUP THE CONFIG OF THE SCRIPTS ###

    pi@raspberrypi:~ $ sudo vim /usr/local/pinetcam/config.cfg 
    pi@raspberrypi:~ $ sudo cat /usr/local/pinetcam/config.cfg 
    #
    # Copyright (C) 2019 Thomas Mueller <developer@mueller-dresden.de>
    #
    # This code is free software. You can use, redistribute and/or
    # modify it under the terms of the GNU General Public Licence
    # version 2, as published by the Free Software Foundation.
    # This program is distributed without any warranty.
    # See the GNU General Public Licence for more details.
    #
    
    #
    # settings for the webcam scripts
    #
    
    # settings to send system information by mail
    MAILTO='user@example.net'
    MAILFROM='pi@example.net'
    MAILSMTPSERVER='smtp@example.net'
    MAILLOGIN='smtp-login'
    MAILPASSWORD='smtp-password'
    MAILSUBJECT='System information RaspberryPi - '`date`
    
    # a system log file
    SYSLOGFILE=/var/log/sysstatus.txt
    
    # append the path to allow running in automaic processes
    PATH=$PATH:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/bin:/opt/macports/2.3.4/bin
    
    # the path to ffmpeg binaries (to be sure after installing updates, you CAN use an static compiled version)
    # FFMPEG='/usr/local/ffmpeg-4.1.3-armhf-static/ffmpeg'
    # FFPROBEBIN='/usr/local/ffmpeg-4.1.3-armhf-static/ffprobe'
    FFMPEG='/usr/bin/ffmpeg'
    FFPROBEBIN='/usr/bin/ffprobe'
    
    # Define the seconds to wait after a reboot, before the hardware can be used to capture.
    MINUPTIMESEC=120
    
    # Settings to send the signal to an local icecast2 server
    SENDLOGIN='send'
    SENDPASSWORD='sendingTheWorship'
    SENDIP='localhost'
    SENDPORT='8000'
    SENDAUDIOFILENAME='audio.mp3'
    SENDH264FILENAME='video_h264.mp4'
    SENDMJPEGFILENAME='video_mjpeg.mp4'
    SENDAUDIOURL='icecast://'${SENDLOGIN}':'${SENDPASSWORD}'@'${SENDIP}':'${SENDPORT}'/'${SENDAUDIOFILENAME}
    SENDVIDEOURL1='icecast://'${SENDLOGIN}':'${SENDPASSWORD}'@'${SENDIP}':'${SENDPORT}'/'${SENDH264FILENAME}
    SENDVIDEOURL2='icecast://'${SENDLOGIN}':'${SENDPASSWORD}'@'${SENDIP}':'${SENDPORT}'/'${SENDMJPEGFILENAME}
    VDEVMJPEG='/dev/video0'                                   # MJEPG usb camera (try with: ffprobe -v error -show_format -show_streams /dev/video*)
    VDEVH264='/dev/video2'                                    # H.264 usb camera (try with: ffprobe -v error -show_format -show_streams /dev/video*)
    ADEVH264='plughw:CARD=Camera,DEV=0'                       # internal sound card of H.264-Webcam (maybe without audio and video sync) (search with: arecord -L | grep -A 2 'hw:')
    ADEVUSB1='hw:CARD=Device,DEV=0'                           # use the USB sound card for the audio signal (search with: arecord -L | grep -A 2 'hw:')
    ADEVUSB2='hw:CARD=Device_1,DEV=0'                         # search with: arecord -L | grep -A 2 'hw:'
    
    # Settings to listen/view the audio/video signal
    STREAMLOGIN='listen'
    STREAMPASSWORD='listeningTheWorship'
    STREAMIP='192.168.1.2'
    STREAMPORT='8000'
    STREAMAUDIOFILENAME='audio.mp3'
    STREAMH264FILENAME='video_h264.mp4'
    STREAMMJPEGFILENAME='video_mjpeg.mp4'
    STREAMAUDIOURL='http://'${STREAMLOGIN}':'${STREAMPASSWORD}'@'${STREAMIP}':'${STREAMPORT}'/'${STREAMAUDIOFILENAME}
    STREAMH264URL='http://'${STREAMLOGIN}':'${STREAMPASSWORD}'@'${STREAMIP}':'${STREAMPORT}'/'${STREAMH264FILENAME}
    STREAMMJPEGURL='http://'${STREAMLOGIN}':'${STREAMPASSWORD}'@'${STREAMIP}':'${STREAMPORT}'/'${STREAMMJPEGFILENAME}
    
    # audio offset time (to synchronize the audio and video input)
    AOFFSET=-0.5
    
    # settings to record the video
    VIDEOTEMPDIR='/Volumes/DATA/tmp/video_h264'
    VIDEOTARGETDIR='/Volumes/DATA/Worships/records'
    VIDEOFILENAME='video.mp4'
    TEMPRECORDSCRIPT='/tmp/wget_h264_video'
    STREAMRECORDURL=${STREAMH264URL}
    RECORDLOGFILE='/tmp/h264_wget_video.log'
    VIDEONAME='Worship'
    FFMPEGCONVERTSETTINGS='-c:v libx264 -preset medium -crf 23 -c:a aac -b:a 128k'
    pi@raspberrypi:~ $

### FIRST TRY ###

#### SEND THE VIDEO CAMERA ###

    pi@raspberrypi:~ $ sudo /usr/local/pinetcam/send_webcam.sh h2641
    ---
    Mon  9 Mar 21:41:04 GMT 2020
    Send the audio and video as one stream from the H.264 camera.
    Trying streaming signal ...
    ERROR ON VIDEO SIGNAL.
    ERROR ON AUDIO SIGNAL.
    Restart of all ffmpeg processes, because there is a problem with the signal.

#### VIEW THE CAMERA ####

    sh-3.2$ ffplay http://listen:listeningTheWorship@192.168.1.2:8000/video_h264.mp4

    Quicktime Player -> File -> Open Location... -> Movie Location: http://listen:listeningTheWorship@192.168.1.2:8000/video_h264.mp4

    Pleae note: Quicktime and omxplayer works stable. ffplay stops playing after a few seconds.

### ENABLE THE WEBCAM ###
    
    pi@raspberrypi:~ $ sudo mv PiNetworkCamera/etc/systemd/system/send-webcam-h264* /etc/systemd/system/
    pi@raspberrypi:~ $ sudo systemctl enable send-webcam-h2641.service
    Created symlink /etc/systemd/system/multi-user.target.wants/send-webcam-h2641.service → /etc/systemd/system/send-webcam-h2641.service.
    pi@raspberrypi:~ $ sudo systemctl start send-webcam-h2641.service

    Notes: The video should be work two or three minutes after rebooting. You can try th change "MINUPTIMESEC" in the config.cfg .


Thomas Mueller <><
