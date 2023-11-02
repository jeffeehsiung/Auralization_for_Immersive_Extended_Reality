///*
// * main.c
// */
//
//#include <stdio.h>
//#include "usbstk5515.h"
//#include "usbstk5515_i2c.h"
//#include "lcd.h"
//#include "oled.h"
//#include "usbstk5515_gpio.h"
//
//#define OSD9616_I2C_ADDR 0x3C    // OSD9616 I2C address
//
//Uint8 top [128];
//Uint8 bottom [128];
//
//void main(void)
//{
//	Uint16 i;
//
//	USBSTK5515_init();//Initializing the Processer
//	oled_init();
//
//	//Making the zig-zag -- 10.1.3 Set Memory Addressing Mode (page addressing mode: 128 x 8)
//	for(i = 0; i<16; i++)
//	{
//		if(i<8)
//		{
//			top[i] = 0x01 << i;
//			bottom[i] = 0;
//		}
//		else
//		{
//			top[i] = 0;
//			bottom[i] = 0x01 << (i-8);
//		}
//	}
//	for(i = 16; i<32; i++)
//	{
//		if(i<24)
//		{
//			top[i] = 0;
//			bottom[i] = 0x80 >> (i-16);
//		}
//		else
//		{
//			top[i] = 0x80 >> (i-24);
//			bottom[i] = 0;
//		}
//	}
//	for(i=32; i<48; i++)
//	{
//		if(i<40)
//		{
//			top[i] = 0x01 << (i-32);
//			bottom[i] = 0;
//		}
//		else
//		{
//			top[i] = 0;
//			bottom[i] = 0x01 << (i-40);
//		}
//	}
//	for(i=48; i<64; i++)
//	{
//		if(i<56)
//		{
//			top[i] = 0;
//			bottom[i] = 0x80 >> (i-48);
//		}
//		else
//		{
//			top[i] = 0x80 >> (i-56);
//			bottom[i] = 0;
//		}
//	}
//
//	for(i = 0; i<16; i++)
//	{
//		if(i<8)
//		{
//			top[i + 64] = 0x01 << i;
//			bottom[i + 64] = 0;
//		}
//		else
//		{
//			top[i + 64] = 0;
//			bottom[i + 64] = 0x01 << (i-8);
//		}
//	}
//	for(i = 16; i<32; i++)
//	{
//		if(i<24)
//		{
//			top[i + 64] = 0;
//			bottom[i + 64] = 0x80 >> (i-16);
//		}
//		else
//		{
//			top[i + 64] = 0x80 >> (i-24);
//			bottom[i + 64] = 0;
//		}
//	}
//	for(i=32; i<48; i++)
//	{
//		if(i<40)
//		{
//			top[i + 64] = 0x01 << (i-32);
//			bottom[i + 64] = 0;
//		}
//		else
//		{
//			top[i + 64] = 0;
//			bottom[i + 64] = 0x01 << (i-40);
//		}
//	}
//	for(i=48; i<64; i++)
//	{
//		if(i<56)
//		{
//			top[i + 64] = 0;
//			bottom[i + 64] = 0x80 >> (i-48);
//		}
//		else
//		{
//			top[i + 64] = 0x80 >> (i-56);
//			bottom[i + 64] = 0;
//		}
//	}
//	//Done makeing the zig-zag
//	printf("Here we go\n");
//
//    OSD9616_send(0x00,0xb0);   // Set page for page pointer to page 0
//	for(i=0; i<128; i++)
//	{
//		OSD9616_send(0x40, top[i]); //Writes the top page
//	}
//
//    OSD9616_send(0x00,0xb0+1);   // Set page for page pointer to page 1
//
//    for(i=0; i<128; i++)
//    {
//    	OSD9616_send(0x40, bottom[i]);//Writes the bottom page
//    }
//}
//
//    /** The code includes several header files, including stdio.h, and some specific to the USBSTK5515 development kit, I2C communication, LCD, OLED, and GPIO.
//     * The main function is the entry point of the program.
//     * It initializes the USBSTK5515 processor and the OLED display using USBSTK5515_init() and oled_init().
//     * The code then defines two arrays, top and bottom, each of size 128. These arrays appear to be used to create a zig-zag pattern that will be displayed on the OLED screen.
//     * Several loops fill the top and bottom arrays with values to create the zig-zag pattern.
//     * The code sends data to the OLED display using the OSD9616_send function. It sets the page pointer to page 0 and page 1 (likely corresponding to the top and bottom halves of the display), and then it sends the data from the top and bottom arrays to the display.
//     * Finally, the code prints "Here we go" to the standard output (likely a console) using printf. **/
