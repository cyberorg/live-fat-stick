#!/bin/bash
# create-bootable-fat-stick.sh
#
# Copyright (c) 2012 CyberOrg Info
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
#
# Authors:      Jigish Gohil <cyberorg@opensuse.org>
# This script creates bootable openSUSE live usb stick on fat partition
#
need_help() {
	cat <<EOF
run this command as root
create-bootable-fat-stick.sh isopath stickpartition
e.g.: create-bootable-fat-stick.sh /home/geeko/openSUSE-Edu-li-f-e-12.2-1-i686.iso /dev/sdbX
     isopath should be full absolute path of iso image and the device should be 
     actual partition on the stick like /dev/sdb1, /dev/sdc1,/dev/sdc2...
     run fdisk -l to find out the usb stick partition.
EOF
}

if [[ x"$USER" != x"root" ]]; then
	echo "run this command as root"
	need_help
	exit
fi
if [[ x"$1" == x ]]; then
	echo "Requires first arguement as iso image path"
	need_help
	exit
fi
if [[ x"$2" == x ]]; then
	echo "Requires second arguement as device partition path, /dev/sdb1 for example"
	need_help
	exit
fi
if [[ ! -e /usr/bin/syslinux ]]; then
	echo "syslinux not found, please install syslinux package"
	exit
fi
isomount=/run/tmpisomount
stickmount=/run/tmpstickmount
stickdevice=$(echo $2 | sed 's/[0-9]*//g')
stickbase=$(basename $2)
isoname=$(basename $1)
stickuuid=$(ls -l /dev/disk/by-uuid/ |grep $stickbase | cut -d " " -f 9)
stickpart=$(basename $2 | sed 's/[a-z]*//g')
echo "isomount: $isomount stickmount: $stickmount stickdevice: $stickdevice stickbase: $stickbase isoname: $isoname stickuuid: $stickuuid stickpart: $stickpart"
syslinux -i $2
dd if=/usr/share/syslinux/mbr.bin of=$stickdevice
parted $stickdevice set $stickpart boot on
mkdir $isomount $stickmount
umount $2
mount $1 $isomount
mount $2 $stickmount
if [[ -f $stickmount/fatstick ]]; then
        echo "the stick is already bootable stick, adding new image to boot menu"
cat <<EOF >>$stickmount/syslinux.cfg

LABEL $isoname
        kernel boot/i386/loader/linux
          append initrd=boot/i386/loader/initrd ramdisk_size=512000 ramdisk_blocksize=4096 isofrom=/dev/disk/by-uuid/$stickuuid:/$isoname showopts 

EOF
else
	cp -r $isomount/boot $stickmount/
	cp /usr/share/syslinux/vesamenu.c32 $stickmount/
	cp /srv/tftpboot/thin.png $stickmount/background.png || true
	cat <<EOF >$stickmount/syslinux.cfg
default vesamenu.c32
MENU BACKGROUND background.png 
MENU TITLE Welcome to openSUSE Edu Li-f-e
MENU WIDTH 65
MENU MARGIN 15
MENU ROWS 12
MENU TABMSGROW 18
MENU CMDLINEROW 12
MENU ENDROW 24
MENU TIMEOUTROW 20
ONTIMEOUT openSUSE-Edu-Li-f-e-12.2.1

ALLOWOPTIONS 0
PROMPT 0
IMPLICIT 1
OPTIONS 1
TIMEOUT 50

LABEL openSUSE-Edu-Li-f-e-12.2.1
        kernel boot/i386/loader/linux
          append initrd=boot/i386/loader/initrd ramdisk_size=512000 ramdisk_blocksize=4096 isofrom=/dev/disk/by-uuid/$stickuuid:/$isoname showopts 

label install
  kernel boot/i386/loader/linux
  append initrd=boot/i386/loader/initrd ramdisk_size=512000 ramdisk_blocksize=4096 isofrom=/dev/disk/by-uuid/$stickuuid:/$isoname splash=silent quiet liveinstall showopts

label Gnome
kernel boot/i386/loader/linux
append initrd=boot/i386/loader/initrd ramdisk_size=512000 ramdisk_blocksize=4096 isofrom=/dev/disk/by-uuid/$stickuuid:/$isoname splash=silent quiet gnome showopts

label Cinnamon
kernel boot/i386/loader/linux
append initrd=boot/i386/loader/initrd ramdisk_size=512000 ramdisk_blocksize=4096 isofrom=/dev/disk/by-uuid/$stickuuid:/$isoname splash=silent quiet cinnamon showopts

label harddisk
  localboot 0x80

label memtest
  kernel boot/i386/loader/memtest
EOF
fi
touch $stickmount/fatstick
cp $1 $stickmount/
umount $stickmount $isomount && rm -rf $stickmount $isomount

