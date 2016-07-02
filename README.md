live-fat-stick
==============
	Create multi boot USB stick/hard disk with whole iso/s on vfat/fat32 partition
	keeping existing data untouched.

	Note: File size greater than 4G is not usable on vfat/fat32 partition so the
	live CD/DVD iso file should not exceed this limit.

	Note2: Install 32bit/x86 iso on the stick first if creating multiboot with both
	x86 and x86_64 arch images.

	Note3: Requires: syslinux, fuseiso, qemu-img and dd_rescue/ddrescue installed on the system running this.

	Copy live-fat-stick to /usr/bin/ and chmod +x /usr/bin/live-fat-stick

	Run this command as root (su -, not sudo)
		live-fat-stick isopath stickpartition
	e.g.: 
		live-fat-stick /home/geeko/openSUSE-Edu-li-f-e-12.2-1-i686.iso /dev/sdXY

	To add various distribution iso to the stick, run the following:
		For openSUSE	: live-fat-stick --suse /path/to/openSUSE-filename.iso /dev/sdXY
                For openSUSE with persistence    : live-fat-stick --suse-persistent /path/to/openSUSE-filename.iso /dev/sdXY
                For Ubuntu clones     : live-fat-stick --ubuntu /path/to/ubuntu-filename.iso /dev/sdXY
                For Ubuntu clones with persistence      : live-grub-stick --ubuntu-persistent /path/to/ubuntu-filename.iso /dev/sdXY
		For Mint	: live-fat-stick --mint /path/to/mint-filename.iso /dev/sdXY
		For Fedora	: live-fat-stick --fedora /path/to/fedora-filename.iso /dev/sdXY
		For iPXE        : live-fat-stick --ipxe /path/to/ipxe.iso /dev/sdXY

		For isohybrid	: live-fat-stick --isohybrid /path/to/isohybridimage.iso /dev/sdX

	isopath should be full absolute path of iso image and the device should be 
	actual partition on the stick like /dev/sdb1, /dev/sdc1,/dev/sdc2...

	The stick partition has to be vfat/fat32 format if the image is not isohybrid.

	Please note that using isohybrid option will remove all existing data on the USB device
	and create new partitions.

	Run live-fat-stick -l(or --list) to list the possible usb storage devices available.

	openSUSE users can install it via 1-click from here:
	http://software.opensuse.org/package/live-fat-stick

live-grub-stick
==============
	Create multi boot USB stick/hard disk with whole iso/s on any partition supported by grub2
	keeping existing data untouched. This tool uses grub2 instead of syslinux to
	achieve the same goal as live-fat-stick.

	Note: File size greater than 4G is not usable on vfat/fat32 partition so the
	live CD/DVD iso file should not exceed this limit. Use any other grub2 supported filesystem
	if the iso file exceeds this limit.

	Note2: Install 32bit/x86 iso on the stick first if creating multiboot with both
	x86 and x86_64 arch images.

	Note3: Requires: grub2, fuseiso, qemu-img and dd_rescue/ddrescue installed on the system running this.

	Run this command as root (su -, not sudo)
                live-grub-stick isopath stickpartition
	e.g.: 
                live-grub-stick /home/geeko/openSUSE-Edu-li-f-e-12.2-1-i686.iso /dev/sdXY

	To add various distribution iso to the stick, run the following:
		For openSUSE    : live-grub-stick --suse /path/to/openSUSE-filename.iso /dev/sdXY
                For openSUSE with persistence    : live-grub-stick --suse-persistent /path/to/openSUSE-filename.iso /dev/sdXY
                For Ubuntu clones     : live-grub-stick --ubuntu /path/to/ubuntu-filename.iso /dev/sdXY
                For Ubuntu clones with persistence      : live-grub-stick --ubuntu-persistent /path/to/ubuntu-filename.iso /dev/sdXY
		For Mint        : live-grub-stick --mint /path/to/mint-filename.iso /dev/sdXY
		For Fedora      : live-grub-stick --fedora /path/to/fedora-filename.iso /dev/sdXY
		For iPXE        : live-grub-stick --ipxe /path/to/ipxe.iso /dev/sdXY

		For isohybrid   : live-grub-stick --isohybrid /path/to/isohybridimage.iso /dev/sdX

	isopath should be full absolute path of iso image and the device should be 
	actual partition on the stick like /dev/sdb1, /dev/sdc1,/dev/sdc2...

	The stick partition has to be in a format supported by grub2 and the OS image if the image
	is not isohybrid.

	Please note that using isohybrid option will remove all existing data on the USB device
	and create new partitions.

	Run live-grub-stick -l(or --list) to list the possible usb storage devices available.

        openSUSE users can install it via 1-click from here:
        http://software.opensuse.org/package/live-grub-stick


live-usb-gui
==============
	Simple zenity/kdialog based GUI that runs live-fat-stick or live-grub-stick script

	Copy live-usb-gui to /usr/bin/ and chmod +x /usr/bin/live-usb-gui
	Copy live-usb-gui.desktop to /usr/share/applications/ and update-desktop-database -q
	this should make Live USB GUI show up in desktop menu. 

	On Ubuntu or distributions that do not have xdg-su, change Exec=xdg-su -c "live-usb-gui"
	to Exec=gksudo "live-usb-gui" in live-usb-gui.desktop. Use any xdg-su equivalent command
	available.

	Run this command without any options as root from terminal (su -, not sudo) or
	Alt+F2 and xdg-su -c "xterm -e live-usb-gui"

	For iso images processed with isohybrid such as openSUSE installation DVD and UEFI boot support
	and any other Linux distributions select "isohybrid" from distribution selection dialog.

	Please note that USB created using isohybrid mode will be wiped out completely and
	will not be usable from Windows OS, so back up the data from the USB stick before hand.

	openSUSE users can install it via 1-click from here:
	http://software.opensuse.org/package/live-usb-gui

	Note: Requires: live-fat-stick or live-grub-stick, zenity/kdialog, syslinux and dd_rescue installed 
	on the system running this.


It is possible to boot multiple distributions and iso images from same device, 
should work with all recent distributions' live iso images. Fedora iso is
not copied when live-fat-stick is used but is extracted, when live-grub-stick is used all isos are copied. 

You are welcome to fork and submit patches for your distro if it is not supported by 
this script :)

Cross platform alternative with GUI to these tools: https://github.com/mbusb/multibootusb

Have a lot of fun...
