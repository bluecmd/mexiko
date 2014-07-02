
FLASH_BACKEND = bpi.o
BOOTROM_DEPS = loader.o uart.o $(FLASH_BACKEND)

CC = or1k-linux-gnu-gcc
LD = or1k-linux-gnu-ld
OBJCOPY = or1k-linux-gnu-objcopy

.o: %.S
	$(CC) -c $< -o $@

bootrom.elf: $(BOOTROM_DEPS)
	$(LD) -T bootrom.ld $^ -o $@

sim.elf: simboot.o $(BOOTROM_DEPS)
	$(LD) -T simboot.ld $^ -o $@

bootrom.bin: bootrom.elf
	$(OBJCOPY) -O binary $< $@

