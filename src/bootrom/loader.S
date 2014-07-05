/*
 * Bootloader for Mexiko.
 */

#include "bootrom_config.h"

.org 0x100

.global _start
_start:
  l.movhi r1,hi(RAM_LOAD_BASE)
  l.jal   uart_init
   l.ori  r1,r1,lo(RAM_LOAD_BASE)

  # Install exception vector handler.
  l.movhi r3,hi(vector_bus_error)
  l.ori   r3,r3,lo(vector_bus_error)
  l.lwz   r4,0(r3)
  l.sw    0x200(r0),r4
  l.lwz   r4,4(r3)
  l.sw    0x204(r0),r4
  l.lwz   r4,8(r3)
  l.sw    0x208(r0),r4
  l.lwz   r4,12(r3)
  l.sw    0x20c(r0),r4
1:

  l.movhi r3,hi(txt_banner)
  l.jal   print_str
   l.ori  r3,r3,lo(txt_banner)
  l.movhi r3,hi(txt_timestamp)
  l.jal   print_str
   l.ori  r3,r3,lo(txt_timestamp)

  # Wait a while for key presses.
  l.movhi r10,0x2
1:
  l.sfeq  r10,r0
  l.bnf 1b
   l.addi r10,r10,-1

  # If user presses 'd', load diagnostics image.
  l.jal   uart_getc
   l.nop
  l.sfeqi r10,0x64
  l.bnf   copy_init
   l.movhi r27,hi(PROGRAM_NORMAL)
  l.movhi r27,hi(PROGRAM_DIAG)

  l.movhi r3,hi(txt_diagnostics)
  l.jal   print_str
   l.ori  r3,r3,lo(txt_diagnostics)

copy_init:
  l.jal   flash_init
   l.nop
  l.movhi r3,hi(txt_loading)
  l.jal   print_str
   l.ori  r3,r3,lo(txt_loading)

  l.movhi r6,0
  l.ori   r6,r6,4
  l.movhi r7,0xffff

  # Read the sizeword, save it to r7 and sanity check that we're not
  # about to read more than MAX_SIZEWORD.
  l.jal   flash_read_word
   l.nop
  l.ori   r7,r3,0
  l.srli  r10,r7,16
  l.sfleui r10,MAX_SIZEWORD_HI
  l.bf    copy_vectors
   l.nop
  l.movhi r3,hi(txt_invalid_size)
  l.jal   print_str
   l.ori  r3,r3,lo(txt_invalid_size)
  l.j     _start
   l.nop

copy_vectors:
  # Assuming that vectors are small, move 0x200 to 0x0 in order to
  # be able to catch bus errors with our own exception handler.
  # In goto_reset we will move it back.
  l.add   r8,r1,r6
  l.sfltui r8,0x210
  l.bnf   copy_word
   l.nop
  l.jal   flash_read_word
   l.nop
  l.sfgeui r8,0x200
  l.bnf    1f
   l.addi  r6,r6,4
  l.andi   r8,r8,0xff
1:
  l.j     copy_vectors
   l.sw    0(r8),r3

copy_word:
  l.jal   flash_read_word
   l.add  r8,r1,r6
  l.sw    0(r8),r3
  l.addi  r6,r6,4

  # Show progress on UART
  l.andi  r8,r6,0x3ff
  l.sfeqi r8,0
  l.bnf   1f
   l.nop
  l.jal   uart_putc
   l.ori  r10,r0,'.'
1:
  # Check if we've finished loading the words
  l.sfgeu r6,r7
  l.bnf   copy_word
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
  # Replace our bus vector with the program's.
  l.lwz   r4,0(r0)
  l.sw    0x200(r0),r4
  l.lwz   r4,4(r0)
  l.sw    0x204(r0),r4
  l.lwz   r4,8(r0)
  l.sw    0x208(r0),r4
  l.lwz   r4,12(r0)
  l.sw    0x20c(r0),r4
  l.jr    r1
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

vector_bus_error:
  l.movhi r9,hi(exception_bus_error)
  l.ori   r9,r9,lo(exception_bus_error)
  l.jr    r9
   l.nop

exception_bus_error:
  l.movhi r3,hi(txt_bus_error)
  l.jal   print_str
   l.ori  r3,r3,lo(txt_bus_error)
1:
  l.j     1b
   l.nop

txt_banner:
  .string "\r\nMexiko Boot ROM - compiled "
  .align 4
txt_timestamp:
  .string TIMESTAMP
  .align 4
txt_loading:
  .string "\r\nLoading from flash: "
  .align 4
txt_invalid_size:
  .string "Invalid size on payload, resetting...\r\n"
  .align 4
txt_diagnostics:
  .string "\r\nDiagnostics mode enabled"
  .align 4
txt_bus_error:
  .string "\r\nBus error - system halted\r\n"
  .align 4
