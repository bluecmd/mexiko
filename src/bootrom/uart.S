#include "bootrom_config.h"

#define UART_DIVISOR   SYS_CLK/(16*BAUD)
#define UART_DLL       0
#define UART_DLM       1

.global uart_init
.global uart_getc
.global uart_putc
.global uart_put_hex
.global uart_put_word
.global uart_print_str

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
  l.bnf   _jr_slide
   l.lbz  r10,0(r29)
  l.ori   r10,r0,0
_jr_slide:
  l.jr    r9
   l.nop

uart_print_str:
  # Print memory in r3 until \0 is found
  l.ori   r28,r9,0
1:
  l.lbz   r10,0(r3)
  l.sfeq  r10,r0
  l.bf    _jr_slide
   l.ori  r9,r28,0
  l.jal   uart_putc
   l.nop
  l.j     1b
   l.addi r3,r3,0x1

uart_put_word:
  l.ori   r11,r9,0
  l.srli  r10,r6,24
  l.jal   uart_put_hex
   l.nop
  l.srli  r10,r6,16
  l.jal   uart_put_hex
   l.andi r10,r10,0xff
  l.srli  r10,r6,8
  l.jal   uart_put_hex
   l.andi r10,r10,0xff
  l.jal   uart_put_hex
   l.andi r10,r6,0xff
  l.ori   r10,r0,' '
  l.j     uart_putc
   l.ori  r9,r11,0

uart_put_hex:
  l.ori   r2,r9,0
  l.andi  r4,r10,0xf
  l.srli  r10,r10,4
  l.ori   r10,r10,'0'
  l.sfgtui r10,'9'
  l.bnf  1f
   l.nop
  l.addi  r10,r10,7
1:
  l.jal   uart_putc
   l.nop
  l.ori   r9,r2,0
  l.ori   r10,r4,'0'
  l.sfgtui r10,'9'
  l.bnf   uart_putc
   l.nop
  l.addi  r10,r10,7
  # Fall through to uart_putc

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
