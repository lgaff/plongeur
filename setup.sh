#!/bin/bash

dd if=/dev/zero of=disk.img bs=1M count=512
fdisk disk.img <<EOF
n
p
1
a
1
w
EOF
sudo losetup /dev/loop0 disk.img
sudo losetup /dev/loop1 -o 1048576 disk.img
sudo mkfs.ext2 /dev/loop1
sudo mount /dev/loop1 /mnt
sudo grub-install --root-directory=/mnt --no-floppy --modules="normal ext2 biosdisk multiboot" /dev/loop0
sudo umount /mnt
sudo losetup -d /dev/loop0
sudo losetup -d /dev/loop1

mkdir objects
mkdir -p ada_runtime/adalib
