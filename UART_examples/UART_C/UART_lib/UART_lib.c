#include "UART_lib.h"

void init_UART()
{
	//set baud rate to 9600
	UBRR1H = 0x00;
	UBRR1L = 0x2F;
	
	//disable double speed
	UCSR1A &= ~(1 << U2X1);
	
	//frame size 8 bit, no parity mode, 1 stop bit, asynchronous mode
	UCSR1C = 0x00;
	UCSR1C |= (1 << UCSZ11) | (1 << UCSZ10);
	
	//set frame size 8 bit, enable receiver and transmitter, enable interrupt on RX1 flag
	UCSR1B |= (1 << RXCIE1) | (1 << TXEN1) | (1 << RXEN1);
	UCSR1B &= ~(1 << UCSZ12);
	
}

void send_CTS()
{
	//using PD4 as output
	DDRD = 1 << DDRD4;
	
	//send CTS signal
	
	PORTD |= (1 << PORTD4);
	_delay_ms(1000);
	PORTD &= ~(1 << PORTD4);
}