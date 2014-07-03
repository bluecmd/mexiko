#ifndef __HEADER_MEXIKO__
#define __HEADER_MEXIKO__

#define SYS_CLK       80000000
#define RAM_BASE      0
#define RAM_SIZE      0x40000000 /* 1 GiB */
#define RESERVED_RAM  0x40000    /* 256 KiB for diag program */

#define UART_BASE     0x90000000
#define UART_BAUD     115200
#define UART_IRQ      13

#endif
