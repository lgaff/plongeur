# plongeur

An experiment in OS dev using Ada, targeting the x86 PC.

Plongeur is (will be?) a Monolithic kernel in as purely Ada as I can possibly make it.

Credit goes to Luke Guest <https://github.com/Lucretia> for his guide on setting up the Ada runtime for a bare x86 environment <http://wiki/osdev.org/Ada_Bare_Bones>

Plongeur understands and is intended to use GRUB 1 as a boot loader and system initialisation library. A partial implementation of the Multiboot specification is included in the kernel for this.

## How to build

* Some directories are required before building will succeed:

    `mkdir -p objects ada_runtime/adalib`

* Then, build the runtime. The file gnat.gpr is configured to build a custom runtime for the Plongeur startup.

    `gnatmake -P gnat.gpr`

* This will build libgnat.a to ada_runtime/adalib. It should now be possible to build the kernel image
    ````bash
    $ nasm -f elf -o objects/entry.o source/entry.s
    $ nasm -f elf -o objects/interrupts.o source/entry.s
    $ gnatmake --RTS=`pwd`/ada_runtime -P plongeur.gpr
    ````
* The output file plongeur is the kernel image. To run it, you'll need a PC or VM/emulator somewhere with grub installed
* You can create a 512MiB ext2 disk image suitable for either bochs or Qemu with Grub installed and configured to boot plongeur using the script create_install_disk.sh. You'll need a couple of free loopback devices to mount and create the file system.
* The install script will copy util/grub.cfg into the created partition. This config includes a menuentry for Plongeur. It should be possible to use it on another hard disk or disk image (provided Grub is installed), but I have not tested it.
* Finally, mount and copy the kernel image file to the root of the prepared disk. Plongeur is installed and ready.

## Running with bochs
The file bochs.txt configures the bochs emulator for a 386 PC with disk.img as the first boot device. Pass it to bochs on the command line:
    ````bash
    $ bochs -f bochs.txt
    ````

## Running with QEMU
Plongeur doesn't currently need a whole lot of RAM, just run qemu passing the disk image as the first boot device:
   ````bash
   $ qemu-system-i386 -hda disk.img
   ````
   
## What Plongeur can do
Nothing really. Current state of the kernel allows it to boot, configure enough of paging to allow the kernel image to reside at 3 GiB virtual (Loads to 1MiB physical. The boot process relies on a trick with the GDT, plus some manual address
mangling in order to identity page the first 4 megs, then copy the page table to 3 GiB before loading the 'real' GDT),
and enable interrupts before printing some fancy status info to the console.

I know, strap in and hang on...

## What Plongeur will do
The aim of Plongeur is to be a functional monolothic style kernel.
In future, Plongeur hopes to provide:
* Pre-emptive multitasking
* Per-process virtual memory
* Text-mode UI
* Keyboard/mouse drivers
* Virtual file system
* System call interface based on either POSIX or VMS (undecided yet)
Most of those features are a long way from being realised. In the short time, I'm aiming for at least a basic single-process shell interpreter to allow for some sort of interactivity. This will probably take the form of a simple Lisp or Forth based system.

## Why Plongeur?
Why not.

I tend to name projects after features from works by George Orwell. At the time, it seemed fitting to consider an OS as similar to how Orwell describes the role and life of a plongeur (dishwasher).

> [A] plongeur is one of the slaves of the modern world. Not that there is any need to whine over him, for he is better off than many manual workers, but still, he is no freer than if he were bought and sold. His work is servile and without art; he is paid just enough to keep him alive; his only holiday is the sack [.... He has] been trapped by a routine which makes thought impossible. If plongeurs thought at all, they would long ago have formed a labour union and gone on strike for better treatment. But they do not think, because they have no leisure for it; their life has made slaves of them



