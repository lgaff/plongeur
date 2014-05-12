;; Module      : interrupts.s
;; Description : Trampoline code for handling interrupts.
;;               Each defined interrupt is passed to Ada via 
;;				 IRQ/Fault_Handler procedures, which call
;;               registered callback routines.
;; Author      : Lindsay Gaff <lindsaygaff@gmail.com>
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
extern ip

section .text
;;; two macros for the two basic interrupt skeleton types - one which pushes an error code, one that does not.
;;; this ensures we've got a well-formed stack alignment when we jump to the common stub handler.
%macro ISR_NOERRCODE 1
	global isr%1
        isr%1:
	  cli
	  push byte 0 		; dummy value to retain stack alignment
	  push byte %1		; So we know what interrupt has fired
	  jmp isr_common_stub
%endmacro

%macro ISR_ERRCODE 1
	global isr%1
        isr%1:
	  cli
	  push byte %1
	  jmp isr_common_stub	; The error code is already on the stack, so isr_common stub still pops 2 values off
%endmacro

%macro IRQ 2
	global irq%1
        irq%1:
	  cli
	  push byte 0
	  push byte %1
	  jmp irq_common_stub
%endmacro

;;; Define 32 interrupt handlers.

ISR_NOERRCODE 0			; appropriately, divide by 0
ISR_NOERRCODE 1			; Debug exception
ISR_NOERRCODE 2			; NMI
ISR_NOERRCODE 3			; Breakpoint exception
ISR_NOERRCODE 4			; Into detected overflow
ISR_NOERRCODE 5			; Out of bounds exception
ISR_NOERRCODE 6			; Invalid opcode
ISR_NOERRCODE 7			; Coprocessor not present
ISR_ERRCODE   8			; double fault
ISR_NOERRCODE 9			; Coprocessor segment overrun
ISR_ERRCODE   10		; Bad TSS
ISR_ERRCODE   11		; Segment not present
ISR_ERRCODE   12		; Stack fault
ISR_ERRCODE   13		; General protection fault
ISR_ERRCODE   14		; Page fault
ISR_NOERRCODE 15		; Unknown interrupt
ISR_NOERRCODE 16		; Coprocessor fault
ISR_NOERRCODE 17		; Alignment check exception
ISR_NOERRCODE 18		; Machine check exception
ISR_NOERRCODE 19		; Interrupts 19-31 are reserved by Intel.
ISR_NOERRCODE 20
ISR_NOERRCODE 21
ISR_NOERRCODE 22
ISR_NOERRCODE 23
ISR_NOERRCODE 24
ISR_NOERRCODE 25
ISR_NOERRCODE 26
ISR_NOERRCODE 27
ISR_NOERRCODE 28
ISR_NOERRCODE 29
ISR_NOERRCODE 30
ISR_NOERRCODE 31

IRQ 0, 32
IRQ 1, 33
IRQ 2, 34
IRQ 3, 35
IRQ 4, 36
IRQ 5, 37
IRQ 6, 38
IRQ 7, 39
IRQ 8, 40
IRQ 9, 41
IRQ 10, 42
IRQ 11, 43
IRQ 12, 44
IRQ 13, 45
IRQ 14, 46
IRQ 15, 47

global idtflush
idtflush:
	mov eax, ip
	lidt [eax]
	ret

extern fault_handler

isr_common_stub:
	pusha			; Push all our registers
	mov ax, ds
	push eax		; data segment descriptor
	push esp

	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	call fault_handler

	pop eax
	pop eax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	popa
	add esp, 8		; clean up the stack
	sti
	iret

global trap_interrupt
trap_interrupt:
	sti
	int 0
	ret

extern irq_handler
irq_common_stub:
	pusha
	mov ax, ds		; save data segment descriptor
	push eax
	push esp

	mov ax, 0x10 		; load kernel data segment descriptor
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	call irq_handler

	pop ebx
	pop ebx
	mov ds, bx
	mov es, bx
	mov fs, bx
	mov gs, bx

	popa
	add esp, 8
	sti
	iret