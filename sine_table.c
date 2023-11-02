///*
// * main.c
// */
//
//#include <stdio.h>
//#include <math.h>
//#include "usbstk5515.h"
//#include "usbstk5515_i2c.h"
//#include "lcd.h"
//#include "oled.h"
//#include "usbstk5515_gpio.h"
//
//#define OSD9616_I2C_ADDR 0x3C    // OSD9616 I2C address
//
//int main(void)
//{
//	int L1 = 128;
//	int L2 = 16;
//	int L3 = 96;
//	int i;
//
//	USBSTK5515_init();//Initializing the Processer
//	oled_init();
//	// sine table with sample length 128 and fix point 16Q14
//	int sine_table[16] = {
//	                      0, 6270, 11585, 15137, 16384, 15137, 11585, 6270, 0, -6270, -11585, -15137, -16384, -15137, -11585, -6270
//	};
//
//	int oled_table[128];
//
//	int period = 6; // 1, 3, 6
//
//    int step = L3/(L2*period); // 6, 2, 1
//
//	// iterate through the sine table to populate top and bottom arrays
//	for (i= 0; i < L1; i++){
//	    if((i % step) == 0){
//	        oled_table[i] = sine_table[(i/step)%L2];
//	    }else{
//	        oled_table[i] = -1;
//	    }
//	}
//
//    oled_display_waveform(oled_table);
//
//    return 0;
//
//}
//
