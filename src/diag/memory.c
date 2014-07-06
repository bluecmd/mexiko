#include <stdint.h>
#include <stdlib.h>

#include "diag.h"

#define LOOP_MAGIC            (uint32_t)(0xdeadbeef)
#define LOOP_VALIDATE_MAGIC   (uint32_t)(0xbaadc0de)
#define WRITE_MAGIC0(x)       (uint32_t)(0xffffffff)
#define WRITE_MAGIC1(x)       (uint32_t)(x)
#define WRITE_MAGIC2(x)       (uint32_t)(0xaa55aa55 ^ (x))

#define VPTR(x)               ((volatile uint32_t*)(x))
#define MB                    asm volatile ("" : : : "memory")

#define MEMORY_LOOP_TEST_BEGIN(name, start, incr) \
    int fail = 0; \
    test_start(name); \
    for(ptr = start; ptr < real_ram_size; ptr+=incr) {

#define MEMORY_LOOP_TEST_END(start) \
      if ((ptr & 0x3fffff) == 0) { \
        test_progress("%d MiB", ptr / (1024 * 1024)); \
      } \
    } \
    test_finish(fail ? ERROR : OK, "%d KiB / %d KiB", \
        (ptr - start) / 1024, (real_ram_size - start) / 1024); \
  } ON_ERROR { \
    test_finish(ERROR, "%d KiB / %d KiB", \
        (ptr - start) / 1024, (real_ram_size - start) / 1024);

#define PATTERN_TEST(stage, name, pattern) \
  STAGE(stage) { \
    MEMORY_LOOP_TEST_BEGIN("Free write     (" name ")", RESERVED_RAM, 4) \
      *VPTR(ptr) = pattern(ptr); \
    MEMORY_LOOP_TEST_END(RESERVED_RAM) \
  } END_STAGE \
  STAGE(stage+1) { \
    MEMORY_LOOP_TEST_BEGIN("Free read-back (" name ")", RESERVED_RAM, 4) \
      if (*VPTR(ptr) != pattern(ptr)) { \
        fail = 1; \
        break; \
      } \
    MEMORY_LOOP_TEST_END(RESERVED_RAM) \
  } END_STAGE

static void memory_failure(int reason);

static uint32_t real_ram_size;
static size_t ptr;
static int stage = 0;
static int error = 0;

void memory_test(void) {
  uint32_t data = 0;

  test_failure_func = memory_failure;

  STAGE(0) {
    /* with the dcache we would have trouble validating memory loops. */
    or1k_dcache_disable();
    test_section("Memory");
  } END_STAGE

  STAGE(1) {
    volatile uint32_t *magic = VPTR(0x0);
    test_start("Detecting memory size");
    *magic = LOOP_MAGIC;
    /* Do quick sanity check */
    MB;
    data = *magic;
    if (data != LOOP_MAGIC) {
      test_finish(ERROR, "Magic failed: %08x != %08x", LOOP_MAGIC, data);
    } else {
      /* loop over in RESERVED increments until we find the magic. */
      for(ptr = RESERVED_RAM; ptr < RAM_SIZE; ptr <<=1) {
        data = *VPTR(ptr);
        if (data == LOOP_MAGIC) {
          /* validate that this isn't a fluke */
          *magic = LOOP_VALIDATE_MAGIC;
          MB;
          data = *VPTR(ptr);
          if (data == LOOP_VALIDATE_MAGIC) {
            real_ram_size = ptr;
            break;
          }
          /* just a fluke, continue */
          *magic = LOOP_MAGIC;
        }
        if ((ptr & 0x3fffff) == 0) {
          test_progress("%d MiB", ptr / (1024 * 1024));
        }
      }
      if (real_ram_size != RAM_SIZE) {
        test_finish(ERROR, "Loop @ %d KiB / %d KiB",
            ptr / 1024, RAM_SIZE / 1024);
        test_warning("Memory size detected is smaller than it should be.");
        test_info("Tests will continue using the detected memory size.");
      } else {
        test_finish(OK, "%d KiB", real_ram_size / 1024, RAM_SIZE / 1024);
      }
    }
  } ON_ERROR {
    real_ram_size = ptr;
    test_finish(ERROR, "Fault @ %d KiB / %d KiB", ptr / 1024, RAM_SIZE / 1024);
    test_warning("Memory size detected is smaller than it should be.");
    test_info("Tests will continue using the detected memory size.");
  } END_STAGE

  STAGE(2) {
    MEMORY_LOOP_TEST_BEGIN("Full read", 0, 64*1024)
      size_t i;
      for(i = 0; i < 64*1024; i+=4) {
        *VPTR(ptr+i);
      }
    MEMORY_LOOP_TEST_END(0)
  } END_STAGE

  PATTERN_TEST(3, "const", WRITE_MAGIC0)
  PATTERN_TEST(5, "address", WRITE_MAGIC1)
  PATTERN_TEST(7, "xor ^ addr", WRITE_MAGIC2)

  stage = 0;
  or1k_dcache_enable();
  diag_next();
}

static void memory_failure(int reason) {
  error = 1;
  memory_test();
}
