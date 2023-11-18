#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "cFir.h"

// Define DSP system memory map  
#pragma DATA_SECTION(firCoefFixedPoint, ".data:fir");
#pragma DATA_SECTION(w, ".bss:fir");

short firCoefFixedPoint[NUM_TAPS] = {
   #include "firCoef.h"
};

short w[NUM_TAPS];
short x, y;

int main()
{
  FILE  *fpIn, *fpOut;

  short index;  // Delay line index
  char  temp[2];

  fpIn = fopen("..\\data\\input.pcm", "rb");
  fpOut = fopen("..\\data\\output.pcm", "wb");

  if (fpIn == NULL)
  {
    printf("Can't open input file\n");
    exit(0);
  }

  memset(w, 0, NUM_TAPS);   // Initialize filter taps to zero.
  index = 0;

  // Begin filtering the data
  while (fread(temp, sizeof(char), 2, fpIn) == 2) {
      x = (temp[0] & 0xFF) | (temp[1] << 8);

      // Filter the input data x and save the output data in y
      y = cFir(x, firCoefFixedPoint, w, &index);

      temp[0] = (short) (y & 0x00FF);
      temp[1] = (short) (y & 0xFF00) >> 8;

      fwrite(temp, sizeof(char), 2, fpOut);
  }

  printf("Filtering completed!\n");
  fclose(fpIn);
  fclose(fpOut);
  return 0;
}
