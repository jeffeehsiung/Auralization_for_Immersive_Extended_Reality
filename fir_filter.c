
#include <usbstk5515.h>
#include <usbstk5515_i2c.h>
#include <aic3204.h>
#include <stdio.h>

#include "filter.h"

/** size of data type:
 * unsigned int in C has 2 bytes
 * short int in C has 2 bytes
 * char in C has 1 byte
 * long int in C has 4 bytes
 */
//short x[BPL] = {0};

short FIR(unsigned int i) {
    static short filter_state[BPL] = {0}; // Initialize filter state to zeros
    long sum = 0;
    unsigned int j;

    // Update filter state by shifting samples
    for (j = BPL - 1; j > 0; j--) {
        filter_state[j] = filter_state[j - 1];
    }

    // Place the new sample at the beginning of the filter state
    filter_state[0] = (short)i;

    // FIR Filter Code here...
    for (j = 0; j < BPL; j++) {
        sum += (long)BP[j] * filter_state[j];
    }

    return (short)(sum >> 15); // Conversion: 32Q30 --> 16Q15.

//    Uint16 j;
//    long index;
//    long sum = 0;
//
//    /** filter */
//    for(j=0; j < BPL; j++){
//        if(i>=j)
//            index = i-j;
//        else
//            index = BPL + i -j;
//        sum += (long)x[index] * (long)BP[j];
//    }
//
//    sum = sum + 0x00004000; // round rather than truncate.
//    return (short)(sum >> 15); // conversion: 32Q30 --> 16Q15.
}

void main(void) {

    USBSTK5515_init();
    aic3204_init();

    FILE *fpIn, *fpOut;

    fpIn = fopen("..\\data\\input.pcm", "rb");    // Read
    fpOut = fopen("..\\data\\output.pcm", "wb");    // Write

    if (fpIn == NULL) {
        printf("Can't open input file\n");
    }

    if (fpOut == NULL) {
        printf("Can't open output file\n");
    }
//    Uint16 i;
    char temp[2];
    while (fread(temp, sizeof(char), 2, fpIn) == 2) {

        /** read a little-endian sample */
        short input_sample = ((short)temp[1] << 8) | (temp[0]);

//        /** store the latest sample */
//        if(i >= BPL) i = 0;
//        x[i] = input_sample;
//        /** apply the fir filter */
//        short output_sample = FIR(i);
        short output_sample = FIR((unsigned int)input_sample);

        /** write the filtered sample to the output file */
        fwrite(&output_sample, sizeof(short), 1, fpOut);
//        i++;
    }
    printf("Filtering complete!");
}
