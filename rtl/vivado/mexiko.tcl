# Set the reference directory for source file relative paths (by default the value is script directory path)
set rtl_dir ".."
set fusesoc_cache "/home/bluecmd/.cache/fusesoc"
set mor1kx  "$rtl_dir/mor1kx/rtl/verilog"

# Create project
create_project mexiko ./.project

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [get_projects mexiko]
set_property "default_lib" "xil_defaultlib" $obj
set_property "part" "xc7k325tffg900-2" $obj
set_property "simulator_language" "Mixed" $obj

set_param general.maxThreads 4

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 "[file normalize "$rtl_dir/mexiko-defs.vh"]"\
 "[file normalize "$rtl_dir/mexiko.sv"]"\
 "[file normalize "$rtl_dir/network.sv"]"\
 "[file normalize "$rtl_dir/orpsoc-cores/cores/wb_ram/rtl/verilog/wb_ram.v"]"\
 "[file normalize "$rtl_dir/orpsoc-cores/cores/wb_ram/rtl/verilog/wb_ram_generic.v"]"\
 "[file normalize "$rtl_dir/orpsoc-cores/cores/verilog_utils/verilog_utils.vh"]"\
 "[file normalize "$rtl_dir/orpsoc-cores/cores/wb_intercon/wb_arbiter.v"]"\
 "[file normalize "$rtl_dir/orpsoc-cores/cores/wb_intercon/wb_data_resize.v"]"\
 "[file normalize "$rtl_dir/orpsoc-cores/cores/wb_intercon/wb_mux.v"]"\
 "[file normalize "$rtl_dir/orpsoc/clkgen.sv"]"\
 "[file normalize "$rtl_dir/orpsoc/include/uart_defines.v"]"\
 "[file normalize "$rtl_dir/orpsoc/include/wb_intercon.v"]"\
 "[file normalize "$rtl_dir/orpsoc/include/wb_intercon.vh"]"\
 "[file normalize "$rtl_dir/orpsoc/orpsoc.sv"]"\
 "[file normalize "$rtl_dir/orpsoc/rom.sv"]"\
 "[file normalize "$rtl_dir/orpsoc/wb_g18.v"]"\
 "[file normalize "$rtl_dir/utils/ff_syncer.sv"]"\
 "[file normalize "$rtl_dir/xilinx/xilinx_lane.sv"]"\
 "[file normalize "$rtl_dir/xilinx/xilinx_octa10g.sv"]"\
 "[file normalize "$rtl_dir/xilinx/xilinx_phy10g_quad_logic.sv"]"\
 "[file normalize "$rtl_dir/xilinx/xilinx_phy10g_shared_logic.sv"]"\
 "[file normalize "$mor1kx/mor1kx_wb_mux_espresso.v"]"\
 "[file normalize "$mor1kx/mor1kx_wb_mux_cappuccino.v"]"\
 "[file normalize "$mor1kx/mor1kx.v"]"\
 "[file normalize "$mor1kx/mor1kx_true_dpram_sclk.v"]"\
 "[file normalize "$mor1kx/mor1kx_ticktimer.v"]"\
 "[file normalize "$mor1kx/mor1kx_store_buffer.v"]"\
 "[file normalize "$mor1kx/mor1kx-sprs.v"]"\
 "[file normalize "$mor1kx/mor1kx_simple_dpram_sclk.v"]"\
 "[file normalize "$mor1kx/mor1kx_rf_espresso.v"]"\
 "[file normalize "$mor1kx/mor1kx_rf_cappuccino.v"]"\
 "[file normalize "$mor1kx/mor1kx_pic.v"]"\
 "[file normalize "$mor1kx/mor1kx_lsu_espresso.v"]"\
 "[file normalize "$mor1kx/mor1kx_lsu_cappuccino.v"]"\
 "[file normalize "$mor1kx/mor1kx_immu.v"]"\
 "[file normalize "$mor1kx/mor1kx_icache.v"]"\
 "[file normalize "$mor1kx/mor1kx_fetch_tcm_prontoespresso.v"]"\
 "[file normalize "$mor1kx/mor1kx_fetch_prontoespresso.v"]"\
 "[file normalize "$mor1kx/mor1kx_fetch_espresso.v"]"\
 "[file normalize "$mor1kx/mor1kx_fetch_cappuccino.v"]"\
 "[file normalize "$mor1kx/mor1kx_execute_ctrl_cappuccino.v"]"\
 "[file normalize "$mor1kx/mor1kx_execute_alu.v"]"\
 "[file normalize "$mor1kx/mor1kx_dmmu.v"]"\
 "[file normalize "$mor1kx/mor1kx-defines.v"]"\
 "[file normalize "$mor1kx/mor1kx_decode.v"]"\
 "[file normalize "$mor1kx/mor1kx_decode_execute_cappuccino.v"]"\
 "[file normalize "$mor1kx/mor1kx_dcache.v"]"\
 "[file normalize "$mor1kx/mor1kx_ctrl_prontoespresso.v"]"\
 "[file normalize "$mor1kx/mor1kx_ctrl_espresso.v"]"\
 "[file normalize "$mor1kx/mor1kx_ctrl_cappuccino.v"]"\
 "[file normalize "$mor1kx/mor1kx_cpu.v"]"\
 "[file normalize "$mor1kx/mor1kx_cpu_prontoespresso.v"]"\
 "[file normalize "$mor1kx/mor1kx_cpu_espresso.v"]"\
 "[file normalize "$mor1kx/mor1kx_cpu_cappuccino.v"]"\
 "[file normalize "$mor1kx/mor1kx_cfgrs.v"]"\
 "[file normalize "$mor1kx/mor1kx_cache_lru.v"]"\
 "[file normalize "$mor1kx/mor1kx_bus_if_wb32.v"]"\
 "[file normalize "$mor1kx/mor1kx_bus_if_avalon.v"]"\
 "[file normalize "$mor1kx/mor1kx_branch_prediction.v"]"\
 "[file normalize "$fusesoc_cache/verilog-arbiter/src/arbiter.v"]"\
 "[file normalize "$fusesoc_cache/uart16550/rtl/verilog/uart_wb.v"]"\
 "[file normalize "$fusesoc_cache/uart16550/rtl/verilog/uart_transmitter.v"]"\
 "[file normalize "$fusesoc_cache/uart16550/rtl/verilog/uart_top.v"]"\
 "[file normalize "$fusesoc_cache/uart16550/rtl/verilog/uart_tfifo.v"]"\
 "[file normalize "$fusesoc_cache/uart16550/rtl/verilog/uart_sync_flops.v"]"\
 "[file normalize "$fusesoc_cache/uart16550/rtl/verilog/uart_rfifo.v"]"\
 "[file normalize "$fusesoc_cache/uart16550/rtl/verilog/uart_regs.v"]"\
 "[file normalize "$fusesoc_cache/uart16550/rtl/verilog/uart_receiver.v"]"\
 "[file normalize "$fusesoc_cache/uart16550/rtl/verilog/uart_defines.v"]"\
 "[file normalize "$fusesoc_cache/uart16550/rtl/verilog/timescale.v"]"\
 "[file normalize "$fusesoc_cache/uart16550/rtl/verilog/raminfr.v"]"\
 "[file normalize "$fusesoc_cache/i2c/i2c_master_top.v"]"\
 "[file normalize "$fusesoc_cache/i2c/i2c_master_defines.v"]"\
 "[file normalize "$fusesoc_cache/i2c/i2c_master_byte_ctrl.v"]"\
 "[file normalize "$fusesoc_cache/i2c/i2c_master_bit_ctrl.v"]"\
 "[file normalize "$fusesoc_cache/adv_debug_sys/rtl/verilog/syncreg.v"]"\
 "[file normalize "$fusesoc_cache/adv_debug_sys/rtl/verilog/syncflop.v"]"\
 "[file normalize "$fusesoc_cache/adv_debug_sys/rtl/verilog/bytefifo.v"]"\
 "[file normalize "$fusesoc_cache/adv_debug_sys/rtl/verilog/adbg_wb_module.v"]"\
 "[file normalize "$fusesoc_cache/adv_debug_sys/rtl/verilog/adbg_wb_defines.v"]"\
 "[file normalize "$fusesoc_cache/adv_debug_sys/rtl/verilog/adbg_wb_biu.v"]"\
 "[file normalize "$fusesoc_cache/adv_debug_sys/rtl/verilog/adbg_top.v"]"\
 "[file normalize "$fusesoc_cache/adv_debug_sys/rtl/verilog/adbg_or1k_status_reg.v"]"\
 "[file normalize "$fusesoc_cache/adv_debug_sys/rtl/verilog/adbg_or1k_module.v"]"\
 "[file normalize "$fusesoc_cache/adv_debug_sys/rtl/verilog/adbg_or1k_defines.v"]"\
 "[file normalize "$fusesoc_cache/adv_debug_sys/rtl/verilog/adbg_or1k_biu.v"]"\
 "[file normalize "$fusesoc_cache/adv_debug_sys/rtl/verilog/adbg_jsp_module.v"]"\
 "[file normalize "$fusesoc_cache/adv_debug_sys/rtl/verilog/adbg_jsp_biu.v"]"\
 "[file normalize "$fusesoc_cache/adv_debug_sys/rtl/verilog/adbg_defines.v"]"\
 "[file normalize "$fusesoc_cache/adv_debug_sys/rtl/verilog/adbg_crc32.v"]"\
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property "top" "mexiko" $obj

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$rtl_dir/xdc/htgk700.xdc"]"
set file_added [add_files -norecurse -fileset $obj $file]
set file "$rtl_dir/xdc/htgk700.xdc"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property "file_type" "XDC" $file_obj

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$rtl_dir/xdc/xilinx_phy10g.xdc"]"
set file_added [add_files -norecurse -fileset $obj $file]
set file "$rtl_dir/xdc/xilinx_phy10g.xdc"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property "file_type" "XDC" $file_obj
set_property "processing_order" "EARLY" $file_obj

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$rtl_dir/xdc/orpsoc.xdc"]"
set file_added [add_files -norecurse -fileset $obj $file]
set file "$rtl_dir/xdc/orpsoc.xdc"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property "file_type" "XDC" $file_obj

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]
set_property "target_constrs_file" "[file normalize "$rtl_dir/xdc/htgk700.xdc"]" $obj

# Create 'synth_1' run (if not found)
set obj [get_runs synth_1]
set_property "part" "xc7k325tffg900-2" $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
set obj [get_runs impl_1]
set_property "part" "xc7k325tffg900-2" $obj

# set the current impl run
current_run -implementation [get_runs impl_1]

puts "INFO: Project created:mexiko"

launch_runs synth_1
wait_on_run synth_1

launch_runs impl_1
wait_on_run impl_1

open_impl_design [current_run]
check_timing
report_timing_summary -max_paths 5 -nworst 5 -file timing.report \
  -warn_on_violation

set_property BITSTREAM.CONFIG.BPI_SYNC_MODE Disable [current_design]
set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
write_bitstream -force mexiko.bit
