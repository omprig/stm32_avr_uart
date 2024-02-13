@ EXTI base address
	.equ EXTI_BASE, 0x40013C00

@ EXTI register address  offset
	.equ EXTI_IMR, 0x00
	.equ EXTI_EMR, 0x04
	.equ EXTI_RTSR, 0x08
	.equ EXTI_PR, 0x14

@ EXTI bits definition
	.equ EXTI_IMR_MR17_1, 0x00020000
	.equ EXTI_EMR_MR17_1, 0x00020000
	.equ EXTI_RTSR_TR17_1, 0x00020000
	.equ EXTI_PR_PR17, 0x00020000
