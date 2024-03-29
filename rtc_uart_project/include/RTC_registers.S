@ RTC base address
	.equ RTC_BASE, 0x40002800

@ PWR_CR register
	.equ PWR_CR, 0x40007000
	.equ PWR_CR_DBP_1, 0x00000100

@ RTC register address offset
	.equ RTC_TR, 0x00
	.equ RTC_CR, 0x08
	.equ RTC_ISR, 0x0C
	.equ RTC_PRER, 0x10
	.equ RTC_ALRMAR, 0x1C
	.equ RTC_WPR, 0x24
	.equ RTC_ALRMASSR, 0x44


@ RTC bits definition
	.equ RTC_ISR_INIT_1, 0x00000080
	.equ RTC_ISR_INITF, 0x00000040
	.equ RTC_CR_ALRAE, 0x00000100
	.equ RTC_CR_ALRAIE, 0x00001000	
	.equ RTC_ISR_ALRAWF, 0x00000001
	.equ RTC_ISR_ALRAF, 0x00000100
	.equ RTC_ALRMAR_MSK4, 0x80000000
	.equ RTC_ALRMAR_MSK3, 0x00800000
	.equ RTC_ALRMAR_MSK2, 0x00008000
	.equ RTC_ALRMAR_MSK1, 0x00000080
	.equ RTC_ALRMASSR_MASKSS_0000, 0xF0FFFFFF


@ prescaler values
	.equ sync_presc_8000, 0x1F3F
	.equ async_presc_125, 0x7C
@time unit mask

	.equ RTC_TR_HOURS_MASK, 0x003F0000
	.equ RTC_TR_MINUTES_MASK, 0x00007F00
	.equ RTC_TR_SECONDS_MASK, 0x0000007F
