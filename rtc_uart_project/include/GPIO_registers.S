	.equ GPIOD_BASE, 0x40020C00
	.equ GPIOA_BASE, 0x40020000
	

	@ GPIO register offsets
	.equ GPIO_MODER, 0x00
	.equ GPIO_OTYPER, 0x04
	.equ GPIO_OSPEEDR, 0x08
	.equ GPIO_PUPDR, 0x0C 
	.equ GPIO_IDR, 0x10
	.equ GPIO_ODR, 0x14
	.equ GPIO_BSRR, 0x18
	.equ GPIO_AFRL, 0x20
	
	@ GPIO register bit definitions
	.equ GPIO_MODER_12_01, 0x01000000
	.equ GPIO_OTYPER_OT12_PP, 0xFFFFEFFF
	.equ GPIO_OSPEEDR_12_LOW, 0xFCFFFFFF
	.equ GPIO_PUPDR_12_00, 0xFCFFFFFF
	.equ GPIO_BSRR_BR12, 0x10000000
	.equ GPIO_BSRR_BS12, 0x00001000
	.equ GPIO_ODR_12_1, 0x00001000

	.equ GPIO_MODER_02_10, 0x00000020
	.equ GPIO_OTYPER_OT02_PP, 0xFFFFFFFB
	.equ GPIO_OSPEEDR_02_HIGH, 0x00000030
	.equ GPIO_PUPDR_02_01, 0x00000010
	 
	.equ GPIO_MODER_00_10, 0x00000002
	.equ GPIO_OTYPER_OT00_PP, 0xFFFFFFFE
	.equ GPIO_OSPEEDR_00_HIGH, 0x00000003
	.equ GPIO_PUPDR_00_01, 0x00000001
	         
	.equ GPIO_AFRL0_AF7, 0x00000007
	.equ GPIO_AFRL2_AF7, 0x00000700
