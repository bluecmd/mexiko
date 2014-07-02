//////////////////////////////////////////////////////////////////////
//
// ORPSoC top for Mexiko
//
// Copyright (C) 2014 Christian Svensson <blue@cmd.nu>
//
//////////////////////////////////////////////////////////////////////
//
// This source file may be used and distributed without
// restriction provided that this copyright statement is not
// removed from the file and that any derivative work contains
// the original copyright notice and the associated disclaimer.
//
// This source file is free software; you can redistribute it
// and/or modify it under the terms of the GNU Lesser General
// Public License as published by the Free Software Foundation;
// either version 3 of the License, or (at your option) any
// later version.
//
// This source is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
// PURPOSE.  See the GNU Lesser General Public License for more
// details.
//
// You should have received a copy of the GNU Lesser General
// Public License along with this source; if not, download it
// from http://www.opencores.org/lgpl.shtml
//
//////////////////////////////////////////////////////////////////////

`include "mexiko-defs.vh"

module orpsoc #(
  parameter       rom0_aw = 8,
  parameter       uart0_aw = 3
)(
  input           sys_clk_i,
  input           sys_rst_i,

  input           dbg_tck_i,
  input           dbg_if_select_i,
  output          dbg_if_tdo_o,
  input           jtag_tap_tdo_i,
  input           jtag_tap_shift_dr_i,
  input           jtag_tap_pause_dr_i,
  input           jtag_tap_update_dr_i,
  input           jtag_tap_capture_dr_i,

  input           uart0_srx_pad_i,
  output          uart0_stx_pad_o
);

  ////////////////////////////////////////////////////////////////////////
  // Clock and reset generation module
  ////////////////////////////////////////////////////////////////////////
  wire    wb_clk;
  wire    wb_rst /* verilator public */;

  clkgen clkgen0 (
    .sys_clk_i(sys_clk_i),
    .sys_rst_i(sys_rst_i),
    .wb_clk_o(wb_clk),
    .wb_rst_o(wb_rst)
  );

  ////////////////////////////////////////////////////////////////////////
  // Modules interconnections
  ////////////////////////////////////////////////////////////////////////
  `include "wb_intercon.vh"

  ////////////////////////////////////////////////////////////////////////
  // System OR1K CPU
  ////////////////////////////////////////////////////////////////////////

  wire    [31:0]  or1k_irq;

  wire    [31:0]  or1k_dbg_dat_i;
  wire    [31:0]  or1k_dbg_adr_i;
  wire            or1k_dbg_we_i;
  wire            or1k_dbg_stb_i;
  wire            or1k_dbg_ack_o;
  wire    [31:0]  or1k_dbg_dat_o;

  wire            or1k_dbg_stall_i /* verilator public */;
  wire            or1k_dbg_ewt_i;
  wire    [3:0]   or1k_dbg_lss_o;
  wire    [1:0]   or1k_dbg_is_o;
  wire    [10:0]  or1k_dbg_wp_o;
  wire            or1k_dbg_bp_o /* verilator public */;
  wire            or1k_dbg_rst;

  wire            sig_tick;

  mor1kx #(
    .FEATURE_DEBUGUNIT("ENABLED"),
    .FEATURE_CMOV("ENABLED"),
    .FEATURE_INSTRUCTIONCACHE("ENABLED"),
    .OPTION_ICACHE_BLOCK_WIDTH(5),
    .OPTION_ICACHE_SET_WIDTH(8),
    .OPTION_ICACHE_WAYS(2),
    .OPTION_ICACHE_LIMIT_WIDTH(32),
    .FEATURE_IMMU("ENABLED"),
    .FEATURE_DATACACHE("ENABLED"),
    .OPTION_DCACHE_BLOCK_WIDTH(5),
    .OPTION_DCACHE_SET_WIDTH(8),
    .OPTION_DCACHE_WAYS(2),
    .OPTION_DCACHE_LIMIT_WIDTH(31),
    .FEATURE_DMMU("ENABLED"),
    .OPTION_PIC_TRIGGER("LATCHED_LEVEL"),

    .IBUS_WB_TYPE("B3_REGISTERED_FEEDBACK"),
    .DBUS_WB_TYPE("B3_REGISTERED_FEEDBACK"),
    .OPTION_CPU0("CAPPUCCINO"),
    .OPTION_RESET_PC(32'hf0000100)
  ) mor1kx0 (
    .iwbm_adr_o(wb_m2s_or1k_i_adr),
    .iwbm_stb_o(wb_m2s_or1k_i_stb),
    .iwbm_cyc_o(wb_m2s_or1k_i_cyc),
    .iwbm_sel_o(wb_m2s_or1k_i_sel),
    .iwbm_we_o (wb_m2s_or1k_i_we),
    .iwbm_cti_o(wb_m2s_or1k_i_cti),
    .iwbm_bte_o(wb_m2s_or1k_i_bte),
    .iwbm_dat_o(wb_m2s_or1k_i_dat),

    .dwbm_adr_o(wb_m2s_or1k_d_adr),
    .dwbm_stb_o(wb_m2s_or1k_d_stb),
    .dwbm_cyc_o(wb_m2s_or1k_d_cyc),
    .dwbm_sel_o(wb_m2s_or1k_d_sel),
    .dwbm_we_o (wb_m2s_or1k_d_we ),
    .dwbm_cti_o(wb_m2s_or1k_d_cti),
    .dwbm_bte_o(wb_m2s_or1k_d_bte),
    .dwbm_dat_o(wb_m2s_or1k_d_dat),

    .clk(wb_clk),
    .rst(wb_rst),

    .iwbm_err_i(wb_s2m_or1k_i_err),
    .iwbm_ack_i(wb_s2m_or1k_i_ack),
    .iwbm_dat_i(wb_s2m_or1k_i_dat),
    .iwbm_rty_i(wb_s2m_or1k_i_rty),

    .dwbm_err_i(wb_s2m_or1k_d_err),
    .dwbm_ack_i(wb_s2m_or1k_d_ack),
    .dwbm_dat_i(wb_s2m_or1k_d_dat),
    .dwbm_rty_i(wb_s2m_or1k_d_rty),

    .irq_i(or1k_irq),

    .du_addr_i(or1k_dbg_adr_i[15:0]),
    .du_stb_i(or1k_dbg_stb_i),
    .du_dat_i(or1k_dbg_dat_i),
    .du_we_i(or1k_dbg_we_i),
    .du_dat_o(or1k_dbg_dat_o),
    .du_ack_o(or1k_dbg_ack_o),
    .du_stall_i(or1k_dbg_stall_i),
    .du_stall_o(or1k_dbg_bp_o)
  );

  ////////////////////////////////////////////////////////////////////////
  // Debug Interface
  ////////////////////////////////////////////////////////////////////////

  adbg_top dbg_if0 (
    /* OR1K interface */
    .cpu0_clk_i     (wb_clk),
    .cpu0_rst_o     (or1k_dbg_rst),
    .cpu0_addr_o    (or1k_dbg_adr_i),
    .cpu0_data_o    (or1k_dbg_dat_i),
    .cpu0_stb_o     (or1k_dbg_stb_i),
    .cpu0_we_o      (or1k_dbg_we_i),
    .cpu0_data_i    (or1k_dbg_dat_o),
    .cpu0_ack_i     (or1k_dbg_ack_o),
    .cpu0_stall_o   (or1k_dbg_stall_i),
    .cpu0_bp_i      (or1k_dbg_bp_o),

    /* TAP interface */
    .tck_i          (dbg_tck_i),
    .tdi_i          (jtag_tap_tdo_i),
    .tdo_o          (dbg_if_tdo_o),
    .rst_i          (wb_rst),
    .capture_dr_i   (jtag_tap_capture_dr_i),
    .shift_dr_i     (jtag_tap_shift_dr_i),
    .pause_dr_i     (jtag_tap_pause_dr_i),
    .update_dr_i    (jtag_tap_update_dr_i),
    .debug_select_i (dbg_if_select_i),

    /* Wishbone debug master */
    .wb_clk_i       (wb_clk),
    .wb_dat_i       (wb_s2m_dbg_dat),
    .wb_ack_i       (wb_s2m_dbg_ack),
    .wb_err_i       (wb_s2m_dbg_err),

    .wb_adr_o       (wb_m2s_dbg_adr),
    .wb_dat_o       (wb_m2s_dbg_dat),
    .wb_cyc_o       (wb_m2s_dbg_cyc),
    .wb_stb_o       (wb_m2s_dbg_stb),
    .wb_sel_o       (wb_m2s_dbg_sel),
    .wb_we_o        (wb_m2s_dbg_we),
    .wb_cti_o       (wb_m2s_dbg_cti),
    .wb_bte_o       (wb_m2s_dbg_bte)
  );

  ////////////////////////////////////////////////////////////////////////
  // ROM
  ////////////////////////////////////////////////////////////////////////

  assign  wb_s2m_rom0_err = 1'b0;
  assign  wb_s2m_rom0_rty = 1'b0;

  rom #(
    .addr_width(rom0_aw)
  ) rom0 (
    .wb_clk         (wb_clk),
    .wb_rst         (wb_rst),
    .wb_adr_i       (wb_m2s_rom0_adr[(rom0_aw + 2) - 1 : 2]),
    .wb_cyc_i       (wb_m2s_rom0_cyc),
    .wb_stb_i       (wb_m2s_rom0_stb),
    .wb_cti_i       (wb_m2s_rom0_cti),
    .wb_bte_i       (wb_m2s_rom0_bte),
    .wb_dat_o       (wb_s2m_rom0_dat),
    .wb_ack_o       (wb_s2m_rom0_ack)
  );

  ////////////////////////////////////////////////////////////////////////
  // UART0
  ////////////////////////////////////////////////////////////////////////

  wire    uart0_irq;

  //assign  wb_s2m_uart0_err = 0;
  //assign  wb_s2m_uart0_rty = 0;

  uart_top uart0 (
    /* Wishbone slave interface */
    .wb_clk_i       (wb_clk),
    .wb_rst_i       (wb_rst),
    .wb_adr_i       (wb_m2s_uart0_adr[uart0_aw-1:0]),
    .wb_dat_i       (wb_m2s_uart0_dat),
    .wb_we_i        (wb_m2s_uart0_we),
    .wb_stb_i       (wb_m2s_uart0_stb),
    .wb_cyc_i       (wb_m2s_uart0_cyc),
    .wb_sel_i       (4'b0), // Not used in 8-bit mode
    .wb_dat_o       (wb_s2m_uart0_dat),
    .wb_ack_o       (wb_s2m_uart0_ack),

    /* Outputs */
    .int_o          (uart0_irq),
    .stx_pad_o      (uart0_stx_pad_o),
    .rts_pad_o      (),
    .dtr_pad_o      (),

    /* Inputs */
    .srx_pad_i      (uart0_srx_pad_i),
    .cts_pad_i      (1'b0),
    .dsr_pad_i      (1'b0),
    .ri_pad_i       (1'b0),
    .dcd_pad_i      (1'b0)
  );

  ////////////////////////////////////////////////////////////////////////
  // Interrupt assignment
  ////////////////////////////////////////////////////////////////////////

  assign or1k_irq[0] = 0; /* Non-maskable inside OR1K */
  assign or1k_irq[1] = 0; /* Non-maskable inside OR1K */
  assign or1k_irq[2] = uart0_irq;
  assign or1k_irq[3] = 0;
  assign or1k_irq[4] = 0;
  assign or1k_irq[5] = 0;
  assign or1k_irq[6] = 0;
  assign or1k_irq[7] = 0;
  assign or1k_irq[8] = 0;
  assign or1k_irq[9] = 0;
  assign or1k_irq[10] = 0;
  assign or1k_irq[11] = 0;
  assign or1k_irq[12] = 0;
  assign or1k_irq[13] = 0;
  assign or1k_irq[14] = 0;
  assign or1k_irq[15] = 0;
  assign or1k_irq[16] = 0;
  assign or1k_irq[17] = 0;
  assign or1k_irq[18] = 0;
  assign or1k_irq[19] = 0;
  assign or1k_irq[20] = 0;
  assign or1k_irq[21] = 0;
  assign or1k_irq[22] = 0;
  assign or1k_irq[23] = 0;
  assign or1k_irq[24] = 0;
  assign or1k_irq[25] = 0;
  assign or1k_irq[26] = 0;
  assign or1k_irq[27] = 0;
  assign or1k_irq[28] = 0;
  assign or1k_irq[29] = 0;
  assign or1k_irq[30] = 0;
  assign or1k_irq[31] = 0;

endmodule // orpsoc_top
