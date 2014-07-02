#include "bootrom_config.h"

.global flash_init
.global flash_read_byte
.global flash_deinit

flash_init:
  l.nop /* TODO(bluecmd): */
  l.jr    r9
   l.nop

flash_read_byte:
  l.ori   r3,r0,0x01
  l.jr    r9
   l.nop

flash_deinit:
  /* TODO(bluecmd): Clear chip select? */
  l.jr  r9
   l.nop
