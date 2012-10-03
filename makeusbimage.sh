
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
sudo mkfs.vfat -F 16 -n writer /dev/loop1
sudo mount /dev/loop1 /mnt
sudo grub-install --no-floppy --root-directory=/mnt /dev/loop0

# then go
cd /mnt/boot/grub

make a grub.cfg with something like this in it:

  set timeout=10
  set default=0

  menuentry "writer!!" {
    # search for the device with the label "writer"
    search --label --no-floppy writer
    # root device is implicit here I think
    linux /boot/vmlinuz
    initrd /boot/initrd.gz
  }

put the kernel and initrd in /boot
 sudo cp /boot/vmlinuz-$(uname -r) /mnt/boot
 sudo cp /home/mark/writingdistro/scratch/initramfs-tools-adaptation/zadelinitrd.gz /mnt/boot/initrd.gz
 sudo sync

clean up
 sudo umount /mnt
 sudo losetup -d /dev/loop1
 sudo losetup -d /dev/loop0


test with qemu
## TODO next problem: getting qemu to boot off of this usb key image

// mounting the filesystem on the image w/o having to use losetup:
sudo mount -o loop,offset=32256,rw /home/mark/writingdistro/scratch/initramfs-tools-adaptation/usbimage /mnt

