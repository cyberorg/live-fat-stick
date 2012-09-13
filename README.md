live-fat-stick
==============

Create bootable live usb stick on fat partition, boots iso images

Run the script as root:
live-fat-stick.sh /path/to/someopensuse.iso /dev/sdXY

Where X is the usb stick device, and Y is the fat partition on that stick, e.g. /dev/sdb1

It is possible to boot multiple iso images from same stick, should work with all recent openSUSE live iso images. 
