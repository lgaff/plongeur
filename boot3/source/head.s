	;;  entry point for aspidistrOS kernel. Loads from GRUB and must be position independant until we enable paging
	;; After that, kernel will reside at 3 GiB in virtual memory. 
	;;

global _loader
extern _main

;;; First up are the multiboot structures
MODULEALIGN 	equ 1 << 0
MEMINFO 	equ 1 << 1
FLAGS 		equ MODULEALIGN | MEMINFO
MAGIC		equ 0x1BADB002
CHECKSUM	equ -(MAGIC + FLAGS)

;;; Now we need some way of translating virtual/physical addresses until we gget into vmem land

KERNEL_VIRTUAL_BASE equ 0xC0000000
KERNEL_PAGE_NUMBER  equ (KERNEL_VIRTUAL_BASE >> 22) ; page directory index of kernels 4 meg page table entry

;;; Now, we'll identity map the first 4 megs of the physical address space
;;; We'll allocate the entire page directory structure (1024 32 bit entries), taking special care for the
;;; zeroth entry, which refers to the first 4 megs of vmem space, and the 768th entry, which looks after
;;; the 4 megs of vmem beginning at 3GiB. We want to map both virtual pages to physical address 0-4MiB, as this is
;;; where the kernel code is physically located.
section .data
align 0x1000
PageDirectory:
	;; Page entries in the page directory look like this:
	;; 31		11  9		     0
	;; |phyaddr	|avl|G|S|0|A|D|W|U|R|P
	;; The useful bits for us right now are 7 (PS), 1 (RW), and 0 (P). Set these to one to define both pages as
	;; 4 MiB in size, read/write, and present in memory.
	;; 	dd 0x00000083	       ; entry 0 identity maps the first 4 MiB
	;; 	times (KERNEL_PAGE_NUMBER - 1) dd 0 ; The next 766 entries are zeroed.
	;; 	dd 0x00000083			    ; The kernel page directory, where we will load our kernel once paging is running
	;; 	times (1024 - KERNEL_PAGE_NUMBER - 1) dd 0 ; rest of the page directory is also not present
	;; First page directory entry corresponds to the first 4 MiB of physical ram in 4k lots. we want to id map the entire 4 meg block initially, but once we've
	;; enabled paging, we'll invalidate 1 - 4 MiB phaddr and remap this space to 3 GiB vaddr.
bptE:	dd bootPageTable-KERNEL_VIRTUAL_BASE + 0x3 ; Translate the virtual address to physical. add 3 (binary 11) for read/write and present flags.
	times (KERNEL_PAGE_NUMBER - 1) dd 0	   ; These pages are not present.
	;; Now we're at the page directory entry for 3GiB - 3GiB + 4 MiB. We'll map phyaddr 1 - 4 MiB here.
hhE:	dd higherHalf - KERNEL_VIRTUAL_BASE + 3
	times (1024 - KERNEL_PAGE_NUMBER - 1) dd 0 ; Rest of the pages are also not mapped yet
	
align 0x1000
bootPageTable:
	;; This identity pages the first 256 4k pages (1 meg). the kernel pages starting from 1 meg are translated to vaddr 3 GiB + 1 meg
	%assign pg_num 0
	%rep 1024
	    dd pg_num*0x1000+3 	; page number * 4k (physical address) + flags r/w and present
	%assign pg_num pg_num+1
	%endrep
	;; the first 4 megs are identity mapped. We need to invalidate the pages 1MiB -> 4 MiB once we've enabled paging and jumped to the higher half
align 0x1000
higherHalf:
	;; here we want to map the pages from kernel_start -> kernel_end starting at 3GiB.  Physical pages are at 1 MiB.
	times 256 dd 0			  ; first meg above 3GiB is not present
	%assign pg_num 256
	%rep 768
	    dd pg_num*0x1000+3	; Physical pages 1 - 4 MiB
	%assign pg_num pg_num + 1
	%endrep
align 0x1000

section .text
align 4
bootHeader:
	dd MAGIC
	dd FLAGS
	dd CHECKSUM

STACKSIZE equ 0x4000


global loader
loader equ (_loader - 0xC0000000) ; This is so ld can find and link  our code to work properly



_loader:	
	;; Now, we enable paging.
	mov ecx, (PageDirectory - KERNEL_VIRTUAL_BASE) ; Translate the address to a physical one as we're still in lomem, non-paged space
	mov cr3, ecx				       ; load PD base register with our page directory address

	mov ecx, cr0
	or ecx, 0x80000000	; Enable paging by setting PG bit of cr0
	mov cr0, ecx

	;; Now paging is enabled, we need to jump to our kernel code asap to start using the virtual address space
	;; eip currently holds a physical address of the next command.
	lea ecx, [virtualStart]
	jmp ecx

virtualStart:			; we made it. first thing we want to do is invalidate the identity mapped address space.
	mov esp, stack+STACKSIZE
	mov WORD [0xB8000], 0x0763
	push eax		; pass multiboot to _main
	push ebx
	sti
	
	call _main
	hlt

section .bss
align 32
	global print_buffer
print_buffer:
	resb 512
stack:
	resb STACKSIZE