
VERILATOR_FLAGS = -Wno-fatal -Wno-combdly
VERILATOR_INCLUDE = \
	-I${CURDIR}/include \
	-I${CURDIR}/.. \
	-I${CURDIR}/../gic \
	-I${CURDIR}/../kuba \
	-I${CURDIR}/../kuba/include \
	-I${CURDIR}/../mor1kx/rtl/verilog \
	-I${CURDIR}/../orpsoc-cores/cores/elf-loader \
	-I${CURDIR}/../orpsoc-cores/cores/verilog_utils \
	-I${CURDIR}/../orpsoc-cores/cores/wb_intercon \
	-I${CURDIR}/../orpsoc-cores/cores/wb_ram/rtl/verilog \
	-I${CURDIR}/../orpsoc-cores/cores/wb_bfm \
	-I${CURDIR}/../utils \
	-I${CURDIR}/bench \
	-I/home/bluecmd/work/vpi-uart \
	/home/bluecmd/work/vpi-uart/dpi_uart.cpp \
	-I/home/bluecmd/.cache/fusesoc/adv_debug_sys/rtl/verilog \
	-I/home/bluecmd/.cache/fusesoc/jtag_tap/rtl/verilog \
	-I/home/bluecmd/.cache/fusesoc/uart16550/rtl/verilog \
	-I/home/bluecmd/.cache/fusesoc/verilog-arbiter/src \
	-I/home/bluecmd/.cache/fusesoc/i2c \
	-I/home/bluecmd/.cache/fusesoc/ethmac/rtl/verilog \
	${CURDIR}/../orpsoc-cores/cores/wb_ram/rtl/verilog/wb_funcs.v

DEPS = bench/testbench.sv bench/testbench.cpp include/wb_intercon.v \
			 bootrom mexiko.memh

.PHONY: obj_dir/Vtestbench bootrom mexiko.memh

all: obj_dir/Vtestbench

include/wb_intercon.v: include/wb_intercon.conf
	../orpsoc-cores/cores/wb_intercon/sw/wb_intercon_gen $< $@

mexiko.memh:
	make -C ../../src mexiko.memh

bootrom:
	make -C ../../src/bootrom bootrom.v

obj_dir/Vtestbench: $(DEPS)
	 verilator $(VERILATOR_FLAGS) -cc bench/testbench.sv --top-module testbench \
		 --exe bench/testbench.cpp $(VERILATOR_INCLUDE)
	 make -C obj_dir -f Vtestbench.mk Vtestbench CXXFLAGS=$(CXXFLAGS)

sim: obj_dir/Vtestbench
	obj_dir/Vtestbench --diag

clean:
	rm -rf obj_dir/
	rm -f include/wb_intercon.v
	rm -f include/wb_intercon.vh


