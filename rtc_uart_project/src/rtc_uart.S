	.include "GPIO_registers.S"
	.include "RTC_registers.S"	
	.include "EXTI_registers.S"
	.include "UART_registers.S"

	.syntax unified
	.arch armv7e-m


	/*.equ Stack_Size, 0x00CB*/
	.globl __StackTop
	


	.section .isr_vector
	.align	2
	.globl	__isr_vector
__isr_vector:
	.long	__StackTop            /* Top of Stack */
	.long	Reset_Handler         /* Reset Handler */
	.long	NMI_Handler           /* NMI Handler */
	.long	HardFault_Handler     /* Hard Fault Handler */
	.long	MemManage_Handler     /* MPU Fault Handler */
	.long	BusFault_Handler      /* Bus Fault Handler */
	.long	UsageFault_Handler    /* Usage Fault Handler */
	.long	0                     /* Reserved */
	.long	0                     /* Reserved */
	.long	0                     /* Reserved */
	.long	0                     /* Reserved */
	.long	SVC_Handler           /* SVCall Handler */
	.long	DebugMon_Handler      /* Debug Monitor Handler */
	.long	0                     /* Reserved */
	.long	PendSV_Handler        /* PendSV Handler */
	.long	SysTick_Handler       /* SysTick Handler */
	
	/* RTC handler */
	.org 0x000000E4
	.long RTC_Alarm_Handler
	
	/* External interrupts */
	.long	Default_Handler

	.size	__isr_vector, . - __isr_vector
	
	//.section .main_program
main:
	.text
	.thumb
	.align 2

	bl RCC_init
	bl GPIOD_init
	CPSID I
	bl RTC_init
        bl UART2_init
        
        LDR r1, =USART2_BASE
wait_CTS:
        LDR r2, [r1, #USART_SR]
        ANDS r2, #USART_SR_CTS
        BEQ wait_CTS

	@enable global interrupts
 	CPSIE I	
inf_loop:
	b inf_loop
	


	.text
	.thumb
	.thumb_func
	.align	2
	.globl	Reset_Handler
	.type	Reset_Handler, %function
Reset_Handler:
	b	main

	.pool
	.size	Reset_Handler, . - Reset_Handler

	.text
	.thumb
	.thumb_func
	.align 2
	.globl RTC_Alarm_Handler
	.type RTC_Alarm_Handler, %function
RTC_Alarm_Handler:
	
	@ check type of the interrupt
	LDR r1, =RTC_BASE
	LDR r2, [r1, #RTC_ISR]
	ANDS r2, #RTC_ISR_ALRAF
	BEQ not_A_alarm
	
	@ clear ALRAF
	LDR r2, [r1, #RTC_ISR]
	LDR r3, =#RTC_ISR_ALRAF
	MVN r3, r3
	AND r2, r3
	STR r2, [r1, #RTC_ISR]


	@ toggle PD12
	LDR r1, =GPIOD_BASE
	LDR r2, [r1, #GPIO_IDR]
	EOR r2, #GPIO_ODR_12_1
	STR r2, [r1, #GPIO_ODR]
        @ send time via USART2
        LDR r0, =RTC_BASE
        LDR r1, =USART2_BASE
        
        @send hours
        LDR r2, [r0, #RTC_TR]
        AND r2, #RTC_TR_HOURS_MASK
        LSR r2, #0x10
        
        @ check if TDR is epmty
hours:
        LDR r3, [r1, #USART_SR]
        ANDS r3, #USART_SR_TXE
        BEQ hours
        STR r2, [r1, #USART_DR]
        
        @send minutes
        LDR r2, [r0, #RTC_TR]
        AND r2, #RTC_TR_MINUTES_MASK
        LSR r2, #0x8
        
        @ check if TDR is epmty
mins:
        LDR r3, [r1, #USART_SR]
        ANDS r3, #USART_SR_TXE
        BEQ mins
        STR r2, [r1, #USART_DR]
        
        @send seconds
        LDR r2, [r0, #RTC_TR]
        AND r2, #RTC_TR_SECONDS_MASK
        
        @ check if TDR is epmty
seconds:
        LDR r3, [r1, #USART_SR]
        ANDS r3, #USART_SR_TXE
        BEQ seconds
        STR r2, [r1, #USART_DR]
        
        @ wait for ending of transmission
end_transmission:
        LDR r3, [r1, #USART_SR]
        ANDS r3, #USART_SR_TC
        BEQ end_transmission

not_A_alarm:	
	@ clear pending bit for EXTI17
	LDR r1, =EXTI_BASE
	LDR r2, [r1, #EXTI_PR]
	ORR r2, #EXTI_PR_PR17 
	STR r2, [r1, #EXTI_PR]

	BX LR
		
	.pool
	.size RTC_Alarm_Handler, . - RTC_Alarm_Handler

	.align	1
	.thumb_func
	.weak	Default_Handler
	.type	Default_Handler, %function
Default_Handler:
	b	.
	.size	Default_Handler, . - Default_Handler

/*    Macro to define default handlers. Default handler
 *    will be weak symbol and just dead loops. They can be
 *    overwritten by other handlers */
	.macro	def_irq_handler	handler_name
	.weak	\handler_name
	.set	\handler_name, Default_Handler
	.endm

	def_irq_handler	NMI_Handler
	def_irq_handler	HardFault_Handler
	def_irq_handler	MemManage_Handler
	def_irq_handler	BusFault_Handler
	def_irq_handler	UsageFault_Handler
	def_irq_handler	SVC_Handler
	def_irq_handler	DebugMon_Handler
	def_irq_handler	PendSV_Handler
	def_irq_handler	SysTick_Handler
	def_irq_handler	DEF_IRQHandler
.end
