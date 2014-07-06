#ifndef __HEADER_DIAG__
#define __HEADER_DIAG__

#include "mexiko.h"

#define COLOR_RED     "\x1b[91m"
#define COLOR_GREEN   "\x1b[92m"
#define COLOR_YELLOW  "\x1b[93m"
#define COLOR_BLUE    "\x1b[94m"
#define COLOR_MAGENTA "\x1b[95m"
#define COLOR_CYAN    "\x1b[96m"
#define COLOR_WHITE   "\x1b[97m"
#define COLOR_RESET   "\x1b[0m"

#define FAILURE_UNKNOWN     0
#define FAILURE_BUS_ERROR   1

#define INFO                0
#define OK                  1
#define ERROR               2

extern void diag_next(void);

extern void test_newline(void);
extern void test_info(const char * text);
extern void test_warning(const char * text);
extern void test_section(const char *section);
extern void test_start(const char *test);
extern void test_progress(const char *fmt, ...);
extern void test_finish(int level, const char *fmt, ...);

extern int test_all_tests;
extern int test_failures;
extern int test_failure;

extern void (*test_failure_func)(int);

#define STAGE(x) \
  if (stage == x) { \
    if (!error)

#define ON_ERROR \
    else

#define END_STAGE \
    error = 0; stage++; \
  }

#endif
