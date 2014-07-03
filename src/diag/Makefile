CC=or1k-elf-gcc
LDLAGS=mexiko.S
CFLAGS=-DTIMESTAMP="\"$(shell date +'%Y-%m-%d %H:%M')\""

diag: main.c test.c memory.c mexiko.S mexiko.h diag.h
	$(CC) $^ -o $@ $(CFLAGS)

