
VERILATOR_FLAGS = -Wno-fatal -Wno-combdly
VERILATOR_INCLUDE = \
	-I${PWD}/include \
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

DEPS = bench/testbench.sv bench/testbench.cpp include/wb_intercon.v \
			 bootrom/bootrom.v

.PHONY: obj_dir/Vtestbench

all: obj_dir/Vtestbench

include/wb_intercon.v: include/wb_intercon.conf
	../orpsoc-cores/cores/wb_intercon/sw/wb_intercon_gen $< $@

bootrom/bootrom.v: bootrom/*.S
	make -C bootrom bootrom.v

obj_dir/Vtestbench: $(DEPS)
	 verilator $(VERILATOR_FLAGS) -cc bench/testbench.sv --top-module testbench \
		 --exe bench/testbench.cpp $(VERILATOR_INCLUDE) 
	 make -C obj_dir -f Vtestbench.mk Vtestbench CXXFLAGS=$(CXXFLAGS)

sim: obj_dir/Vtestbench
	obj_dir/Vtestbench

clean:
	rm -rf obj_dir/


