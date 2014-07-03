#include "mexiko.h"

.global _board_mem_base
.global _board_mem_size
.global _board_clk_freq

.global _board_uart_base
.global _board_uart_baud
.global _board_uart_IRQ

_board_clk_freq:  .long SYS_CLK

_board_mem_base:  .long RAM_BASE
_board_mem_size:  .long RESERVED_RAM

_board_uart_base: .long UART_BASE
_board_uart_baud: .long UART_BAUD
_board_uart_IRQ:  .long UART_IRQ
