
.PHONY: diag/diag.bsw

all: mexiko.memh mexiko.bin

clean:
	rm -f mexiko.memh mexiko.bin
	rm -f diag/diag.bsw

diag/diag.bsw:
	make -C diag diag.bsw

mexiko.memh: diag/diag.bsw
	# TODO(bluecmd): This is supposed to be u-boot instead
	#utils/bin2memh diag/diag.bsw > $@
	echo "@800000" >> $@
	utils/bin2memh diag/diag.bsw >> $@

mexiko.bin: diag/diag.bsw
	dd if=/dev/zero bs=64k count=256 of=$@
	cat diag/diag.bsw >> $@
