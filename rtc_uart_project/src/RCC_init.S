	.include "RCC_registers.S"
	
	.syntax unified
	.arch armv7e-m
	
	.text
	.thumb
	.thumb_func
	.align 2
	.globl RCC_init
	.type RCC_init, %function
RCC_init:
	
	@save return address on the stack
	@PUSH {lr}
	
       	@ configure RCC
       	@ turn on HSE
        LDR r1, =RCC_BASE
        LDR r2, [r1, #RCC_CR]
        ORR r2, #RCC_CR_HSEON
        ORR r2, #RCC_CR_CSSONN
        STR r2, [r1, #RCC_CR]
        
       @wait for HSE becomes stable

wait_for_stable_HSE:
        LDR r2, [r1, #RCC_CR]
        ANDS r2, #RCC_CR_HSERDY
        BEQ wait_for_stable_HSE
        
       @select HSE as SYSCLK
        LDR r2, [r1, #RCC_CFGR]
        AND r2, #0xFFFFFFFC
        ORR r2, #RCC_CFGR_SW_HSE
        STR r2, [r1, #RCC_CFGR]
        
       @wait for HSE is selected as SYSCLK

wait_for_HSE_as_SYSCLK:
        LDR r2, [r1, #RCC_CFGR]
        ANDS r2, #RCC_CFGR_SWS_HSE
        BEQ wait_for_HSE_as_SYSCLK
      
       @ set diveder values for AHB, APB1, APB2
       @ SYS_CLK = 8MHz
       @ AHB = SYS_CLK / 2
       @ APB1 = APB2 = AHB / 2
        LDR r2, [r1, #RCC_CFGR]
        ORR r2, #RCC_CFGR_HPRE_DIV2
        ORR r2, #RCC_CFGR_PPRE1_DIV2
        ORR r2, #RCC_CFGR_PPRE2_DIV2
        STR r2, [r1, #RCC_CFGR]
	
	@renew retrun address from the stack
	@POP {r0}
	@MOV lr, r0
	BX lr
	
	.pool
	.size RCC_init, . - RCC_init



	.end

