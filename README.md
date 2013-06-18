plongeur
========

An experiment in OS dev using Ada.

Plongeur is (will be?) a Monolithic kernel in as purely Ada as I can possibly make it.

More details to come later. In the absence of a makefile, you can get by building it with the following steps:

* Build the runtime
gnatmake -P gnat.gpr

* Assemble the entry stub
nasm -f elf -o objects/entry.o source/entry.s

* Compile and link plongeur:
gnatmake --RTS=`pwd`ada_runtime -P plongeur.gpr

Output will be a binary named plongeur in the root folder. you can use grub-mkrescue to create a bootable ISO for running it, or point any other multiboot compatible loader in its direction.
At the moment, there are debug statements for controlling program flow in bochs.

Credit goes to Luke Guest <https://github.com/Lucretia> for his guide on setting up the Ada runtime for a bare x86 environment <http://wiki/osdev.org/Ada_Bare_Bones>

