	@ UART init 

        .include "UART_registers.S"
        .include "RCC_registers.S"
        .include "GPIO_registers.S"


	.syntax unified
	.arch armv7e-m
	
	.text
	.thumb
	.thumb_func
	.align 2
	.globl UART2_init
	.type UART2_init, %function
    
UART2_init:

	@enable clocking GPIOA
	LDR r1, =RCC_BASE
	LDR r2, [r1, #RCC_AHB1ENR]
	ORR r2, #RCC_AHB1ENR_GPIOAEN
	STR r2, [r1, #RCC_AHB1ENR]

	@configure PA2 as TX
	@ set mode as alternative function
	LDR r1, =GPIOA_BASE
	LDR r2, [r1, #GPIO_MODER]
	ORR r2, #GPIO_MODER_02_10
	STR r2, [r1, #GPIO_MODER]
	
	@choose AF7 — USART2_TX
	LDR r2, [r1, #GPIO_AFRL]
	ORR r2, #GPIO_AFRL2_AF7
	STR r2, [r1, #GPIO_AFRL]
	
	@ set output speed as high
	LDR r2, [r1, #GPIO_OSPEEDR]
	ORR r2, #GPIO_OSPEEDR_02_HIGH
	STR r2, [r1, #GPIO_OSPEEDR]
	
	@ set output type as push-pull
	LDR r2, [r1, #GPIO_OTYPER]
	AND r2, #GPIO_OTYPER_OT02_PP
	STR r2, [r1, #GPIO_OTYPER]

	@ enable pull-up
	LDR r2, [r1, #GPIO_PUPDR]
	ORR r2, #GPIO_PUPDR_02_01
	STR r2, [r1, #GPIO_PUPDR]
	
	@configure PA0 as CTS
	@ set mode as alternative function
	LDR r2, [r1, #GPIO_MODER]
	ORR r2, #GPIO_MODER_00_10
	STR r2, [r1, #GPIO_MODER]
	
	@choose AF7 — USART2_CTS
	LDR r2, [r1, #GPIO_AFRL]
	ORR r2, #GPIO_AFRL0_AF7
	STR r2, [r1, #GPIO_AFRL]
	
	@ set output speed as high
	LDR r2, [r1, #GPIO_OSPEEDR]
	ORR r2, #GPIO_OSPEEDR_00_HIGH
	STR r2, [r1, #GPIO_OSPEEDR]
	
	@ set output type as push-pull
	LDR r2, [r1, #GPIO_OTYPER]
	AND r2, #GPIO_OTYPER_OT00_PP
	STR r2, [r1, #GPIO_OTYPER]

	@ enable pull-up
	LDR r2, [r1, #GPIO_PUPDR]
	ORR r2, #GPIO_PUPDR_00_01
	STR r2, [r1, #GPIO_PUPDR]
	
	@configure UART2
	@enable clocking
	LDR r1, =RCC_BASE
	LDR r2, [r1, #RCC_APB1ENR]
	ORR r2, #RCC_APB1ENR_USART2EN
	STR r2, [r1, #RCC_APB1ENR]  
	
	@ set USART speed = 9600
	LDR r1, =USART2_BASE
	@ set fraction 0x0 and mantissa 0xD 
	@ for boud rate 9600
	LDR r2, =0x000000D0
	STR r2, [r1, #USART_BRR]
	
	@ enable CTS control
	LDR r2, [r1, #USART_CR3]
	ORR r2, #USART_CR3_CTSE
	STR r2, [r1, #USART_CR3]
	
	@ 1 stop bit
	LDR r2, [r1, #USART_CR2]
	AND r2, #USART_CR2_STOP_00
	STR r2, [r1, #USART_CR2]
	
	@enable TX
	@ no parity bit
	@ 8 bit data frame
	@ 16 bit oversampling
	@enable USART2
	LDR r2, [r1, #USART_CR1]
	ORR r2, #USART_CR1_UE
	ORR r2, #USART_CR1_TE
	AND r2, #USART_CR1_OVER8
	AND r2, #USART_CR1_M
	AND r2, #USART_CR1_PCE
	STR r2, [r1, #USART_CR1]
	
	@ enable CTS interrupt


	BX LR

	.pool
	.size UART2_init, . - UART2_init		
	.end
