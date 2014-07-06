.PHONY: program ../../src/mexiko.bin

all: mexiko.mcs

clean:
	rm -f mexiko.bit mexiko.mcs mexiko.swapped

../../src/mexiko.bin:
	make -C ../../src/ mexiko.bin

mexiko.bit: mexiko.tcl
	rm -rf .project
	time vivado -mode batch -nojournal -nolog -source $<

mexiko.swapped: ../../src/mexiko.bin
	../../src/utils/byteswap $< > $@

mexiko.mcs: mexiko.bit mexiko.swapped
	vivado -mode batch -nojournal -nolog -source g18.tcl

program: mexiko.mcs mexiko.bit program.tcl
	sudo $(shell which vivado) -mode batch -nojournal -nolog -source program.tcl
