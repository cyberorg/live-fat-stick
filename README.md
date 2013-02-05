live-fat-stick
==============
	Create multi boot USB stick with whole iso/s on vfat/fat32 partition

	run this command as root (su -, not sudo)
		live-fat-stick isopath stickpartition
	e.g.: 
		live-fat-stick /home/geeko/openSUSE-Edu-li-f-e-12.2-1-i686.iso /dev/sdXY

	To add Ubuntu iso to the stick, run the following:
		export distroname=ubuntu
		live-fat-stick /path/to/ubuntu-filename.iso /dev/sdXY

        To add Fedora to the stick, run the following:
                export distroname=fedora
                live-fat-stick /path/to/fedora-filename.iso /dev/sdXY

	isopath should be full absolute path of iso image and the device should be 
	actual partition on the stick like /dev/sdb1, /dev/sdc1,/dev/sdc2...

	The stick partition has to be vfat/fat32 format.

	run live-fat-stick -l to list the possible usb sticks available.

        It is possible to boot multiple distributions and iso images from same stick, 
        should work with all recent openSUSE or Ubuntu live iso images. Fedora iso is
        not copied as is but need extracting as it does not support booting from iso.

	You are welcome to fork and submit patches for your distro :)

	Have a lot of fun...
