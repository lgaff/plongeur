plongeur
========

An experiment in OS dev using Ada.

Plongeur is (will be?) a Monolithic kernel in as purely Ada as I can possibly make it.

Since for the time being, gprbuild has defeated me, I've created a primitive shell script for building a bootable ISO using Grub.

just run buildimage.sh from the root directory. 

You'll need:

- GCC 4.6
- Nasm >=2.10.01
- xorriso >=1.2.4
- grub 2.0

The current build has no gating for debug statements, these wont affect anyone not using bochs with magic_break enabled, however.

Credit goes to Luke Guest <https://github.com/Lucretia> for his guide on setting up the Ada runtime for a bare x86 environment <http://wiki/osdev.org/Ada_Bare_Bones>

