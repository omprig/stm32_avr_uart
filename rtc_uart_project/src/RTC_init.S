	.include "RCC_registers.S"	
	.include "RTC_registers.S"
	.include "EXTI_registers.S"
	.include "NVIC_registers.S"



	.syntax unified
	.arch armv7e-m
	
	.text
	.thumb
	.thumb_func
	.align 2
	.globl RTC_init
	.type RTC_init, %function
RTC_init:

	@PUSH {lr}
	
	@codnigure clock for PWR block
	LDR r1, =RCC_BASE
	LDR r2, [r1, #RCC_APB1ENR]
	ORR r2, #RCC_APB1ENR_PWREN_1
	STR r2, [r1, #RCC_APB1ENR]	

	@configure clock for RTC block
	@select HSE/8 as clock sourse
	LDR r2, [r1, #RCC_CFGR]
	ORR r2, #RCC_CFGR_RTCPRE_8
	STR r2, [r1, #RCC_CFGR]

	@enable writing to RTC registers
	LDR r1, =PWR_CR
	LDR r2, [r1, #0]
	ORR r2, #PWR_CR_DBP_1
	STR r2, [r1, #0]

	LDR r1, =RCC_BASE
	LDR r2, [r1, #RCC_BDCR]
	ORR r2, #RCC_BDCR_RTCEN_1
	ORR r2, #RCC_BDCR_SEL_HSE
	STR r2, [r1, #RCC_BDCR]

	
	@ unlock write protection
	LDR r1, =RTC_BASE
	MOV r2, 0xCA
	STR r2, [r1, #RTC_WPR]
	
	MOV r2, 0x53
	STR r2, [r1, #RTC_WPR]
	 	
	@ enter initialization mode
	LDR r2, [r1, #RTC_ISR]
	ORR r2, #RTC_ISR_INIT_1
	STR r2, [r1, #RTC_ISR]
	
	@wait for INIT flag
	MOV r3, #RTC_ISR_INITF
init_flag_wait:
	LDR r2, [r1, #RTC_ISR]
	AND r2, r3
	BEQ init_flag_wait
	
	@set sync and async prescalers 
	@to generate 1 Hz
	MOV r2, #sync_presc_8000
	STR r2, [r1, #RTC_PRER]
	MOV r2, #async_presc_125
	LSL r2, #0x10
	LDR r3, [r1, #RTC_PRER]
	ORR r2, r3
	STR r2, [r1, #RTC_PRER]
	
	@set time 12:49:31
	LDR r2, =#0x00124931			
	STR r2, [r1, #RTC_TR]
	
	@exit init mode
	LDR r2, [r1, #RTC_ISR]
	MOV r3, #RTC_ISR_INIT_1
	MVN r3, r3
	AND r2, r3
	STR r2, [r1, #RTC_ISR]
			
	@programming the alarm A
	@configure EXTI17
	@enable event 
	LDR r1, =EXTI_BASE
	LDR r2, [r1, #EXTI_EMR]
	ORR r2, #EXTI_EMR_MR17_1
	STR r2, [r1, #EXTI_EMR]	

	@enable interrupt
	LDR r1, =EXTI_BASE
	LDR r2, [r1, #EXTI_IMR]
	ORR r2, #EXTI_IMR_MR17_1
	STR r2, [r1, #EXTI_IMR]	

	@set rising edge for the EXTI17
	LDR r2, [r1, #EXTI_RTSR]
	ORR r2, #EXTI_RTSR_TR17_1
	STR r2, [r1, #EXTI_RTSR]	
	
	@configure RTC Alarm A in NVIC
	@enable RTC interrupt
	LDR r1, =NVIC_BASE
	LDR r2, [r1, NVIC_ISER1]
	ORR r2, #NVIC_ISER1_9
	STR r2, [r1, #NVIC_ISER1]

	@set priority to max
	LDR r2, [r1, NVIC_IPR10]
	AND r2, #NVIC_IPR10_1
	STR r2, [r1, NVIC_IPR10]

	@ programming Alarm A
	@disable Alarm A
	LDR r1, =RTC_BASE
	LDR r2, [r1, #RTC_CR]
	MOV r3, #RTC_CR_ALRAE
	MVN r3, r3
	AND r2, r3
	STR r2, [r1, #RTC_CR]

	@ wait for allowance to alarm A registers
await_ALARAWF:
	LDR r2, [r1, #RTC_ISR]
	AND r2, #RTC_ISR_ALRAWF
	BEQ await_ALARAWF

	@programming alarm A registers
	@set alarm A every second
	MOV r2, #RTC_ALRMAR_MSK1
	ORR r2, #RTC_ALRMAR_MSK2
	ORR r2, #RTC_ALRMAR_MSK3
	ORR r2, #RTC_ALRMAR_MSK4
	STR r2, [r1, #RTC_ALRMAR]	
	
	LDR r2, [r1, #RTC_ALRMASSR]
	MOV r3, #RTC_ALRMASSR_MASKSS_0000
	AND r2, r3
	STR r2, [r1, #RTC_ALRMASSR]
	
	@enable alarm A again and enable interrupt
	LDR r2, [r1, #RTC_CR]
	ORR r2, #RTC_CR_ALRAE
	ORR r2, #RTC_CR_ALRAIE
	STR r2, [r1, #RTC_CR]
		
	@POP {lr}
	BX lr

	.pool
	.size RTC_init, . - RTC_init


	.end
