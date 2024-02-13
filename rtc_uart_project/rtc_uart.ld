/* my linker script*/



/* define types of memory */


MEMORY
{
	FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 0x80000 /* 512Kb */
	SRAM (rwx) : ORIGIN = 0x20000000, LENGTH = 0x20000 /* 128Kb */

}

ENTRY(Reset_Handler)

SECTIONS
{
	.text :
	{
		KEEP(*(.isr_vector))
		
		*(.text*)

	} > FLASH

	__StackTop = ORIGIN(SRAM) + LENGTH(SRAM)- 4;

	/*
	__StackLimit = __StackTop - SIZEOF(.stack_dummy);
	PROVIDE(__stack = __StackTop);

	.stack_dummy (NOLOAD) :
	{
		*(.stack*)
	} > SRAM */
	
}
