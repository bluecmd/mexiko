#ifndef __HEADER_BOOTROM_CONFIG__
#define __HEADER_BOOTROM_CONFIG__

#define UART           0x90000000
#define SYS_CLK        80000000
#define BAUD           115200

#define RAM_BASE       0x0
#define RAM_LOAD_BASE  RAM_BASE
#define RESET_ADDR     0x100

/* Sanity check: reset if we're about to read more than 32 MB. */
#define MAX_SIZEWORD   0x200

#endif
