#ifndef __HEADER_BOOTROM_CONFIG__
#define __HEADER_BOOTROM_CONFIG__

#define UART            0xe8000000
#define SYS_CLK         80000000
#define BAUD            115200

#define RESET_ADDR      0x100

/* Sanity check: reset if we're about to read more than 8 MB. */
#define MAX_SIZEWORD_HI 0x0080

#define ROM_BASE        0xef000000
#define PROGRAM_NORMAL  0x0
#define PROGRAM_DIAG    0x800000

#endif
