#include "cFir.h"

// Define DSP system memory map  
#pragma CODE_SECTION(cFir, ".text:fir");

// Direct-Form FIR Filter Implementation with circular buffer
short cFir(short x, short *h, short *w, short *index) {
/*
 * x: input sample (16-bit)
 * h: pointer to filter taps
 * w: pointer to delay line
 * index: current index in filter delay line
*/
    short i, k;
    long accumulator = 0;

    k = *index;

    // Add current sample to delay line
    w[k] = x;

    for (i = 0; i < NUM_TAPS; i++)  // FIR filter processing
    {
      // Multiply and accumulate using circular buffer index
      int bufferIndex = (k - i + NUM_TAPS) % NUM_TAPS;
      accumulator += (long) w[bufferIndex] * h[i];
    }

    *index = (k == 0) ? NUM_TAPS - 1 : k - 1;  // Update circular buffer index.

    accumulator += 0x00004000;  // Round the part we'll be truncating (Carry bit will be the LSB after cast to short)
    return (short) (accumulator >> 15);  // Return filter output
}
