BOOTROM_DEPS = loader.o uart.o
MEM_STRESS_DEPS = mem_stress.o uart.o
STAMP = $(shell date +'%Y-%m-%d %H:%M')

CC = or1k-elf-gcc
LD = or1k-elf-ld
OBJCOPY = or1k-elf-objcopy

all: bootrom.v bootrom.bin sim.elf sim_mem_stress.elf mem_stress.v \
	mem_stress.bin

clean:
	rm -f *.o *.elf *.v *.bin

%.o: %.S bootrom_config.h
	$(CC) -c $< -o $@ -DTIMESTAMP="\"$(STAMP)\""

bootrom.elf: $(BOOTROM_DEPS)
	$(LD) -T bootrom.ld $^ -o $@

sim.elf: simboot.o $(BOOTROM_DEPS)
	$(LD) -T simboot.ld $^ -o $@

mem_stress.elf: $(MEM_STRESS_DEPS)
	$(LD) -T bootrom.ld $^ -o $@

sim_mem_stress.elf: simboot.o $(MEM_STRESS_DEPS)
	$(LD) -T simboot.ld $^ -o $@

bootrom.bin: bootrom.elf
	$(OBJCOPY) -O binary $< $@

bootrom.v: bootrom.elf
	../utils/elf2vlogarray $< > $@

mem_stress.bin: mem_stress.elf
	$(OBJCOPY) -O binary $< $@

mem_stress.v: mem_stress.elf
	../utils/elf2vlogarray $< > $@
