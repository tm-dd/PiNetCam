[Unit]
Description=send video from the MJPEG usb camera
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/pinetcam/send_webcam.sh mjpeg 2> /dev/null > /dev/null
Restart=always
RestartSec=10s
User=pi
Group=pi

[Install]
WantedBy=multi-user.target
