;;; Entry point for the stage 3 boot loader. stage 3 is responsible for the handover between GRUB and plongeur.
;;; entry.s collects the multiboot data from grub and passes it to the main function defined by GNAT.

global entry
extern main
	
MODULEALIGN equ 1 << 0
MEMINFO equ 1 << 1
FLAGS equ MODULEALIGN | MEMINFO
MAGIC equ 0x1BADB002
CHECKSUM equ -(MAGIC + FLAGS)

STACKSIZE equ 0x4000

section .data

	
section .text
align 4


	dd MAGIC
	dd FLAGS
	dd CHECKSUM
entry:
	xchg bx, bx
	mov esp, stack + STACKSIZE
	mov eax, magic
	mov ebx, mbd
	cli
	call main

hang:
	jmp hang

section .bss
align 32
magic:
	resb 4
mbd:
	resb 4
stack:
	resb STACKSIZE
