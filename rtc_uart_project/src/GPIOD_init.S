	.include "RCC_registers.S"
	.include "GPIO_registers.S"	

	.syntax unified
	.arch armv7e-m
	
	.text
	.thumb
	.thumb_func
	.align 2
	.globl GPIOD_init
	.type GPIOD_init, %function
GPIOD_init:
	
	@ enable clocking GPIOD
	LDR r1, =RCC_BASE
	LDR r2, [r1, #RCC_AHB1ENR]
	ORR r2, #RCC_AHB1ENR_GPIODEN
	STR r2, [r1, #RCC_AHB1ENR]

	
	@select mode as output
	LDR r1, =GPIOD_BASE
	LDR r2, [r1, #GPIO_MODER]
	ORR r2, #GPIO_MODER_12_01
	STR r2, [r1, #GPIO_MODER]
	
	@ set PD12 speed as low
	LDR r2, [r1, #GPIO_OSPEEDR]
	AND r2, #GPIO_OSPEEDR_12_LOW
	STR r2, [r1, #GPIO_OSPEEDR]

	@set no pull-up and no pull-down for PD12
	LDR r2, [r1, #GPIO_PUPDR]
	AND r2, #GPIO_PUPDR_12_00
	STR r2, [r1, #GPIO_PUPDR]	
	
	@ turn on LED
	LDR r2, =GPIO_BSRR_BS12
	STR r2, [r1, #GPIO_BSRR]

		

	BX lr

	.pool
	.size GPIOD_init, . - GPIOD_init
	

	.end	
