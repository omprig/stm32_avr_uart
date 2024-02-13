# simple makefile

objects = ./bin/rtc_uart.o ./bin/GPIOD_init.o ./bin/RCC_init.o ./bin/RTC_init.o ./bin/UART2_init.o
obj_target = rtc_uart.o GPIOD_init.o RCC_init.o RTC_init.o UART2_init.o



rtc_uart.elf: $(obj_target)
	arm-none-eabi-ld $(objects) -o rtc_uart.elf -T rtc_uart.ld

rtc_uart.o: ./src/rtc_uart.S ./include/GPIO_registers.S ./include/RTC_registers.S ./include/EXTI_registers.S
	arm-none-eabi-as ./src/rtc_uart.S -o ./bin/rtc_uart.o -I ./include -g -mcpu=cortex-m4

GPIOD_init.o: ./src/GPIOD_init.S ./include/GPIO_registers.S ./include/RCC_registers.S
	arm-none-eabi-as ./src/GPIOD_init.S -o ./bin/GPIOD_init.o -I ./include -g -mcpu=cortex-m4

RCC_init.o: ./src/RCC_init.S ./include/RCC_registers.S
	arm-none-eabi-as ./src/RCC_init.S -o ./bin/RCC_init.o -I ./include -g -mcpu=cortex-m4

RTC_init.o: ./src/RTC_init.S ./include/RCC_registers.S ./include/RTC_registers.S ./include/EXTI_registers.S ./include/NVIC_registers.S
	arm-none-eabi-as ./src/RTC_init.S -o ./bin/RTC_init.o -I ./include -g -mcpu=cortex-m4

UART2_init.o: ./src/UART2_init.S ./include/RCC_registers.S ./include/GPIO_registers.S ./include/UART_registers.S
	arm-none-eabi-as ./src/UART2_init.S -o ./bin/UART2_init.o -I ./include -g -mcpu=cortex-m4

clean_obj:
	rm ./bin/*.o
