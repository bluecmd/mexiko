#include "mexiko.h"

.global _board_mem_base
.global _board_mem_size
.global _board_clk_freq

.global _board_uart_base
.global _board_uart_baud
.global _board_uart_IRQ

.global _board_exit

_board_clk_freq:  .long SYS_CLK

_board_mem_base:  .long RAM_BASE
_board_mem_size:  .long RESERVED_RAM

_board_uart_base: .long UART_BASE
_board_uart_baud: .long UART_BAUD
_board_uart_IRQ:  .long UART_IRQ

_board_exit:
  l.movhi r3,hi(txt_system_halted)
  l.ori   r3,r3,lo(txt_system_halted)
  l.movhi r29,hi(UART_BASE)
  l.ori   r29,r29,lo(UART_BASE)
1:
  l.lbz   r10,0(r3)
  l.sfeq  r10,r0
  l.bf    1f
   l.nop
  l.jal   uart_putc
   l.nop
  l.j     1b
   l.addi r3,r3,0x1
1:
  l.j     1b
   l.nop

uart_putc:
  # Prints r10 to UART
  # Wait for ready
  l.lbz   r5,5(r29)
  l.andi  r5,r5,0x20
  l.sfeqi r5,0x20
  l.bnf   uart_putc
   l.nop
  # Write character to UART
  l.sb    0(r29),r10
1:
  # Wait for ready
  l.lbz   r5,5(r29)
  l.andi  r5,r5,0x60
  l.sfeqi r5,0x60
  l.bnf   1b
   l.nop
  # Done
  l.jr    r9
   l.nop

txt_system_halted:
  .string "System halted\r\n"
  .align 4
