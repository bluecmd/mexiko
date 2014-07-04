CC=or1k-elf-gcc
OBJCOPY=or1k-elf-objcopy
LDLAGS=mexiko.S
CFLAGS=-DTIMESTAMP="\"$(shell date +'%Y-%m-%d %H:%M')\""

all: diag.bsw

clean:
	rm -f diag.bin diag.binsize diag.elf bin2binsizeword

diag.elf: main.c test.c memory.c mexiko.S mexiko.h diag.h
	$(CC) $^ -o $@ $(CFLAGS)

diag.bsw: diag.elf
	../utils/elf2binsizeword $< > $@
