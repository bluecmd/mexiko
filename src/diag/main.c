#include <stdio.h>
#include <stdlib.h>

#include <or1k-support.h>

#include "diag.h"

extern int _board_mem_size;

extern void memory_test(void);
static void diag_summary(void);

typedef void (*diag_function)(void);
static int diag_function_idx = 0;

static diag_function diag_functions[] = {
  memory_test,
  memory_test,
  memory_test,
  diag_summary
};

static void handle_bus_error(void);

int main(void) {
  putchar('\n');
  puts("Board diagnostic program for Mexiko");

  or1k_exception_handler_add(0x2, handle_bus_error);

  test_section("Compile time options");
  test_start("Built");
  test_finish(INFO, TIMESTAMP);
  test_start("Clock frequency");
  test_finish(INFO, "%d.%03d MHz", _board_clk_freq / (1000*1000),
      (_board_clk_freq / 1000) % 1000);

  test_start("UART baud rate");
  test_finish(INFO, "%d Bd", _board_uart_baud);
  test_start("Diagnostic memory size");
  test_finish(INFO, "%d KiB", _board_mem_size / 1024);
  test_start("System memory size");
  test_finish(INFO, "%d MiB", RAM_SIZE / 1024 / 1024);

  diag_next();

  return 0;
}

void diag_next(void) {
  diag_functions[diag_function_idx++]();
}

static void diag_summary(void) {
  test_section("Diagnostics Summary");
  test_start("Tests run");
  test_finish(INFO, "%d", test_all_tests);
  test_start("Failures");
  test_finish(test_failures > 0 ? ERROR : OK, "%d", test_failures);
  printf("\nDiagnostics completed\n");
  exit(0);
}

static void handle_bus_error(void) {
  test_failure = FAILURE_BUS_ERROR;
  test_failure_func(FAILURE_BUS_ERROR);
}
