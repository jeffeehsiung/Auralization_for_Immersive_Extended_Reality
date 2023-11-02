///**
// * Lab4_1.c
// */
//#include "usbstk5515.h"
//#include "usbstk5515_i2c.h"
//#include "aic3204.h"
//#include "oled.h"
//#include <stdio.h>
//#include <math.h>
//
//int main(void)
//{
//    const Uint16 L = 64;                /** sample length for one period in the look up table */
//	const Uint16 fs = 48000;            /** default sampling frequency of AIC3204 codec */
//	Int16 sinetable[64] = {0, 1606, 3196, 4756, 6270, 7723, 9102, 10394, 11585, 12665, 13623, 14449, 15137, 15679, 16069, 16305, 16384, 16305, 16069, 15679, 15137, 14449, 13623, 12665, 11585, 10394, 9102, 7723, 6270, 4756, 3196, 1606, 0, -1606, -3196, -4756, -6270, -7723, -9102, -10394, -11585, -12665, -13623, -14449, -15137, -15679, -16069, -16305, -16384, -16305, -16069, -15679, -15137, -14449, -13623, -12665, -11585, -10394, -9102, -7723, -6270, -4756, -3196, -1606};
//
//	Uint16 FTV;                 /** to control the speed of reading the sine table */
//	Uint16 accumulator;
//	Int16 out;
//	float freq;
//
//	USBSTK5515_init();
//	printf("Which frequency do you like (in Hz)? \n");
//	scanf("%f", &freq);                 /** desired frequency */
//
//	FTV = freq*(2^16)/fs;     /** Frequency Tuning Value is the phase step size mu. -- */
//
//	printf("FTV value corresponding to %6.21f Hz should be %d\n", freq, FTV);
//	aic3204_init();                     /** default sampling frequency 48kHz */
//
//	accumulator = 0;
//	while(1) {
//        accumulator += FTV; 
//      //Compute the table index: we're using a 64-entry table,
//      // so we need to take the upper 6 bits of the accumulator
//        temp = (accumulator >> 10) & 0x3F;

//	    /** purpose of the loop is to read values from the sine table and use them to generate audio output */
//	  out = sinetable[temp] >> 3;// Scaling factor of (1/8) to reduce the amplitude
//        aic3204_codec_write(out, out);
//
//	}
//}
