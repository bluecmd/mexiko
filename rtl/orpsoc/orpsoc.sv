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
  input           sys_rst_n_i,

`ifdef SIM
  output          tdo_pad_o,
  input           tms_pad_i,
  input           tck_pad_i,
  input           tdi_pad_i,
`endif

  input           uart0_srx_pad_i,
  output          uart0_stx_pad_o,
  output          uart0_vcc_pad_o
);

  parameter       IDCODE_VALUE=32'h14951185;

  ////////////////////////////////////////////////////////////////////////
  //
  // Clock and reset generation module
  //
  ////////////////////////////////////////////////////////////////////////
  wire    wb_clk, wb_rst;

  clkgen clkgen0 (
    .sys_clk_i(sys_clk_i),
    .sys_rst_i(sys_rst_n_i),
    .wb_clk_o(wb_clk),
    .wb_rst_o(wb_rst)
  );

  ////////////////////////////////////////////////////////////////////////
  //
  // Modules interconnections
  //
  ////////////////////////////////////////////////////////////////////////
  `include "wb_intercon.vh"

  ////////////////////////////////////////////////////////////////////////
  //
  // JTAG TAP
  //
  ////////////////////////////////////////////////////////////////////////

  wire    dbg_if_select;
  wire    dbg_if_tdo;
  wire    jtag_tap_tdo;
  wire    jtag_tap_shift_dr;
  wire    jtag_tap_pause_dr;
  wire    jtag_tap_update_dr;
  wire    jtag_tap_capture_dr;

`ifdef SIM
  tap_top jtag_tap0 (
    .tdo_pad_o                      (tdo_pad_o),
    .tms_pad_i                      (tms_pad_i),
    .tck_pad_i                      (dbg_tck),
    .trst_pad_i                     (async_rst),
    .tdi_pad_i                      (tdi_pad_i),

    .tdo_padoe_o                    (tdo_padoe_o),

    .tdo_o                          (jtag_tap_tdo),

    .shift_dr_o                     (jtag_tap_shift_dr),
    .pause_dr_o                     (jtag_tap_pause_dr),
    .update_dr_o                    (jtag_tap_update_dr),
    .capture_dr_o                   (jtag_tap_capture_dr),

    .extest_select_o                (),
    .sample_preload_select_o        (),
    .mbist_select_o                 (),
    .debug_select_o                 (dbg_if_select),


    .bs_chain_tdi_i                 (1'b0),
    .mbist_tdi_i                    (1'b0),
    .debug_tdi_i                    (dbg_if_tdo)
  );
`else
  assign jtag_tap_pause_dr = 1'b0;

  BSCANE2 #(
    .JTAG_CHAIN(1)
  )
  xilinx_jtag_i (
    .DRCK(),
    .RESET(),
    .RUNTEST(),
    .TMS(),
    .TCK(dbg_tck),
    .SEL(dbg_if_select),
    .TDO(dbg_if_tdo),
    .TDI(jtag_tap_tdo),
    .SHIFT(jtag_tap_shift_dr),
    .UPDATE(jtag_tap_update_dr),
    .CAPTURE(jtag_tap_capture_dr)
  );
`endif

  ////////////////////////////////////////////////////////////////////////
  //
  // OR1K CPU
  //
  ////////////////////////////////////////////////////////////////////////

  wire    [31:0]  or1k_irq;

  wire    [31:0]  or1k_dbg_dat_i;
  wire    [31:0]  or1k_dbg_adr_i;
  wire            or1k_dbg_we_i;
  wire            or1k_dbg_stb_i;
  wire            or1k_dbg_ack_o;
  wire    [31:0]  or1k_dbg_dat_o;

  wire            or1k_dbg_stall_i;
  wire            or1k_dbg_ewt_i;
  wire    [3:0]   or1k_dbg_lss_o;
  wire    [1:0]   or1k_dbg_is_o;
  wire    [10:0]  or1k_dbg_wp_o;
  wire            or1k_dbg_bp_o;
  wire            or1k_dbg_rst;

  wire            sig_tick;

`ifdef MOR1KX
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
`endif

  ////////////////////////////////////////////////////////////////////////
  //
  // Debug Interface
  //
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
    .tck_i          (dbg_tck),
    .tdi_i          (jtag_tap_tdo),
    .tdo_o          (dbg_if_tdo),
    .rst_i          (wb_rst),
    .capture_dr_i   (jtag_tap_capture_dr),
    .shift_dr_i     (jtag_tap_shift_dr),
    .pause_dr_i     (jtag_tap_pause_dr),
    .update_dr_i    (jtag_tap_update_dr),
    .debug_select_i (dbg_if_select),

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
  //
  // ROM
  //
  ////////////////////////////////////////////////////////////////////////

  assign  wb_s2m_rom0_err = 1'b0;
  assign  wb_s2m_rom0_rty = 1'b0;

  rom #(.addr_width(rom0_aw))
  rom0 (
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
  //
  // UART0
  //
  ////////////////////////////////////////////////////////////////////////

  wire    uart0_irq;

  wire [31:0]     wb8_m2s_uart0_adr;
  wire [1:0]      wb8_m2s_uart0_bte;
  wire [2:0]      wb8_m2s_uart0_cti;
  wire            wb8_m2s_uart0_cyc;
  wire [7:0]      wb8_m2s_uart0_dat;
  wire            wb8_m2s_uart0_stb;
  wire            wb8_m2s_uart0_we;
  wire [7:0]      wb8_s2m_uart0_dat;
  wire            wb8_s2m_uart0_ack;
  wire            wb8_s2m_uart0_err;
  wire            wb8_s2m_uart0_rty;

  assign  wb8_s2m_uart0_err = 0;
  assign  wb8_s2m_uart0_rty = 0;

  uart_top uart16550_0 (
    /* Wishbone slave interface */
    .wb_clk_i       (wb_clk),
    .wb_rst_i       (wb_rst),
    .wb_adr_i       (wb8_m2s_uart0_adr[uart0_aw-1:0]),
    .wb_dat_i       (wb8_m2s_uart0_dat),
    .wb_we_i        (wb8_m2s_uart0_we),
    .wb_stb_i       (wb8_m2s_uart0_stb),
    .wb_cyc_i       (wb8_m2s_uart0_cyc),
    .wb_sel_i       (4'b0), // Not used in 8-bit mode
    .wb_dat_o       (wb8_s2m_uart0_dat),
    .wb_ack_o       (wb8_s2m_uart0_ack),

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

  wb_data_resize wb_data_resize_uart0 (
    /* Wishbone Master interface */
    .wbm_adr_i      (wb_m2s_uart0_adr),
    .wbm_dat_i      (wb_m2s_uart0_dat),
    .wbm_sel_i      (wb_m2s_uart0_sel),
    .wbm_we_i       (wb_m2s_uart0_we ),
    .wbm_cyc_i      (wb_m2s_uart0_cyc),
    .wbm_stb_i      (wb_m2s_uart0_stb),
    .wbm_cti_i      (wb_m2s_uart0_cti),
    .wbm_bte_i      (wb_m2s_uart0_bte),
    .wbm_dat_o      (wb_s2m_uart0_dat),
    .wbm_ack_o      (wb_s2m_uart0_ack),
    .wbm_err_o      (wb_s2m_uart0_err),
    .wbm_rty_o      (wb_s2m_uart0_rty),
    /* Wishbone Slave interface */
    .wbs_adr_o      (wb8_m2s_uart0_adr),
    .wbs_dat_o      (wb8_m2s_uart0_dat),
    .wbs_we_o       (wb8_m2s_uart0_we ),
    .wbs_cyc_o      (wb8_m2s_uart0_cyc),
    .wbs_stb_o      (wb8_m2s_uart0_stb),
    .wbs_cti_o      (wb8_m2s_uart0_cti),
    .wbs_bte_o      (wb8_m2s_uart0_bte),
    .wbs_dat_i      (wb8_s2m_uart0_dat),
    .wbs_ack_i      (wb8_s2m_uart0_ack),
    .wbs_err_i      (wb8_s2m_uart0_err),
    .wbs_rty_i      (wb8_s2m_uart0_rty)
  );

  ////////////////////////////////////////////////////////////////////////
  //
  // Interrupt assignment
  //
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
