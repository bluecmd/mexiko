
FLASH_BACKEND = rom.o
BOOTROM_DEPS = loader.o uart.o $(FLASH_BACKEND)
STAMP = $(shell date +'%Y-%m-%d %H:%M')

CC = or1k-elf-gcc
LD = or1k-elf-ld

all: bootrom.v sim.elf

clean:
	rm -f *.o *.elf bootrom.v

%.o: %.S bootrom_config.h
	$(CC) -c $< -o $@ -DTIMESTAMP="\"$(STAMP)\""

bootrom.elf: $(BOOTROM_DEPS)
	$(LD) -T bootrom.ld $^ -o $@

sim.elf: simboot.o $(BOOTROM_DEPS)
	$(LD) -T simboot.ld $^ -o $@

bootrom.v: bootrom.elf
	../utils/elf2vlogarray $< > $@
