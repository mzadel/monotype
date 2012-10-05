#!/bin/bash

sudo umount /mnt
if mount | grep -q ' \/mnt ' ; then echo something still mounted, bailing ; exit 1 ; fi
sudo losetup -d /dev/loop{5,4,3,2,1,0}   # clear everything

echo making image
dd if=/dev/zero of=usbimage bs=1M count=20

echo partitioning
sudo losetup /dev/loop0 usbimage
sudo parted /dev/loop0 mklabel msdos
sudo parted /dev/loop0 mkpart primary fat16 1 100%
sudo parted /dev/loop0 set 1 boot on

echo making filesystem
sudo losetup --offset 1048576 /dev/loop1 /dev/loop0
sudo mkfs.vfat -F 16 /dev/loop1

echo mounting on /mnt
sudo mount /dev/loop1 /mnt

#echo installing grub
#sudo grub-install --no-floppy --root-directory=/mnt /dev/loop0   # loop0 is the "disk", and loop1 is the first partition, mounted on /mnt

echo installing syslinux
sudo mkdir /mnt/syslinux
sudo syslinux -i -d syslinux /dev/loop1  # onto the *first partition*
sudo dd conv=notrunc bs=440 count=1 if=/usr/lib/syslinux/mbr.bin of=/dev/loop0  # bootstrap code for syslinux
sudo cp /boot/vmlinuz-2.6.32-5-amd64 /mnt/syslinux/vmlinuz
sudo cp zadelinitrd.gz /mnt/syslinux/initrd.gz
sudo cp syslinux.cfg /mnt/syslinux
sudo sync

echo cleaning up
sudo umount /mnt
sudo losetup -d /dev/loop{1,0}

echo done

