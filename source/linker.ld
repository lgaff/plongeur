OUTPUT_FORMAT(elf32-i386)

/* Tell the linker which startup code to use, we do this as there is no way to do this (well not easily) from the GNAT tools. */
STARTUP(entry.o)

ENTRY (entry)

SECTIONS
{
    . = 0x00100000;
    .mboot : {
    	   *(.mboot)
	  }

    .init : {
    	  *(.init)
	}
    	      
    . += 0xC0000000;
    .text : AT(ADDR(.text) - 0xC0000000) {
        *(.text)
    }

    .rodata ALIGN (0x1000) : AT(ADDR(.rodata) - 0xC0000000) {
        *(.rodata)
    }

    .data ALIGN (0x1000) : AT(ADDR(.data) - 0xC0000000) {
        *(.data)
    }

    .bss : AT(ADDR(.bss) - 0xC0000000) {
        sbss = .;
        bss = .; _bss = .; __bss = .;
        *(COMMON)
        *(.bss)
        ebss = .;
    }
    end = .; _end = .; __end = .;
}
