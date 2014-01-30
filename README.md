live-fat-stick
==============
	Create multi boot USB stick/hard disk with whole iso/s on vfat/fat32 partition
	keeping existing data untouched.

	Note: File size greater than 4G is not usable on vfat/fat32 partition so the
	live CD/DVD iso file should not exceed this limit.

	Note2: Install 32bit/x86 iso on the stick first if creating multiboot with both
	x86 and x86_64 arch images.

	Note3: Requires: syslinux, fuseiso and dd_rescue/ddrescue installed on the system running this.

	Copy live-fat-stick to /usr/bin/ and chmod +x /usr/bin/live-fat-stick

	Run this command as root (su -, not sudo)
		live-fat-stick isopath stickpartition
	e.g.: 
		live-fat-stick /home/geeko/openSUSE-Edu-li-f-e-12.2-1-i686.iso /dev/sdXY

	To add various distribution iso to the stick, run the following:
		For openSUSE	: live-fat-stick --suse /path/to/openSUSE-filename.iso /dev/sdXY
		For Ubuntu	: live-fat-stick --ubuntu /path/to/ubuntu-filename.iso /dev/sdXY
		For Mint	: live-fat-stick --mint /path/to/mint-filename.iso /dev/sdXY
		For Fedora	: live-fat-stick --fedora /path/to/fedora-filename.iso /dev/sdXY
		For isohybrid	: live-fat-stick --isohybrid /path/to/isohybridimage.iso /dev/sdX

	isopath should be full absolute path of iso image and the device should be 
	actual partition on the stick like /dev/sdb1, /dev/sdc1,/dev/sdc2...

	The stick partition has to be vfat/fat32 format if the image is not isohybrid.

	Please note that using isohybrid option will remove all existing data on the USB device
	and create new partitions.

	Run live-fat-stick -l(or --list) to list the possible usb storage devices available.

	openSUSE users can install it via 1-click from here:
	http://software.opensuse.org/package/live-fat-stick

live-usb-gui
==============
	Simple zenity/kdialog based GUI that runs live-fat-stick script

	Copy live-usb-gui to /usr/bin/ and chmod +x /usr/bin/live-usb-gui
	Copy live-usb-gui.desktop to /usr/share/applications/ and update-desktop-database -q
	this should make Live USB GUI show up in desktop menu. 

	Run this command without any options as root from terminal (su -, not sudo) or
	Alt+F2 and xdg-su -c "xterm -e live-usb-gui"

	For iso images processed with isohybrid such as openSUSE installation DVD and UEFI boot support
	and any other Linux distributions select "isohybrid" from distribution selection dialog.

	Please note that USB created using isohybrid mode will be wiped out completely and
	will not be usable from Windows OS, so back up the data from the USB stick before hand.

	openSUSE users can install it via 1-click from here:
	http://software.opensuse.org/package/live-usb-gui

	Note: Requires: live-fat-stick, zenity/kdialog, syslinux and dd_rescue installed 
	on the system running this.


It is possible to boot multiple distributions and iso images from same device, 
should work with all recent openSUSE or Ubuntu live iso images. Fedora iso is
not copied but is extracted as it does not support booting from iso.

You are welcome to fork and submit patches for your distro if it is not supported by 
this script :)

Have a lot of fun...
