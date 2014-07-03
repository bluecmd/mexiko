CC=or1k-elf-gcc
OBJCOPY=or1k-elf-objcopy
LDLAGS=mexiko.S
CFLAGS=-DTIMESTAMP="\"$(shell date +'%Y-%m-%d %H:%M')\""

all: diag.binsize

clean:
	rm -f diag.bin diag.binsize diag.elf bin2binsizeword

diag.elf: main.c test.c memory.c mexiko.S mexiko.h diag.h
	$(CC) $^ -o $@ $(CFLAGS)

diag.bin: diag.elf
	$(OBJCOPY) -O binary $< $@

diag.binsize: diag.bin bin2binsizeword
	./bin2binsizeword diag.bin $@

bin2binsizeword: ../utils/bin2binsizeword.c
	gcc -o $@ $<
