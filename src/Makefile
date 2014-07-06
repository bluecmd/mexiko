DEFAULT_BAREBOX_PASSWD=hunter2

.PHONY: diag/diag.bsw barebox/barebox

all: mexiko.memh mexiko.bin

clean:
	rm -f mexiko.memh mexiko.bin
	rm -f diag/diag.bsw

diag/diag.bsw:
	make -C diag diag.bsw simple.bsw

barebox/.config:
	cp barebox-config barebox/.config

barebox/barebox: barebox/.config
	echo -n $(DEFAULT_BAREBOX_PASSWD) | sha256sum > barebox/mexiko.passwd
	make -C barebox/ ARCH=openrisc CROSS_COMPILE=or1k-elf-
	cp barebox/.config barebox-config

barebox/barebox.bsw: barebox/barebox
	utils/elf2binsizeword $< BARE > $@

mexiko.memh: diag/diag.bsw barebox/barebox.bsw
	utils/bin2memh barebox/barebox.bsw > $@
	echo "@400000" >> $@
	utils/bin2memh diag/diag.bsw >> $@

mexiko.bin: diag/diag.bsw barebox/barebox.bsw
	dd if=/dev/zero bs=32k count=256 of=$@
	dd if=barebox/barebox.bsw of=$@ conv=notrunc
	cat diag/diag.bsw >> $@
