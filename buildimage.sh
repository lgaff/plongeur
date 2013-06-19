# Interim build system until I can figure out gprbuild
gnatmake -Pgnat.gpr
nasm -felf -o objects/entry.o source/entry.s
gnatmake --RTS=`pwd`/ada_runtime -Pplongeur.gpr
cp plongeur isodir/boot
grub-mkrescue -o plongeur.iso isodir
