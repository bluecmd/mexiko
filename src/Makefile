
bpi.memh: diag/diag.bsw
	# TODO(bluecmd): This is supposed to be u-boot instead
	utils/bin2memh diag/diag.bsw > bpi.memh
	# Place diag image at 0x1f00000
	echo "@7c0000" >> bpi.memh
	utils/bin2memh diag/diag.bsw >> bpi.memh

