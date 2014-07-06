CC=or1k-elf-gcc
OBJCOPY=or1k-elf-objcopy
LDLAGS=mexiko.S
CFLAGS=-DTIMESTAMP="\"$(shell date +'%Y-%m-%d %H:%M')\""

all: diag.bsw simple.bsw

clean:
	rm -f diag.bsw diag.elf simple.elf simple.bsw

diag.elf: main.c test.c memory.c mexiko.S mexiko.h diag.h
	$(CC) $^ -o $@ $(CFLAGS)

simple.elf: simple.c mexiko.S
	$(CC) $^ -o $@ $(CFLAGS)

diag.bsw: diag.elf
	../utils/elf2binsizeword $< > $@

simple.bsw: simple.elf
	../utils/elf2binsizeword $< > $@
