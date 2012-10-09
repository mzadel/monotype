#!/bin/bash

sudo umount /mnt
if mount | grep -q ' \/mnt ' ; then echo something still mounted, bailing ; exit 1 ; fi

echo making initrd
sudo ./mkinitramfs -o initrd.gz $(uname -r)

echo making image
dd if=/dev/zero of=monotype.img bs=1M count=20

echo partitioning
USBDEVICELOOPBACK=$(sudo losetup -f)
sudo losetup $USBDEVICELOOPBACK monotype.img
sudo parted $USBDEVICELOOPBACK mklabel msdos
sudo parted $USBDEVICELOOPBACK mkpart primary fat16 1 100%
sudo parted $USBDEVICELOOPBACK set 1 boot on

echo making filesystem
FATFILESYSTEMLOOPBACK=$(sudo losetup -f)
sudo losetup --offset 1048576 $FATFILESYSTEMLOOPBACK $USBDEVICELOOPBACK
sudo mkfs.vfat -F 16 -n writer $FATFILESYSTEMLOOPBACK

echo mounting on /mnt
sudo mount $FATFILESYSTEMLOOPBACK /mnt

echo generating buildinfo file
MONOTYPEVERSION=monotype-$(date +%Y%m%d)-git$(git rev-parse --short HEAD)
echo $MONOTYPEVERSION > buildinfo.txt
echo built "$(date)" >> buildinfo.txt
uname -srv >> buildinfo.txt
echo debian version $(cat /etc/debian_version) >> buildinfo.txt

echo installing syslinux
sudo mkdir /mnt/syslinux
sudo syslinux -i -d syslinux $FATFILESYSTEMLOOPBACK  # onto the *first partition*
sudo dd conv=notrunc bs=440 count=1 if=/usr/lib/syslinux/mbr.bin of=$USBDEVICELOOPBACK  # bootstrap code for syslinux

echo copying files to image
sudo cp /boot/vmlinuz-$(uname -r) /mnt/syslinux/vmlinuz
sudo cp initrd.gz /mnt/syslinux/initrd.gz
sudo cp -r usbkeyfiles/* /mnt
sudo cp buildinfo.txt /mnt
sudo sync

echo cleaning up
sudo umount /mnt
sudo losetup -d $FATFILESYSTEMLOOPBACK
sudo losetup -d $USBDEVICELOOPBACK

echo done

