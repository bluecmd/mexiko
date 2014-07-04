#ifndef __HEADER_BOOTROM_CONFIG__
#define __HEADER_BOOTROM_CONFIG__

#define UART            0xe0000000
#define SYS_CLK         80000000
#define BAUD            115200

#define RAM_BASE        0x0
#define RAM_LOAD_BASE   RAM_BASE
#define RESET_ADDR      0x100

/* Sanity check: reset if we're about to read more than 32 MB. */
#define MAX_SIZEWORD_HI 0x0200

#define ROM_BASE        0xec000000
#define PROGRAM_NORMAL  0x0
#define PROGRAM_DIAG    0x1f00000

#endif
