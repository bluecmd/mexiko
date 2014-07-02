/*
 * Bootloader for Mexiko.
 * Copy stage two bootloader from BPI flash.
 */

#include "bootrom_config.h"

.org 0x100

.global _start
_start:
  l.jal   uart_init
   l.nop
  l.movhi r3,hi(txt_banner)
  l.jal   print_str
   l.ori  r3,r3,lo(txt_banner)

copy_init:
  l.jal   flash_init
   l.movhi r6,0
  l.movhi r7,0xffff
copy:
  l.jal   flash_read_byte
  l.add   r8,r1,r6
  l.sb    0(r8),r3
  l.addi  r6,r6,1
  l.sfeqi r6,0x4
  l.bf    store_sizeword
    l.nop

  # Show progress on UART
  l.andi  r8,r6,0xffff
  l.sfeqi r8,0
  l.bnf   1f
   l.nop
  l.jal   uart_putc
   l.ori  r10,r0,'.'
1:
  # Check if we've finished loading the words
  l.sfeq  r6,r7
  l.bnf   copy
   l.nop

goto_reset:
  l.jal   uart_putc
   l.ori  r10,r0,'!'
  l.jal   uart_putc
   l.ori  r10,r0,'\r'
  l.jal   uart_putc
   l.ori  r10,r0,'\n'
  l.ori   r1,r1,RESET_ADDR
  l.jal   flash_deinit
   l.nop
  l.jr    r1
   l.nop

store_sizeword:
  # The sizeword is the first word in the RAM.
  # Chop it in half, save it to r10 and sanity check that we're not about to
  # read more than MAX_SIZEWORD.
  l.lwz   r7,0(r1)
  l.srli  r10,r7,16
  l.sfleui r10,MAX_SIZEWORD
  l.bf    copy
   l.nop
  l.movhi r3,hi(txt_invalid_size)
  l.jal   print_str
   l.ori  r3,r3,lo(txt_invalid_size)
  l.j     _start
   l.nop

print_str:
  # Print memory in r3 until \0 is found
  l.ori   r28,r9,0
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
  l.jr    r28
   l.nop

txt_banner:
  .string "\r\nMexiko Boot ROM\r\nLoading from flash: \0"
  .align 4
txt_invalid_size:
  .string "Invalid size on payload, resetting...\r\n\0"
  .align 4
