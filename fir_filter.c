#include <usbstk5515.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "bandpass.h"

// Direct-Form FIR Filter Implementation
short FIR(Int16 x, Int16 * w) {
    long y = 0;  // 32-bit word
    short i;

    // Step 1: Set w0 = x;
    w[0] = x;

    // Step 2: Multiply accumulate filter taps and tapped delay line
    for (i = 0; i < BPL; i++) {
        y += BP[i] * (long) w[i];  // Q16.15 * Q16.15 = Q32.30
    }

    // Step 3: Shift the delay line by one
    for (i = BPL; i >= 1; i--) {
        w[i] = w[i - 1];
    }
    
    y += 0x00004000; // Round the part we'll be truncating (Carry bit of this sum will be the LSB after conversion)
    return y >> 15;  // Conversion: Q32.30 --> Q16.15.
}


void main(void) {

    USBSTK5515_init();

    FILE *fpIn, *fpOut;

    fpIn = fopen("..\\data\\input.pcm", "rb");  // Read operation. File pointer starts at beginning of file.
    fpOut = fopen("..\\data\\output.pcm", "wb");  // Write operation. File pointer starts at beginning of file.

    if (fpIn == NULL) {
        printf("Can't open input file\n");
        exit(0);
    }
    
    char temp[2];
    Int16 input, output = 0;

    Int16 w[BPL];       // Tapped delay line
    memset(w, 0, BPL);  // Initialize with zeros

    while (fread(temp, sizeof(char), 2, fpIn) == 2) {
        // Read 2 8-bit words.
        input = temp[0] | (temp[1] << 8);

        // Perform a filter operation
        output = FIR(input, w);

        temp[0] = output & 0x00FF;
        temp[1] = (output & 0xFF00) >> 8;

        // Write 2 8-bit words.
        fwrite(temp, sizeof(char), 2, fpOut);
    }

    fclose(fpOut);
    fclose(fpIn);
    printf("Filtering complete! \n");
}
