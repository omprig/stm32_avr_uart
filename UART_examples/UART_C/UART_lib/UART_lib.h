#ifndef UART_LIB_H_
#define UART_LIB_H_

#include <avr/io.h>
#include <util/delay.h>

#define AVR_CODE 0x12
#define STM32_CODE 0x34


void init_UART();
void send_CTS();



#endif /* UART_LIB_H_ */