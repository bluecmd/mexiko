
FLASH_BACKEND = bpi.o
BOOTROM_DEPS = loader.o uart.o $(FLASH_BACKEND)

CC = or1k-linux-gnu-gcc
LD = or1k-linux-gnu-ld
OBJCOPY = or1k-linux-gnu-objcopy
STAMP = $(shell date +'%Y-%m-%d %H:%M')

all: bootrom.v sim.elf

clean:
	rm -f *.o *.elf bootrom.v bin2vlogarray

%.o: %.S bootrom_config.h
	$(CC) -c $< -o $@ -DTIMESTAMP="\"$(STAMP)\""

bootrom.elf: $(BOOTROM_DEPS)
	$(LD) -T bootrom.ld $^ -o $@

sim.elf: simboot.o $(BOOTROM_DEPS)
	$(LD) -T simboot.ld $^ -o $@

bootrom.bin: bootrom.elf
	$(OBJCOPY) -O binary $< $@

bin2vlogarray: bin2vlogarray.c
	gcc -o $@ $<

bootrom.v: bootrom.bin bin2vlogarray
	./bin2vlogarray < bootrom.bin | tail -n+65 > $@
