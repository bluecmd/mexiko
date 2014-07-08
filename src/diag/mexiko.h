#ifndef __HEADER_MEXIKO__
#define __HEADER_MEXIKO__

#define SYS_CLK             80000000
#define RAM_SIZE            0x40000000 /* 1 GiB */
#define RESERVED_RAM        0x40000    /* 256 KiB for diag program */

#define FLASH_BASE          0xef000000
#define FLASH_END           0xf0000000

#define UART_BASE           0xe8000000
#define UART_BAUD           115200
#define UART_IRQ            13
#define UART_LSR            5
#define UART_LSR_DR         0x01

#define PROGRAM_LOCATION_BAREBOX    (FLASH_BASE)
#define PROGRAM_MAGIC_BAREBOX       0x42415245 /* BARE in ASCII */
#define PROGRAM_LOCATION_DIAG       (FLASH_BASE + 0x0800000)
#define PROGRAM_MAGIC_DIAG          0x44494147 /* DIAG in ASCII */

#endif
