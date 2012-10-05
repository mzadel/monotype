#!/bin/bash

sudo umount /mnt
if mount | grep -q ' \/mnt ' ; then echo something still mounted, bailing ; exit 1 ; fi
sudo losetup -d /dev/loop{5,4,3,2,1,0}   # clear everything

echo making image
dd if=/dev/zero of=usbimage bs=1M count=50

echo partitioning
sudo losetup /dev/loop0 usbimage
sudo parted /dev/loop0 mklabel msdos
sudo parted /dev/loop0 mkpart primary fat16 1 40
sudo parted /dev/loop0 set 1 boot on

echo making filesystem
sudo losetup --offset 1048576 /dev/loop1 /dev/loop0
sudo mkfs.vfat -F 16 /dev/loop1

echo mounting on /mnt
sudo mount /dev/loop1 /mnt

echo installing grub
sudo grub-install --no-floppy --root-directory=/mnt /dev/loop0   # loop0 is the "disk", and loop1 is the first partition, mounted on /mnt

