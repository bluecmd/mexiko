#include "bootrom_config.h"

.global flash_init
.global flash_read_byte
.global flash_deinit

flash_init:
  l.nop /* TODO(bluecmd): */
  l.ori   r25,r0,0
  l.jr    r9
   l.nop

flash_read_byte:
  l.sfeqi r25,2
  l.bnf   1f
   l.ori   r3,r0,0x00
  l.ori   r3,r0,0x40
1:
  l.addi  r25,r25,1
  l.jr    r9
   l.nop

flash_deinit:
  /* TODO(bluecmd): Clear chip select? */
  l.jr  r9
   l.nop
