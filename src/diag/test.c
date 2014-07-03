#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "diag.h"

int test_all_tests = 0;
int test_failures = 0;
int test_failure = -1;

const char *current_test = NULL;

static const char * test_failure_str(int reason) {
  if (reason == FAILURE_UNKNOWN)
    return "Unknown";
  if (reason == FAILURE_BUS_ERROR)
    return "Bus Error";
  return "Internal Error";
}

void test_section(const char *section) {
  printf("\n" COLOR_WHITE "%s" COLOR_RESET "\n", section);
}

void test_start(const char *test) {
  printf(" %s:", test);
  printf("%*s", 30-strlen(test), "");
  fflush(stdout);
  current_test = test;
  test_failure = -1;
}

void test_progress(const char *fmt, ...) {
  va_list arg_list;
  va_start(arg_list, fmt);
  vprintf(fmt, arg_list);
  va_end(arg_list);
  printf("\r");
  fflush(stdout);
  test_start(current_test);
}

void test_finish(int level, const char *fmt, ...) {
  va_list arg_list;
  test_all_tests++;
  if (level == OK) {
    printf(COLOR_GREEN);
  } else if (level == ERROR) {
    printf(COLOR_RED);
    test_failures++;
  }

  va_start(arg_list, fmt);
  vprintf(fmt, arg_list);
  va_end(arg_list);

  if (level == OK) {
    puts(COLOR_RESET);
  } else if (level == ERROR) {
    if (test_failure != -1) {
      printf(COLOR_RESET " (%s)\n", test_failure_str(test_failure));
    } else {
      puts(COLOR_RESET);
    }
  } else {
    puts("");
  }
  fflush(stdout);
}

void test_unknown_failure(int reason) {
  printf("\nUnknown test failure (type: %s), cannot continue :(\n",
      test_failure_str(reason));
  exit(1);
}

void (*test_failure_func)(int) = test_unknown_failure;
