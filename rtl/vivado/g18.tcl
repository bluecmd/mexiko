write_cfgmem -force -format mcs -interface bpix16 -size 128 \
  -loadbit "up 0 mexiko.bit" -loaddata "up 0x3000000 ../../src/mexiko.bin" \
  -file mexiko.mcs
