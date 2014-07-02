
VERILATOR_FLAGS = -Wno-fatal -Wno-combdly
VERILATOR_INCLUDE = \
	-I${PWD}/.. \
	-I${PWD}/../mor1kx/rtl/verilog \
	-I${PWD}/../orpsoc-cores/cores/elf-loader \
	-I${PWD}/../orpsoc-cores/cores/verilog_utils \
	-I${PWD}/../orpsoc-cores/cores/wb_intercon \
	-I${PWD}/../utils \
	-I${PWD}/bench \
	-I${PWD}/bootrom \
	-I/home/bluecmd/.cache/fusesoc/adv_debug_sys/rtl/verilog \
	-I/home/bluecmd/.cache/fusesoc/jtag_tap/rtl/verilog \
	-I/home/bluecmd/.cache/fusesoc/uart16550/rtl/verilog \
	-I/home/bluecmd/.cache/fusesoc/verilog-arbiter/src/

.PHONY: obj_dir/Vtestbench

obj_dir/Vtestbench: bench/testbench.sv bench/testbench.cpp
	 verilator $(VERILATOR_FLAGS) -cc bench/testbench.sv --top-module testbench \
		 --exe bench/testbench.cpp $(VERILATOR_INCLUDE) 
	 make -C obj_dir -f Vtestbench.mk Vtestbench CXXFLAGS=$(CXXFLAGS)

sim: obj_dir/Vtestbench
	obj_dir/Vtestbench

clean:
	rm -rf obj_dir/


