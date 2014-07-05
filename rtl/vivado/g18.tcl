write_cfgmem -force -format mcs -interface bpix16 -size 64 \
  -loadbit "up 0 mexiko.bit" -loaddata "up 0x1000000 mexiko.swapped" \
  -file mexiko.mcs
