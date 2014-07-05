#include "bootrom_config.h"

#define UART_DIVISOR   SYS_CLK/(16*BAUD)
#define UART_DLL       0
#define UART_DLM       1

.global uart_init
.global uart_getc
.global uart_putc

uart_init:
  l.movhi r29,hi(UART)
  l.ori   r29,r29,lo(UART)

  # Set up ttyS0
  l.addi  r3,r0,0x7
  l.sb    0x2(r29),r3

  l.addi  r3,r0,0x0
  l.sb    0x1(r29),r3

  l.addi  r3,r0,0x3
  l.sb    0x3(r29),r3

  l.lbz   r5,3(r29)
  l.ori   r3,r5,0x80
  l.sb    0x3(r29),r3
  l.addi  r3,r0,((UART_DIVISOR>>8) & 0x000000ff)
  l.sb    UART_DLM(r29),r3
  l.addi  r3,r0,((UART_DIVISOR) & 0x000000ff)
  l.sb    UART_DLL(r29),r3
  l.jr    r9
   l.sb   0x3(r29),r5

uart_getc:
  l.lbz   r5,5(r29)
  l.andi  r5,r5,0x01
  l.sfeq  r5,r0
  l.bnf   1f
   l.lbz  r10,0(r29)
  l.ori   r10,r0,0
1:
  l.jr    r9
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
