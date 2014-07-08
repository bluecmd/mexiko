//////////////////////////////////////////////////////////////////////
//
// Kuba top for Mexiko
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

module kuba (
  input           sys_clk_i,
  input           sys_rst_i,
  output          wb_clk_o,

  input  [3:0]    gic_dat_i,
  output [3:0]    gic_dat_o,

  inout  [15:0]   g18_dat_io,
  output [g18_aw-1:0] g18_adr_o,
  output          g18_wen_o
);

  ////////////////////////////////////////////////////////////////////////
  // Clock and reset generation module
  ////////////////////////////////////////////////////////////////////////
  wire    wb_clk;
  wire    wb_rst /* verilator public */;
  assign  wb_clk_o = wb_clk;

  clkgen clkgen_i (
    .sys_clk_i(sys_clk_i),
    .sys_rst_i(sys_rst_i),
    .wb_clk_o(wb_clk),
    .wb_rst_o(wb_rst)
  );

  ////////////////////////////////////////////////////////////////////////
  // Wishbone bus
  ////////////////////////////////////////////////////////////////////////
  `include "wb_intercon_kuba.vh"

  gic_slave gic_i (
    .wbm_clk_i(wb_clk),
    .wbm_rst_i(wb_rst),
    .wbm_adr_o(wb_m2s_gic_adr),
    .wbm_stb_o(wb_m2s_gic_stb),
    .wbm_cyc_o(wb_m2s_gic_cyc),
    .wbm_sel_o(wb_m2s_gic_sel),
    .wbm_we_o (wb_m2s_gic_we),
    .wbm_cti_o(wb_m2s_gic_cti),
    .wbm_bte_o(wb_m2s_gic_bte),
    .wbm_dat_o(wb_m2s_gic_dat),
    .wbm_err_i(wb_s2m_gic_err),
    .wbm_ack_i(wb_s2m_gic_ack),
    .wbm_rty_i(wb_s2m_gic_rty),
    .wbm_dat_i(wb_s2m_gic_dat),
    .gic_dat_i(gic_dat_i),
    .gic_dat_o(gic_dat_o)
  );

  ////////////////////////////////////////////////////////////////////////
  // Debug Slave (used to test GIC)
  ////////////////////////////////////////////////////////////////////////

  parameter g18_size  = 16777216; // 16 MiB
  parameter g18_aw    = $clog2(g18_size/2);
  wb_g18 #(
    .g18_size(g18_size),
    .g18_aw(g18_aw)
  ) g18 (
    .wb_clk_i   (wb_clk),
    .wb_rst_i   (wb_rst),
    .wb_dat_i   (wb_m2s_g18_dat),
    .wb_adr_i   (wb_m2s_g18_adr),
    .wb_sel_i   (wb_m2s_g18_sel),
    .wb_cti_i   (wb_m2s_g18_cti),
    .wb_bte_i   (wb_m2s_g18_bte),
    .wb_we_i    (wb_m2s_g18_we),
    .wb_cyc_i   (wb_m2s_g18_cyc),
    .wb_stb_i   (wb_m2s_g18_stb),
    .wb_dat_o   (wb_s2m_g18_dat),
    .wb_ack_o   (wb_s2m_g18_ack),
    .wb_err_o   (wb_s2m_g18_err),
    .g18_dat_io (g18_dat_io),
    .g18_adr_o  (g18_adr_o),
    .g18_csn_o  (),
    .g18_oen_o  (),
    .g18_wen_o  (g18_wen_o),
    .g18_advn_o (),
    .g18_clk_o  (),
    .g18_rstn_o ()
  );

endmodule
