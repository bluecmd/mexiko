
all: g18.memh

clean:
	rm -f bpi.memh
	rm -f diag/diag.bsw

diag/diag.bsw:
	make -C diag diag.bsw

g18.memh: diag/diag.bsw
	# TODO(bluecmd): This is supposed to be u-boot instead
	utils/bin2memh diag/diag.bsw > $@
	# Place diag image at 0x1f00000 (/2 = 0xf80000)
	echo "@f80000" >> $@
	utils/bin2memh diag/diag.bsw >> $@

