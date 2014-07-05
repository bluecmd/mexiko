/*
 * Mexiko Verilator testbench
 *
 * Author: Christian Svensson <blue@cmd.nu>
 *
 * This program is free software; you can redistribute  it and/or modify it
 * under  the terms of  the GNU General  Public License as published by the
 * Free Software Foundation;  either version 2 of the  License, or (at your
 * option) any later version.
 *
 */

#include <signal.h>
#include <stdint.h>

#include "Vtestbench__Syms.h"

#define NOP_NOP         0x0000      /* Normal nop instruction */
#define NOP_EXIT        0x0001      /* End of simulation */
#define NOP_REPORT      0x0002      /* Simple report */
#define NOP_PUTC        0x0004      /* Simputc instruction */
#define NOP_CNT_RESET   0x0005      /* Reset statistics counters */
#define NOP_GET_TICKS   0x0006      /* Get # ticks running */
#define NOP_GET_PS      0x0007      /* Get picosecs/cycle */
#define NOP_TRACE_ON    0x0008      /* Turn on tracing */
#define NOP_TRACE_OFF   0x0009      /* Turn off tracing */
#define NOP_RANDOM      0x000a      /* Return 4 random bytes */
#define NOP_OR1KSIM     0x000b      /* Return non-zero if this is Or1ksim */
#define NOP_EXIT_SILENT 0x000c      /* End of simulation, quiet version */

#define RESET_TIME      2

bool done;

double sc_time_stamp() {
  return 1337;
}

void signal_int(int signal) {
  done = true;
}

int main(int argc, char **argv, char **env) {
  int t = 0;
  uint32_t insn = 0;
  uint32_t ex_pc = 0;
  uint32_t old_ex_pc = 0;
  uint32_t r1 = 0;
  uint32_t r9 = 0;
  bool wb_reset_released = false;
  bool cpu_stalled = true;
  bool diagnostics = false;
  bool trace = false;
  bool prog_trace = false;

  /* TODO(bluecmd): Use a better lib here */
  if (argc > 1 && !strcmp(argv[1], "--diag")) {
    diagnostics = true;
    argc--;
    argv++;
  }
  if (argc > 1 && !strcmp(argv[1], "--trace")) {
    trace = true;
    argc--;
    argv++;
  }
  else if (argc > 1 && !strcmp(argv[1], "--prog-trace")) {
    prog_trace = true;
    argc--;
    argv++;
  }

  Verilated::commandArgs(argc, argv);

  Vtestbench* top = new Vtestbench;

  top->sys_clk_i = 0;
  top->sys_rst_i = 1;

  done = false;
  signal(SIGINT, signal_int);

  while (!done) {

    top->eval();

    if (t > RESET_TIME && top->sys_rst_i == 1) {
      printf("Reset released\n");
      top->sys_rst_i = 0;

      if (diagnostics) {
        /* Press 'd' for 16 cycles
         * (which is the diff between sys_rst and wb_rst) */
        top->uart_tx_write_i = 1;
        top->uart_tx_data_i = 'd';
      }
    }

    if (!wb_reset_released && top->v->soc_i->wb_rst == 0) {
      printf("Wishbone reset released\n");
      wb_reset_released = true;
      top->uart_tx_write_i = 0;
    }

    if ((top->v->soc_i->or1k_dbg_stall_i || top->v->soc_i->or1k_dbg_bp_o) &&
        !cpu_stalled) {
      printf("CPU stalled\n");
      cpu_stalled = true;
    }

    top->sys_clk_i = !top->sys_clk_i;

    insn = top->v->soc_i->mor1kx0->mor1kx_cpu->monitor_execute_insn;
    ex_pc = top->v->soc_i->mor1kx0->mor1kx_cpu->monitor_execute_pc;
    r1 = top->v->soc_i->mor1kx0->mor1kx_cpu->cappuccino__DOT__mor1kx_cpu->mor1kx_rf_cappuccino->rfa->ram[1];
    r9 = top->v->soc_i->mor1kx0->mor1kx_cpu->cappuccino__DOT__mor1kx_cpu->mor1kx_rf_cappuccino->rfa->ram[9];
    if(ex_pc == 0x100)
      trace = trace || prog_trace;

    if (trace && old_ex_pc != ex_pc)
      printf("PC: %08x = %08x R1 = %08x R9 = %08x\n", ex_pc, insn, r1, r9);
    old_ex_pc = ex_pc;
    t++;
  }

  printf("Simulation ended at PC %08x = %08x\n", ex_pc, insn);

  exit(0);
}
