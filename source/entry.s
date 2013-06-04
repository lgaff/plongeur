;;; Entry point for the stage 3 boot loader. stage 3 is responsible for the handover between GRUB and plongeur.
;;; entry.s collects the multiboot data from grub and passes it to the main function defined by GNAT.

global entry
extern main
extern gp
	
MODULEALIGN equ 1 << 0
MEMINFO equ 1 << 1
FLAGS equ MODULEALIGN | MEMINFO
MAGIC equ 0x1BADB002
CHECKSUM equ -(MAGIC + FLAGS)

STACKSIZE equ 0x4000

section .mboot
section .text
	align 4
	dd MAGIC
	dd FLAGS
	dd CHECKSUM	

entry:
	xchg bx, bx
	;; Load the fake GDT until we install the page directory
	;; flush whatever GRUB put there as we go
	lgdt [fakegdt]
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	jmp 0x08:higherhalf
higherhalf:
	;; until we get paging up, the segment descriptors will translate
	;; link addresses for us by adding 0x40000000 (0xC0100000 + 0x40000000 = 0x10000 :) )
	mov esp, stack + STACKSIZE
	mov eax, magic
	mov ebx, mbd
	cli
	call main

hang:
	jmp hang

global gdtflush
gdtflush:
	lgdt [gp]
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	jmp 0x08:flush2
flush2:
	ret

section .init
fakegdt:
	dw gdt_end - gdt - 1
	dd gdt

gdt:
	dd 0, 0 		; NULL descriptor
	db 0xFF, 0xFF, 0, 0, 0, 10011010b, 11001111b, 0x40 ; code segment
	db 0xFF, 0xFF, 0, 0, 0, 10010010b, 11001111b, 0x40 ; data segment
gdt_end:	
	

section .bss
align 32
magic:
	resb 4
mbd:
	resb 4
stack:
	resb STACKSIZE
