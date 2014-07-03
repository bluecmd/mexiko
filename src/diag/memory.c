#include <stdint.h>
#include <stdlib.h>

#include "diag.h"

static void memory_failure(int reason);

static size_t ptr;
static int stage = 0;
static int error = 0;

void memory_test(void) {
  int data = 0;

  test_failure_func = memory_failure;

  STAGE(0) {
    test_section("Memory");
  } END_STAGE

  STAGE(1) {
    test_start("Full read");
    for(ptr = 0; ptr < RAM_SIZE; ptr+=4) {
      data = *((uint32_t*)(ptr + RAM_BASE));
      if ((ptr & 0xffff) == 0) {
        test_progress("%d KiB", ptr / 1024);
      }
    }
    test_finish(OK, "%d KiB / %d KiB", ptr / 1024, RAM_SIZE / 1024);
  } ON_ERROR {
    test_finish(ERROR, "%d KiB / %d KiB", ptr / 1024, RAM_SIZE / 1024);
  } END_STAGE

  STAGE(2) {
    test_start("Non-reserved write");
    for(ptr = RESERVED_RAM; ptr < RAM_SIZE; ptr+=4) {
      *((uint32_t*)(ptr + RAM_BASE)) = 0xaa55aa55;
      if ((ptr & 0xffff) == 0) {
        test_progress("%d KiB", ptr / 1024);
      }
    }
    test_finish(OK, "%d KiB / %d KiB", ptr / 1024, RAM_SIZE / 1024);
  } ON_ERROR {
    test_finish(ERROR, "%d KiB / %d KiB", ptr / 1024, RAM_SIZE / 1024);
  } END_STAGE

  STAGE(3) {
    int fail = 0;
    test_start("Non-reserved read-back");
    for(ptr = RESERVED_RAM; ptr < RAM_SIZE; ptr+=4) {
      if (*((uint32_t*)(ptr + RAM_BASE)) != 0xaa55aa55) {
        fail = 1;
        break;
      }
      if ((ptr & 0xffff) == 0) {
        test_progress("%d KiB", ptr / 1024);
      }
    }
    test_finish(fail ? ERROR : OK,
        "%d KiB / %d KiB", ptr / 1024, RAM_SIZE / 1024);
  } ON_ERROR {
    test_finish(ERROR, "%d KiB / %d KiB", ptr / 1024, RAM_SIZE / 1024);
  } END_STAGE



  stage = 0;
  diag_next();
}

static void memory_failure(int reason) {
  error = 1;
  memory_test();
}
