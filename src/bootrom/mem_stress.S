#include "bootrom_config.h"

.org 0x0
txt_banner:
  .string "\r\nMemory stress test\r\n"
  .align 4
txt_erase_word:
  .string "\b\b\b\b\b\b\b\b\b"
  .align 4
txt_bus_error:
  .string "\r\nBus error, system halted\r\n"
  .align 4
txt_writing:
  .string "Writing: "
  .align 4
txt_verifying:
  .string "\r\nVerifying: "
  .align 4
txt_failed:
  .string "\r\nFailed @ "
  .align 4
txt_done:
  .string "\r\nDone\r\n"
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

  l.movhi r3,hi(txt_banner)
  l.jal   uart_print_str
   l.ori  r3,r3,lo(txt_banner)

  l.movhi r21,hi(MEM_STOP)
  l.ori   r21,r21,lo(MEM_STOP)
  l.movhi r20,hi(txt_erase_word)
  l.ori   r20,r20,lo(txt_erase_word)

  l.movhi r6,hi(MEM_START)
  l.ori   r6,r6,lo(MEM_START)
  l.movhi r3,hi(txt_writing)
  l.jal   uart_print_str
   l.ori  r3,r3,lo(txt_writing)
write_test:
  l.sw    0(r6),r6

  # Show progress on UART
  l.andi  r8,r6,0x3fff
  l.sfeqi r8,0
  l.bnf   1f
   l.nop
  l.jal   uart_put_word
   l.nop
  l.jal   uart_print_str
   l.ori  r3,r20,0
1:
  # Check if we've finished writing
  l.sfgeu r6,r21
  l.bnf   write_test
   l.addi r6,r6,4

  l.movhi r6,hi(MEM_START)
  l.ori   r6,r6,lo(MEM_START)
  l.movhi r3,hi(txt_verifying)
  l.jal   uart_print_str
   l.ori  r3,r3,lo(txt_verifying)
read_test:
  l.lwz   r7,0(r6)
  l.sfeq  r7,r6
  l.bf    1f
   l.nop

  # Failed verification!
  l.movhi r3,hi(txt_failed)
  l.jal   uart_print_str
   l.ori  r3,r3,lo(txt_failed)
  l.jal   uart_put_word
   l.nop

  l.ori   r8,r6,0
  l.jal   uart_put_word
   l.ori  r6,r7,0
  l.ori   r6,r8,0
  l.movhi r3,hi(txt_verifying)
  l.jal   uart_print_str
   l.ori  r3,r3,lo(txt_verifying)
1:
  # Show progress on UART
  l.andi  r8,r6,0x3fff
  l.sfeqi r8,0
  l.bnf   1f
   l.nop
  l.jal   uart_put_word
   l.nop
  l.jal   uart_print_str
   l.ori  r3,r20,0
1:
  # Check if we've finished writing
  l.sfgeu r6,r21
  l.bnf   read_test
   l.addi r6,r6,4

  l.movhi r3,hi(txt_done)
  l.jal   uart_print_str
   l.ori  r3,r3,lo(txt_done)
done:
  l.j     done
   l.nop
