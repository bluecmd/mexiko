#include <stdio.h>
#include <stdlib.h>

#include <or1k-support.h>
#include <spr-defs.h>

#include "diag.h"

extern int _board_mem_size;

static volatile uint8_t *uart_lsr;

static uint32_t timer_period;

extern void memory_test(void);
extern void mgmteth_test(void);
static void diag_summary(void);
static void diag_start(void);

typedef void (*diag_function)(void);
static int diag_function_idx = 0;

static diag_function diag_functions[] = {
  diag_start,
  mgmteth_test,
  memory_test,
  diag_summary
};

static void handle_bus_error(void);
static void handle_tick(void);

int main(void) {
  int i;
  char selection = 0;
  test_section("Board diagnostic program for Mexiko");

  or1k_exception_handler_add(0x2, handle_bus_error);

  test_newline();
  test_info("Press 'c' to enter console or any other key for diagnostics.");

  uart_lsr = (volatile uint8_t*)(_board_uart_base + UART_LSR);
  for(i = 0; i < SYS_CLK/8; i++) {
    if ((*uart_lsr & UART_LSR_DR) == UART_LSR_DR) {
      selection = __uart_getc();
      /* ignore 'd' to make it easier to enter console */
      if (selection == 'd') {
        selection = 0;
        continue;
      }
      break;
    }
  }

  switch (selection) {
    case 'c':
      console();
      break;
    case 0:
      test_info("Timed out waiting for key, defaulting to diagnostics.");
    default:
      diag_next();
      break;
  }

  return 0;
}

void diag_start(void) {
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
  test_newline();
  test_info("Diagnostics completed");
  exit(0);
}

static void handle_bus_error(void) {
  test_failure = FAILURE_BUS_ERROR;
  test_failure_func(FAILURE_BUS_ERROR);
}
