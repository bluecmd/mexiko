open_hw
connect_hw_server -host localhost -port 60001 -url localhost:3121
open_hw_target [get_hw_targets */xilinx_tcf/Xilinx/*]

set device [lindex [get_hw_devices] 0]

current_hw_device $device
refresh_hw_device -update_hw_probes false $device

create_hw_cfgmem -hw_device $device -mem_dev  [lindex [get_cfgmem_parts {mt28gu512aax1e-bpi-x16}] 0]

set_property PROGRAM.ADDRESS_RANGE  {use_file} [ get_property PROGRAM.HW_CFGMEM $device]
set_property PROGRAM.FILE_1 {mexiko.mcs} [ get_property PROGRAM.HW_CFGMEM $device]
set_property PROGRAM.UNUSED_PIN_TERMINATION {pull-none} [ get_property PROGRAM.HW_CFGMEM $device]
set_property PROGRAM.BPI_RS_PINS {none} [ get_property PROGRAM.HW_CFGMEM $device]
set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM $device]
set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM $device]
set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM $device]
set_property PROGRAM.VERIFY  0 [ get_property PROGRAM.HW_CFGMEM $device]

create_hw_bitstream -hw_device $device [get_property PROGRAM.HW_CFGMEM_BITFILE $device]
program_hw_devices $device
program_hw_cfgmem -hw_cfgmem [get_property PROGRAM.HW_CFGMEM $device]

set_property PROGRAM.FILE {mexiko.bit} $device
program_hw_devices $device
