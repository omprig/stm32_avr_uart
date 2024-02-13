#include <avr/io.h>
#include <avr/interrupt.h>
#include <stdbool.h>
#include "LCD_lib.h"
#include "UART_lib.h"

#define TIME_NUMBERS 6

volatile unsigned char time_str[TIME_NUMBERS] = {0x30};
enum Time_is_ready{READY = 1, NOT_READY = 0};
volatile enum Time_is_ready update_time = NOT_READY;

ISR(USART1_RX_vect)
{
	static uint8_t time_index = 0;
	unsigned char uart_data = UDR1;
	
	if(uart_data != 0xFF)
	{
		time_str[time_index] = (uart_data >> 4) + 0x30;
		time_str[time_index + 1] = (uart_data & 0x0F) + 0x30;
		
		if(time_index < 4)
		{
			time_index +=2;
		}
		else
		{
			time_index = 0;
			update_time = READY;
		}	
	}
	
}

int main(void)
{
	
	init_LCD();
	init_UART();
	
	//enable global interrupt
	sei();

	//ready for receiving data
	send_CTS();
	
    while (1) 
    {
		if(update_time)
		{
			print_time(time_str);
			update_time = NOT_READY;
		}
    }
}

