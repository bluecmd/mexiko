.PHONY: program

mexiko.bit: mexiko.tcl
	rm -rf .project
	vivado -mode batch -nojournal -nolog -source $<

program: mexiko.bit program.tcl
	sudo $(shell which vivado) -mode batch -nojournal -nolog -source program.tcl
