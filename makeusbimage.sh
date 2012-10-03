
# need to do this all as root

dd if=/dev/zero of=usbimage bs=1M count=50
# need to partition it, so use losetup to bind the file to a loopback device first then partition that
# then bind another loopback device to the first partition and make a filesystem
# then install grub on it

sudo losetup  -f
sudo losetup /dev/loop0 usbimage
sudo fdisk /dev/loop0
sudo fdisk -ul /dev/loop0  # to check the offset of the first partition
sudo losetup --offset 32256 /dev/loop1 /dev/loop0
sudo mkfs.vfat -F 16 /dev/loop1
sudo mount /dev/loop1 /mnt
sudo grub-install --no-floppy --root-directory=/mnt /dev/loop0


# mkfs.vfat -F 32 -n writer -I /dev/loop1   # if /dev/loop1 has been mapped to the first partition

# then go
sudo grub-install --no-floppy --root-directory=/mnt /dev/loop0
cd /mnt/boot/grub

make a grub.cfg with something like this in it:

  set timeout=10
  set default=0

  menuentry "writer!!" {
    # search for the device with the label "writer"
    search --label --no-floppy writer
    linux (root)/boot/vmlinuz
    initrd (root)/boot/initrd.gz
  }




