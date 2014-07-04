open_hw
connect_hw_server -host localhost -port 60001 -url localhost:3121
open_hw_target [get_hw_targets */xilinx_tcf/Xilinx/*]
create_hw_cfgmem -hw_device [lindex [get_hw_devices] 0] -mem_dev  [lindex [get_cfgmem_parts {mt28gu01gaax1e-bpi-x16}] 0]
set_property PROGRAM.FILE {mexiko.bit} [lindex [get_hw_devices] 0]
program_hw_devices [lindex [get_hw_devices] 0]
