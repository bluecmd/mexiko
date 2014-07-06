BOOTROM_DEPS = loader.o uart.o
STAMP = $(shell date +'%Y-%m-%d %H:%M')

CC = or1k-elf-gcc
LD = or1k-elf-ld
OBJCOPY = or1k-elf-objcopy

all: bootrom.v bootrom.bin sim.elf

clean:
	rm -f *.o *.elf bootrom.v bootrom.bin

%.o: %.S bootrom_config.h
	$(CC) -c $< -o $@ -DTIMESTAMP="\"$(STAMP)\""

bootrom.elf: $(BOOTROM_DEPS)
	$(LD) -T bootrom.ld $^ -o $@

sim.elf: simboot.o $(BOOTROM_DEPS)
	$(LD) -T simboot.ld $^ -o $@

bootrom.bin: bootrom.elf
	$(OBJCOPY) -O binary $< $@

bootrom.v: bootrom.elf
	../utils/elf2vlogarray $< > $@
