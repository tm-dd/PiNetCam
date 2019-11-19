# pinetcam
Use Raspberry Pis to broadcast an event, like an worship.

![example hardware plan](/Example_hardware_plan_PiNetCam.png)

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

Thomas Mueller <><
