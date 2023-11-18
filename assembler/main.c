/**
 * main.c
 */
#include <stdio.h>

// assembler header files for linking
#include "sum.h"
#include "subtract.h"
#include "multiply.h"
#include "sum_array.h"
#include "mul_array.h"

// code section memory allocation
#pragma CODE_SECTION(sum,       ".text:sum");
#pragma CODE_SECTION(subtract,  ".text:subtract");
#pragma CODE_SECTION(multiply,  ".text:multiply");
#pragma CODE_SECTION(sum_array, ".text:sum_array");
#pragma CODE_SECTION(mul_array, ".text:mul_array");

#define LEN 5

int main(void)
{
    // Flag to test if code succeeded
    int flag = 1;

    short x = 5;
    short y = 3;

    // Test sum
    if ( sum(x, y) == (x + y) ) {
        printf("Sum successfully completed.\n");
    } else {
        printf("Sum failed.\n");
        flag = 0;
    }

    // Test subtract
    if ( subtract(x, y) == (x - y) ) {
        printf("Subtracting successfully completed.\n");
    } else {
        printf("Subtracting failed.\n");
        flag = 0;
    }

    // Test multiply
    if ( multiply(x, y) == (x * y) ) {
        printf("Multiplication successfully completed.\n");
    } else {
        printf("Multiplication failed.\n");
        flag = 0;
    }

    // Test sum over array
    short a[LEN] = {1, 2, 3, 4, 5};
    long s = 0;

    short i;
    for (i = 0; i < LEN; i++) {
        s += a[i];
    }

    if ( sum_array(a, LEN) == s ) {
        printf("Sum over array successfully completed.\n");
    } else {
        printf("Sum over array failed.\n");
        flag = 0;
    }

    s = 1;
    for (i = 0; i < LEN; i++) {
        s *= a[i];
    }
    // Test multiply over array
    if ( mul_array(a, LEN) == s ) {
        printf("Multiply over array successfully completed.\n");
    } else {
        printf("Multiply over array failed.\n");
        flag = 0;
    }

    if (flag) {
        printf( "=========================\nHooray, all tests passed!\n");
    }

}
