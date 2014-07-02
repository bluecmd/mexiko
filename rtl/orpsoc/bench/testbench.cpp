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

double sc_time_stamp() {
  return 1337;
}

int main(int argc, char **argv, char **env) {
  int t = 0;
  uint32_t insn = 0;
  uint32_t ex_pc = 0;
  uint32_t old_ex_pc = 0;
  bool wb_reset_released = false;
  bool cpu_stalled = true;

  Verilated::commandArgs(argc, argv);

  Vtestbench* top = new Vtestbench;

  top->sys_clk_i = 0;
  top->sys_rst_i = 1;

  while (1) {

    top->eval();

    if (t > RESET_TIME && top->sys_rst_i == 1) {
      printf("Reset released\n");
      top->sys_rst_i = 0;
    }

    if (!wb_reset_released && top->v->soc_i->wb_rst == 0) {
      printf("Wishbone reset released\n");
      wb_reset_released = true;
    }

    if ((top->v->soc_i->or1k_dbg_stall_i || top->v->soc_i->or1k_dbg_bp_o) &&
        !cpu_stalled) {
      printf("CPU stalled\n");
      cpu_stalled = true;
    }

    top->sys_clk_i = !top->sys_clk_i;

    insn = top->v->soc_i->mor1kx0->mor1kx_cpu->monitor_execute_insn;
    ex_pc = top->v->soc_i->mor1kx0->mor1kx_cpu->monitor_execute_pc;
#ifdef DEBUG_TRACE
    if (old_ex_pc != ex_pc)
      printf("PC: %08x = %08x\n", ex_pc, insn);
#endif
    old_ex_pc = ex_pc;
    t++;
  }

  exit(0);
}
