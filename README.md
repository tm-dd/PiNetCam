# pinetcam
Use Raspberry Pis to broadcast an event, like an worship.

![example hardware plan](/usr/local/pinetcam/example_files/Example_hardware_plan_PiNetCam.png)

This scripts was created to use an Raspberry Pi to send the video and audio signal from a 
worship in my christian church to other clients (which are using Raspberry Pis also) and to record the worship.

On the sending side, the Raspberry Pi (3B+) use the following hardware:
  - a H.264 usb camera: https://www.amazon.de/gp/product/B07PPRKFPR/
  - an usb sound card

On the sending side, the Raspberry Pi (3B+) need the following software:
  - Raspian (based ob debian 9)
  - ffmpeg
  - icecast2
  - gstreamer to use the GPU hardware encoder for the MJEPG camera

The clients also use Raspberry Pis (3B+) to show the video signal in the same network.

An other computer record the signal of the worship.

The setup and the signal to use the H.264 usb camera is much easier and better, than the MJEPG camera.
I prefer to use only H.264 usb cameras with this scripts.

Feel free to use the scripts on your worships and give me an note, if it works or not.
Also feel free to help to make the scripts better.

# installation

1. Install Raspian on an Raspberry Pi 3B+ or 4 as server. Install Raspian on other Raspberry Pis als clients.
2. Install and configure icecast2 and ffmpeg on the server. Maybe I will upload some example files, later.
3. Download and install all files from here on the server and clients.
4. Change the configuration file (/usr/local/pinetcam/config.cfg) on all Rasperry Pis. Fill out the values. Mail and recording settings can be ignored, if not necessary for you.
5. Enable "/etc/systemd/system/\*-webcam-\*.service" on the clients and the server.
6. For MJPEG USB cameras you need to find and install a GPU based gst-launch-1.0 package. This can take some extra time.
7. Try and use this services and send me an information if it works or not.

Thomas Mueller <><
