#!/bin/bash
if [ -f disk.img ]; then
	echo "WARNING: disk.img appears to already exist here.";
	echo "This will overwrite any plongeur installation already on this image";
	echo -n "Are you sure you want to do this? ";
	select yn in "Yes" "No"; do
		case $yn in
			Yes ) rm disk.img; break;;
			No ) echo "No action taken."; exit 0;;
		esac
	done
fi
	
echo "Creating Plongeur installation disk image"
dd if=/dev/zero of=disk.img bs=1M count=512
fdisk disk.img <<EOF
n
p
1


a
w
EOF
BOOT=`losetup -f`
if [ $BOOT == '' ]; then
	echo "Cannot mount disk.img on loopback: No devices left";
	exit 1;
fi
sudo losetup $BOOT disk.img
ROOT=`losetup -f`
if [ $ROOT == '' ]; then
	echo "Cannot mount disk.img root partition on loopback: No devices left";
	exit 1;
fi
sudo losetup $ROOT -o 1048576 disk.img
sudo mkfs.ext2 $ROOT
if ! [ -d bootdir ]; then
	mkdir bootdir;
fi
sudo mount $ROOT bootdir
sudo grub-install --root-directory=bootdir --no-floppy --modules="normal ext2 biosdisk multiboot" $BOOT
sudo mkdir -p bootdir/boot/grub
sudo cp util/grub.cfg bootdir/boot/grub/
if [ -f bootdir/boot/grub/grub.cfg ]; then
	echo "Grub installed to disk image file successfully.";
	RVAL=0;
else
	echo "Grub install failed";
	RVAL=1;
fi
sudo umount bootdir
sudo losetup -d $BOOT
sudo losetup -d $ROOT
exit $RVAL