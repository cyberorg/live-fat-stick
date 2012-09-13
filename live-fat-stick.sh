#!/bin/bash
# live-fat-stick.sh
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
live-fat-stick.sh isopath stickpartition
e.g.: live-fat-stick.sh /home/geeko/openSUSE-Edu-li-f-e-12.2-1-i686.iso /dev/sdbX
     isopath should be full absolute path of iso image and the device should be 
     actual partition on the stick like /dev/sdb1, /dev/sdc1,/dev/sdc2...
     run fdisk -l to find out the usb stick partition.

     It is It is possible to boot multiple iso images from same stick, 
     should work with all recent openSUSE live iso images. 
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
if [[ ! -e $1 ]]; then
	echo "File $1 does not exist"
	exit
fi
if [[ ! -e $2 ]]; then
        echo "Device $2 does not exist"
        exit
fi

#variables
isomount=/run/tmpisomount
stickmount=/run/tmpstickmount
stickdevice=$(echo $2 | sed 's/[0-9]*//g')
stickbase=$(basename $2)
isoname=$(basename $1)
isonameshort=$(echo $isoname | cut -d "-" -f 1,2,3)
stickuuid=$(ls -l /dev/disk/by-uuid/ |grep $stickbase | cut -d " " -f 9)
stickpart=$(basename $2 | sed 's/[a-z]*//g')

are_you_sure ()  {
        echo  -n "$1 [$2/$3]? "
        while true; do
                read answer
                case $answer in
                        y | Y | yes | YES ) answer="y"; break;;
                        n | N | no | NO ) exit;;
                        *) echo "Please answer yes or no.";;
                esac
        done
}
echo "Please make sure the following information is correct:"
echo "iso name: $isoname stick device: $stickdevice"
echo "stick uuid: /dev/disk/by-uuid/$stickuuid stick partition: $stickpart"
are_you_sure "continue ?" "y" "n"
mkdir $isomount $stickmount &>/dev/null
#umount the stick if it is mounted
umount $2 &>/dev/null || true
mount $1 $isomount
mount $2 $stickmount
if [[ -f $stickmount/fatstick ]]; then
        echo "the stick is already bootable stick"
	if [[ ! -f $stickmount/$isoname ]]; then
	echo "copying kernel and initrd from the $isoname"
	cp $isomount/boot/*/loader/linux $stickmount/boot/syslinux/linux-$isonameshort
	cp $isomount/boot/*/loader/initrd $stickmount/boot/syslinux/initrd-$isonameshort
	echo "adding new image to boot menu"
cat <<EOF >>$stickmount/boot/syslinux/syslinux.cfg

LABEL $isonameshort
        kernel linux-$isonameshort
          append initrd=initrd-$isonameshort ramdisk_size=512000 ramdisk_blocksize=4096 isofrom=/dev/disk/by-uuid/$stickuuid:/$isoname loader=syslinux showopts 

EOF
	fi
else
	echo "installing syslinux on $2"
	syslinux -i $2
	echo "replacing mbr of $stickdevice with syslinux mbr.bin"
	dd if=/usr/share/syslinux/mbr.bin of=$stickdevice &>/dev/null
	echo "setting $stickdevice partition $stickpart active"
	parted $stickdevice set $stickpart boot on &>/dev/null
	echo "copying /boot from iso image to $2"
	cp -r $isomount/boot $stickmount/
	rm $stickmount/syslinux.cfg &>/dev/null
	mv $stickmount/boot/i386/loader $stickmount/boot/syslinux
	mv $stickmount/boot/syslinux/linux $stickmount/boot/syslinux/linux-$isonameshort
	mv $stickmount/boot/syslinux/initrd $stickmount/boot/syslinux/initrd-$isonameshort
	echo "creating menu entries"
	if echo $isoname | grep -qi "Li-f-e"; then
	cat <<EOF >$stickmount/boot/syslinux/syslinux.cfg
implicit 1
prompt   1
timeout  100
display isolinux.msg
ui gfxboot bootlogo isolinux.msg
default openSUSE-Edu-Li-f-e-12.2.1

LABEL openSUSE-Edu-Li-f-e-12.2.1
        kernel linux-$isonameshort
          append initrd=initrd-$isonameshort ramdisk_size=512000 ramdisk_blocksize=4096 isofrom=/dev/disk/by-uuid/$stickuuid:/$isoname loader=syslinux showopts 

label install
  kernel linux-$isonameshort
  append initrd=initrd-$isonameshort ramdisk_size=512000 ramdisk_blocksize=4096 isofrom=/dev/disk/by-uuid/$stickuuid:/$isoname splash=silent quiet liveinstall loader=syslinux showopts

label Gnome
kernel linux-$isonameshort
append initrd=initrd-$isonameshort ramdisk_size=512000 ramdisk_blocksize=4096 isofrom=/dev/disk/by-uuid/$stickuuid:/$isoname splash=silent quiet gnome loader=syslinux showopts

label Cinnamon
kernel linux-$isonameshort
append initrd=initrd-$isonameshort ramdisk_size=512000 ramdisk_blocksize=4096 isofrom=/dev/disk/by-uuid/$stickuuid:/$isoname splash=silent quiet cinnamon loader=syslinux showopts

label harddisk
  localboot 0x80

label memtest
  kernel memtest
EOF
	else
        cat <<EOF >$stickmount/boot/syslinux/syslinux.cfg
implicit 1
prompt   1
timeout  100
display isolinux.msg
ui gfxboot bootlogo isolinux.msg
default $isonameshort

LABEL $isoname
        kernel linux-$isonameshort
          append initrd=initrd-$isonameshort ramdisk_size=512000 ramdisk_blocksize=4096 isofrom=/dev/disk/by-uuid/$stickuuid:/$isoname loader=syslinux showopts 

label harddisk
  localboot 0x80
EOF
	fi
fi
touch $stickmount/fatstick
if [[ ! -f $stickmount/$isoname ]]; then
	echo "copying $1 to usb stick"
	cp $1 $stickmount/
else
	echo "$isoname already exists on the stick, doing nothing"
fi
sync
umount $stickmount $isomount &>/dev/null && rm -rf $stickmount $isomount
echo "Your bootable usb stick is now ready"
echo "have a lot of fun..."
