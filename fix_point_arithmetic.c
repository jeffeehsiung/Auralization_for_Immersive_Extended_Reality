#include <math.h>
#include <stdio.h>

int main(void){

   // assume 16 bit variables (memory registors) in Q15 format and one 32 bit variable to store intermediate results (accumulators) in Q31 format.
   int b, c, d, e;
   b = pow(10,4);  // Q15
   c = pow(10,4);  // Q15
   d = pow(10,4);  // Q15
   e = pow(10,4);  // Q15
   long a = 0;
   // program a = b.c.d + e in fixed point c code.
   a = (long)b * c;  // Q15 * Q15 = Q30
   a = a >> 15;  // Q30 >> 15 = Q15
   a = a * (long)d;  // Q15 * Q15 = Q30
   a = a + (long)(e << 15); // Q30 + Q30 = Q31
   int output = (int) (a >> 15); // Q31 >> 15 = Q16
   printf("a = %d\n", a);
   return 0;
}
