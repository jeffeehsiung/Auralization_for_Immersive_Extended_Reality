///**
// * Lab4_2.c
// */
//#include "usbstk5515.h"
//#include "usbstk5515_i2c.h"
//#include "aic3204.h"
//#include "oled.h"
//#include "pushbuttons.h"
//#include <stdio.h>
//#include <math.h>
//
//// Define frequency constraints
//#define MIN_FREQUENCY 0.73f
//#define MAX_FREQUENCY 3000.0f
//
//int main(void)
//{
////    const Uint16 L = 64;                /** sample length for one period in the look up table */
//    const Uint16 fs = 48000;
//    Int16 sinetable[64] = {0, 1606, 3196, 4756, 6270, 7723, 9102, 10394, 11585, 12665, 13623, 14449, 15137, 15679, 16069, 16305, 16384, 16305, 16069, 15679, 15137, 14449, 13623, 12665, 11585, 10394, 9102, 7723, 6270, 4756, 3196, 1606, 0, -1606, -3196, -4756, -6270, -7723, -9102, -10394, -11585, -12665, -13623, -14449, -15137, -15679, -16069, -16305, -16384, -16305, -16069, -15679, -15137, -14449, -13623, -12665, -11585, -10394, -9102, -7723, -6270, -4756, -3196, -1606};
//    Uint16 FTV;
//    Uint16 accumulator, temp, key, cnt2;
//    Int16 out;
//    float freq;
//
//    USBSTK5515_init();
//    printf("Which frequency do you like (in Hz)? \n");
//    scanf("%f", &freq);
//
//    FTV = (65536)*freq/fs;
//    printf("FTV value corresponding to %6.21f Hz should be %d\n", freq, FTV);
//
//    aic3204_init();
//    SAR_init();
//
//    accumulator = 0;
//    temp = 0;
//    key = 0;
//    cnt2 = 0;
//
//    char topline[20], bottomline[20];
//
//    while(1) {
//        cnt2++;
//        key = pushbuttons_read_raw();
//
//        // Adjust frequency based on button presses
//        // debounce the switches by checking them only every 100 iteratoins
//        if(cnt2 % 1 == 0){
//        	if (key == 1){	// SW1
//        		freq += 10.0f;
//        		if(freq > MAX_FREQUENCY){freq = MAX_FREQUENCY;}
//        		// update OLED display
//        		sprintf(topline, "Frequency: %.2f Hz", freq);
//        		sprintf(bottomline, "FTV Value: %d", FTV);
//        		oled_display_message(topline, bottomline);
//        	}else if (key == 2){	//SW2
//		        freq = -10.0f;
//		        if(freq < MIN_FREQUENCY){freq = MIN_FREQUENCY;}
//		        // Update OLED display
//		        sprintf(topline, "Frequency: %.2f Hz", freq);
//		        sprintf(bottomline, "FTV Value: %d", FTV);
//		        oled_display_message(topline, bottomline);
//		    }
//        }
//
//        // update FTV based on the current frequency
//        FTV = freq*(65536)/fs;
//        printf("FTV value corresponding to %6.21f Hz should be %d\n", freq, FTV);
//        accumulator += FTV;             // update the phase accumulator for the next sample
//        // Compute the table index: we're using a 64-entry table,
//        // so we need to take the upper 6 bits of the accumulator
//        temp = (accumulator >> 10) & 0x3F;
//
//        /** purpose of the loop is to read values from the sine table and use them to generate audio output */
//        out = sinetable[temp] >> 3;// Scaling factor of (1/8) to reduce the amplitude
//        aic3204_codec_write(out, out);
//    }
//}
