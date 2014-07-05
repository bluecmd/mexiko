/*
 * Bootloader for Mexiko.
 */

#include "bootrom_config.h"

.org 0x0
txt_banner:
  .string "\r\nMexiko Boot ROM - compiled "
  .string TIMESTAMP
  .align 4
txt_loading:
  .string "\r\nLoading from flash: "
  .align 4
txt_invalid_size:
  .string "\r\nInvalid size on payload, resetting...\r\n"
  .align 4
txt_diagnostics:
  .string "\r\nDiagnostics mode"
  .align 4
txt_bus_error:
  .string "\r\nBus error, system halted\r\n"
  .align 4
txt_size:
  .string "\r\nImage size: "
  .align 4
txt_erase_word:
  .string "\b\b\b\b\b\b\b\b\b"
  .align 4
txt_ok:
  .string "OK\r\n"
  .align 4
txt_err:
  .string "ERR\r\n"
  .align 4

vector_bus_error:
  l.movhi r9,hi(exception_bus_error)
  l.ori   r9,r9,lo(exception_bus_error)
  l.jr    r9
   l.nop

exception_bus_error:
  l.movhi r3,hi(txt_bus_error)
  l.jal   uart_print_str
   l.ori  r3,r3,lo(txt_bus_error)
1:
  l.j     1b
   l.nop

.org 0x100

.global _start
_start:
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
  l.jal   uart_init
   l.sw   0x20c(r0),r4

1:
  l.movhi r3,hi(txt_banner)
  l.jal   uart_print_str
   l.ori  r3,r3,lo(txt_banner)
  l.jal   uart_print_str
   # .string appends a \0, so we need to call the function twice but with +1
   # to skip the \0.
   l.addi r3,r3,1

  # Wait a while for key presses.
  l.movhi r10,0x2
1:
  l.sfeq  r10,r0
  l.bnf 1b
   l.addi r10,r10,-1

  # If user presses 'd', load diagnostics image.
  l.jal   uart_getc
   l.ori  r21,r0,0
  l.sfeqi r10,0x64
  l.bnf   copy_init
   l.movhi r27,hi(PROGRAM_NORMAL)
  l.movhi r27,hi(PROGRAM_DIAG)

  l.movhi r3,hi(txt_diagnostics)
  l.jal   uart_print_str
   l.ori  r3,r3,lo(txt_diagnostics)

copy_init:
  l.movhi r25,hi(ROM_BASE+4)
  l.ori   r25,r25,lo(ROM_BASE+4)
  l.add   r25,r25,r27
  l.movhi r20,hi(txt_erase_word)

  # Read the sizeword, save it to r7 and sanity check that we're not
  # about to read more than MAX_SIZEWORD.
  l.lwz   r7,-4(r25)
  l.ori   r20,r20,lo(txt_erase_word)

  # Print sizeword
  l.movhi r3,hi(txt_size)
  l.jal   uart_print_str
   l.ori  r3,r3,lo(txt_size)

  l.jal   uart_put_word
   l.ori  r6,r7,0

  l.srli  r3,r7,16
  l.sfeq  r7,r0
  l.bf    1f
   l.sfleui r3,MAX_SIZEWORD_HI
  l.bf    copy_start
1:
   l.movhi r3,hi(txt_invalid_size)
  l.jal   uart_print_str
   l.ori  r3,r3,lo(txt_invalid_size)
  l.j     _start
   # Don't care what ends up in the delay slot

copy_start:
  l.ori   r6,r0,4

  l.movhi r3,hi(txt_loading)
  l.jal   uart_print_str
   l.ori  r3,r3,lo(txt_loading)
copy_vectors:
  # Assuming that vectors are small, move 0x200 to 0x0 in order to
  # be able to catch bus errors with our own exception handler.
  # In goto_reset we will move it back.
  l.sfltui r6,0x210
  l.bnf   copy_word
   l.nop
  l.lwz   r3,0(r25)
  l.addi  r25,r25,4
  l.ori   r8,r6,0
  l.sfgeui r6,0x200
  l.bnf   1f
   l.addi r6,r6,4
  l.andi  r8,r8,0xff
1:
  l.j     copy_vectors
   l.sw   0(r8),r3

copy_word:
  l.lwz   r3,0(r25)
  l.addi  r6,r6,4
  l.sw    -4(r6),r3
  l.xor   r3,r6,r3

  # Show progress on UART
  l.andi  r8,r6,0x3fff
  l.sfeqi r8,0
  l.bnf   1f
   l.add  r21,r21,r3
  l.jal   uart_put_word
   l.nop
  l.jal   uart_print_str
   l.ori  r3,r20,0
1:
  # Check if we've finished loading the words
  l.sfgeu r6,r7
  l.bnf   copy_word
   l.addi r25,r25,4

goto_reset:
  l.jal   uart_put_word
   l.ori  r22,r0,0
  l.jal   uart_put_word
   l.ori  r6,r21,0

  # Verify data in memory
  l.ori   r6,r0,0x210
1:
  l.lwz   r3,0(r6)
  l.addi  r6,r6,4
  l.xor   r3,r6,r3
  l.sfgeu r6,r7
  l.bnf   1b
   l.add  r22,r22,r3

  # Compare
  l.sfeq  r22,r21
  l.bf    1f
   l.movhi r3,hi(txt_ok)

  l.movhi r3,hi(txt_err)
  l.jal   uart_put_word
   l.ori  r6,r22,0

  l.jal   uart_print_str
   l.ori  r3,r3,lo(txt_err)
  l.j     _start
   # Don't care about the delay slot
1:
  l.ori   r6,r21,0
  l.jal   uart_print_str
   l.ori  r3,r3,lo(txt_ok)

  l.ori   r1,r0,RESET_ADDR
  # Replace our bus vector with the program's.
  l.lwz   r4,0(r0)
  l.sw    0x200(r0),r4
  l.lwz   r4,4(r0)
  l.sw    0x204(r0),r4
  l.lwz   r4,8(r0)
  l.sw    0x208(r0),r4
  l.lwz   r4,12(r0)
  l.jr    r1
   l.sw   0x20c(r0),r4
