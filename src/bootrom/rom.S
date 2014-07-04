#include "bootrom_config.h"

.global flash_init
.global flash_read_word
.global flash_deinit

flash_init:
  l.movhi r25,hi(ROM_BASE)
  l.ori   r25,r25,lo(ROM_BASE)
  l.jr    r9
   l.add  r25,r25,r27

flash_read_word:
  l.lwz   r3,0(r25)
  l.jr    r9
   l.addi r25,r25,4

flash_deinit:
  /* TODO(bluecmd): Clear chip select? */
  l.jr  r9
   l.nop
