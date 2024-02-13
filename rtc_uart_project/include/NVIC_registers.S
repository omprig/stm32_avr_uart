@ NVIC base address
	.equ NVIC_BASE, 0xE000E000

@ NVIC registers
	.equ NVIC_ISER1, 0x104
	.equ NVIC_ICPR1, 0x284
	.equ NVIC_IPR10, 0x428
@ NVIC bits definition
	.equ NVIC_ISER1_9, 0x00000200
	.equ NVIC_IPR10_1, 0xFFFF0FFF

