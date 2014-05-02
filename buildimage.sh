# Interim build system until I can figure out gprbuild
gnatmake -Pgnat.gpr
nasm -felf -o objects/entry.o source/entry.s
gnatmake --RTS=`pwd`/ada_runtime -Pplongeur.gpr
cp plongeur isodir/boot
sudo mount disk.img /mnt
sudo cp -rv isodir/boot /mnt
sudo umount /mnt
