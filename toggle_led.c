//#include <usbstk5515.h>
//#include <stdio.h>
//
////Addresses of the MMIO for the GPIO out registers: 1,2 (IODATAOUT1 1C0Ah or IODATAOUT2 1C0Bh)
//#define LED_OUT1 *((ioport volatile Uint16*) 0x1C0A)   //0x1C0A SYS_GPIO_DATAOUT0
//#define LED_OUT2 *((ioport volatile Uint16*) 0x1C0B)   //0x1C0B SYS_GPIO_DATAOUT1
//
////Addresses of the MMIO for the GPIO direction registers: 1,2 (IODIR1 1C06h and IODIR2 1C07h)
//#define LED_DIR1 *((ioport volatile Uint16*) SYS_GPIO_DIR0)   //0x1C06 SYS_GPIO_DIR0
//#define LED_DIR2 *((ioport volatile Uint16*) SYS_GPIO_DIR1)   //0x1C07 SYS_GPIO_DIR1
//
////Toggles LED specified by index Range 0 to 3
//void toggle_LED(int index)
//{
//    if(index == 3) //Blue: GPIO14
//        LED_OUT1 = LED_OUT1 ^ (1 << 14);
//    else if(index == 2) //Yellow(ish): GPIO15
//        LED_OUT1 = LED_OUT1 ^ (1 << 15);
//    else if(index == 1) //Red: GPIO16
//        LED_OUT2 = LED_OUT2 ^ (1 << 0);
//    else if(index == 0) //Green: GPIO17
//        LED_OUT2 = LED_OUT2 ^ (1 << 1);
//}
////Makes the GPIO associated with the LEDs the correct direction; turns them off
//void My_LED_init()
//{
//    LED_DIR1 |= (3 << 14);
//    LED_DIR2 |= (3 << 0);
//    LED_OUT1 |= (3 << 14); //Set LEDs 0, 1 to off
//    LED_OUT2 |= (3 << 0); //Set LEDs 2, 3 to off
//}
//void main(void)
//{
//    Uint16 value = 0;
//    USBSTK5515_init(); //Initializing the Processor
//    My_LED_init();
//    while(1)
//    {
//        printf("Which LED shall we toggle(0, 1, 2, or 3)?\n");
//
//        scanf("%d",&value);
//        toggle_LED(value);
//    }
//}
