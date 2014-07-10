#include <stdint.h>
#include <stdio.h>

#include "diag.h"

static int readline(char *ptr, int max) {
  int count;
  for (count = 0; max > 1; max--, ptr++, count++) {
    *ptr = __uart_getc();
    __uart_putc(*ptr);
    if (*ptr == '\n' || *ptr == '\r') {
      *ptr = 0;
      return count;
    }
  }
  /* overrun, read until newline but throw it away */
  *ptr = 0;
  {
    char c;
    do {
      c = __uart_getc();
      __uart_putc(c);
    } while (c != '\n' && c != '\r');
  }
  return count;
}

static void split(char *buffer, char **part) {
  char *args;
  for (args = buffer; *args != 0 && *args != ' '; args++);
  if (*args == ' ') {
    *args = 0;
    args++;
  }
  *part = args;
}

static void console_failure(int reason) {
  printf("CPU failure: %s", test_failure_str(reason));
  test_newline();
  console();
}

void console(void) {
  char buffer[80];
  char *args;

  test_failure_func = console_failure;

  test_section("Mexiko diagnostics console");
  test_section("Commands:");
  test_info(" md <addr> <size>  - dump memory to terminal");
  test_info(" diag              - start the diagnostics suite");
  test_newline();

  while (1) {
    __uart_putc('>');
    __uart_putc(' ');
    if (readline(buffer, sizeof(buffer)) == 0)
      continue;

    test_newline();

    split(buffer, &args);

    /* memory dump */
    if (!strcmp(buffer, "md")) {
      char *addr = args;
      char *size;

      split(addr, &size);
      memory_dump((uint8_t *)strtoul(addr, NULL, 0), strtoul(size, NULL, 0));
    } else if (!strcmp(buffer, "diag")) {
      diag_next();
    }
  }
}

void memory_dump(uint8_t addr[], uint32_t size) {
  size_t i;
  if (size & 3) {
    size = (size & ~3) + 4;
  }
  addr = (uint8_t*)((uint32_t)addr & ~3);
  printf("%08p-%08p", addr, addr + size);
  for (i = 0; size > 0; size-=4, addr+=4, i++) {
    if (i == 0) {
      test_newline();
      printf("%08p ", addr);
    } else if (i == 2) {
      printf(" ");
    } else if (i == 3) {
      i = -1;
    }
    printf("%02x %02x %02x %02x ", addr[0], addr[1], addr[2], addr[3]);
  }
  test_newline();
}
