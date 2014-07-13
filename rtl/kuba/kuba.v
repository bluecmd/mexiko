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

  input           eth0_tx_clk,
  output [3:0]    eth0_tx_data,
  output          eth0_tx_en,
  output          eth0_tx_er,
  input           eth0_rx_clk,
  input [3:0]     eth0_rx_data,
  input           eth0_dv,
  input           eth0_rx_er,
  input           eth0_col,
  input           eth0_crs,
  output          eth0_mdc_pad_o,
  inout           eth0_md_pad_io,
  output          eth0_rst_n_o
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
  // Expansion Memory
  ////////////////////////////////////////////////////////////////////////

  wb_ram #(
    .depth(32*1024)
  ) expram_i (
    .wb_clk_i   (wb_clk),
    .wb_rst_i   (wb_rst),
    .wb_dat_i   (wb_m2s_expram_dat),
    .wb_adr_i   (wb_m2s_expram_adr[14:0]),
    .wb_sel_i   (wb_m2s_expram_sel),
    .wb_cti_i   (wb_m2s_expram_cti),
    .wb_bte_i   (wb_m2s_expram_bte),
    .wb_we_i    (wb_m2s_expram_we),
    .wb_cyc_i   (wb_m2s_expram_cyc),
    .wb_stb_i   (wb_m2s_expram_stb),
    .wb_dat_o   (wb_s2m_expram_dat),
    .wb_ack_o   (wb_s2m_expram_ack)
  );

  ////////////////////////////////////////////////////////////////////////
  // Management Ethernet
  ////////////////////////////////////////////////////////////////////////
  wire          eth0_irq;
  wire [3:0]    eth0_mtxd;
  wire          eth0_mtxen;
  wire          eth0_mtxerr;
  wire          eth0_mtx_clk;
  wire          eth0_mrx_clk;
  wire [3:0]    eth0_mrxd;
  wire          eth0_mrxdv;
  wire          eth0_mrxerr;
  wire          eth0_mcoll;
  wire          eth0_mcrs;
  wire          eth0_speed;
  wire          eth0_duplex;
  wire          eth0_link;
  // Management interface wires
  wire          eth0_md_i;
  wire          eth0_md_o;
  wire          eth0_md_oe;

  // Hook up MII wires
  assign eth0_mtx_clk   = eth0_tx_clk;
  assign eth0_tx_data   = eth0_mtxd[3:0];
  assign eth0_tx_en     = eth0_mtxen;
  assign eth0_tx_er     = eth0_mtxerr;
  assign eth0_mrxd[3:0] = eth0_rx_data;
  assign eth0_mrxdv     = eth0_dv;
  assign eth0_mrxerr    = eth0_rx_er;
  assign eth0_mrx_clk   = eth0_rx_clk;
  assign eth0_mcoll     = eth0_col;
  assign eth0_mcrs      = eth0_crs;

  // Tristate control for management interface
  assign eth0_md_pad_io = eth0_md_oe ? eth0_md_o : 1'bz;
  assign eth0_md_i = eth0_md_pad_io;

  assign eth0_rst_n_o = !wb_rst;

  ethmac ethmac_i (
    // Wishbone Slave interface
    .wb_clk_i   (wb_clk),
    .wb_rst_i   (wb_rst),
    .wb_adr_i   (wb_m2s_eth0_adr[11:2]),
    .wb_dat_i   (wb_m2s_eth0_dat),
    .wb_sel_i   (wb_m2s_eth0_sel),
    .wb_we_i    (wb_m2s_eth0_we),
    .wb_cyc_i   (wb_m2s_eth0_cyc),
    .wb_stb_i   (wb_m2s_eth0_stb),
    .wb_dat_o   (wb_s2m_eth0_dat),
    .wb_err_o   (wb_s2m_eth0_err),
    .wb_ack_o   (wb_s2m_eth0_ack),
    // Wishbone Master Interface
    .m_wb_adr_o (wb_m2s_eth0_master_adr),
    .m_wb_sel_o (wb_m2s_eth0_master_sel),
    .m_wb_we_o  (wb_m2s_eth0_master_we),
    .m_wb_dat_o (wb_m2s_eth0_master_dat),
    .m_wb_cyc_o (wb_m2s_eth0_master_cyc),
    .m_wb_stb_o (wb_m2s_eth0_master_stb),
    .m_wb_cti_o (wb_m2s_eth0_master_cti),
    .m_wb_bte_o (wb_m2s_eth0_master_bte),
    .m_wb_dat_i (wb_s2m_eth0_master_dat),
    .m_wb_ack_i (wb_s2m_eth0_master_ack),
    .m_wb_err_i (wb_s2m_eth0_master_err),

    // Ethernet MII interface
    // Transmit
    .mtxd_pad_o    (eth0_mtxd[3:0]),
    .mtxen_pad_o   (eth0_mtxen),
    .mtxerr_pad_o  (eth0_mtxerr),
    .mtx_clk_pad_i (eth0_mtx_clk),
    // Receive
    .mrx_clk_pad_i (eth0_mrx_clk),
    .mrxd_pad_i    (eth0_mrxd[3:0]),
    .mrxdv_pad_i   (eth0_mrxdv),
    .mrxerr_pad_i  (eth0_mrxerr),
    .mcoll_pad_i   (eth0_mcoll),
    .mcrs_pad_i    (eth0_mcrs),
    // Management interface
    .md_pad_i      (eth0_md_i),
    .mdc_pad_o     (eth0_mdc_pad_o),
    .md_pad_o      (eth0_md_o),
    .md_padoe_o    (eth0_md_oe),

    // Processor interrupt
    .int_o         (eth0_irq)
  );

endmodule
