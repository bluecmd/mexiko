//////////////////////////////////////////////////////////////////////
//
// Top module for Mexiko
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

`timescale 1ns / 1ps

module mexiko(
  /* System wide */
  input             areset_i,
  output            resetdone_o,

  /* QSFP */
  output [0:7]      qsfp_txp_o,
  output [0:7]      qsfp_txn_o,
  input  [0:7]      qsfp_rxp_i,
  input  [0:7]      qsfp_rxn_i,
  input             qsfp_refclk_p_i,
  input             qsfp_refclk_n_i,

  /* DDR3 */
  inout  [63:0]     ddr3_dq_io,
  inout  [7:0]      ddr3_dqs_n_io,
  inout  [7:0]      ddr3_dqs_p_io,
  output [13:0]     ddr3_addr_o,
  output [2:0]      ddr3_ba_o,
  output            ddr3_ras_n_o,
  output            ddr3_cas_n_o,
  output            ddr3_we_n_o,
  output            ddr3_rst_n_o,
  output [0:0]      ddr3_ck_p_o,
  output [0:0]      ddr3_ck_n_o,
  output [0:0]      ddr3_cke_o,
  output [0:0]      ddr3_cs_n_o,
  output [7:0]      ddr3_dm_o,
  output [0:0]      ddr3_odt_o,
  input             ddr3_refclk_p_i,
  input             ddr3_refclk_n_i,

  /* PCIe */
  output [0:0]      pci_txp_o,
  output [0:0]      pci_txn_o,
  input  [0:0]      pci_rxp_i,
  input  [0:0]      pci_rxn_i,
  input             pci_perst_n_i,
  output            pci_wake_n_o,
  input  [0:0]      pci_refclk100_p_i,
  input  [0:0]      pci_refclk100_n_i,
  
  /* USB UART */
  input             usb_uart_rxd,
  output            usb_uart_txd
);
  wire sys_rst_n;
  wire sys_rst;

  assign pci_wake_n_o = 1'b1;

  /* TODO(bluecmd): Do something nice here, like a counter or something.
   * Also clean up the mess with _n and whatnot. At least see what best practise
   * says about mixing them. */
  assign sys_rst_n = 1'b1;
  assign sys_rst = 1'b0;
  
  /* TODO(bluecmd): Maybe use DDR3 clock instead of PCIe clock?
   * I'm thinking that if we can avoid synchronization on that path it would
   * be nice. */
  IBUFDS_GTE2 sys_clk_ibuf (
    .CEB(1'b0),
    .I(pci_refclk100_p_i[0]),
    .IB(pci_refclk100_n_i[0]),
    .O(sys_clk),
    .ODIV2()
  );

  network network_i (
    .refclk_p_i(qsfp_refclk_p_i),
    .refclk_n_i(qsfp_refclk_n_i),
    .areset_i(sys_rst),
    .resetdone_o(resetdone_o),
    .txp_o(qsfp_txp_o),
    .txn_o(qsfp_txn_o),
    .rxp_i(qsfp_rxp_i),
    .rxn_i(qsfp_rxn_i)
  );

  orpsoc soc_i (
    .sys_clk_i(sys_clk),
    .sys_rst_n_i(sys_rst_n),
`ifdef SIM
    /* TODO(bluecmd): do this */
    .tdo_pad_o,
    .tms_pad_i,
    .tck_pad_i,
    .tdi_pad_i,
`endif
    .uart0_srx_pad_i(usb_uart_rxd),
    .uart0_stx_pad_o(usb_uart_txd)
  );

  xilinx_pcie_2_1_ep_7x pcie_example_i (
    .pci_exp_txp(pci_txp_o),
    .pci_exp_txn(pci_txn_o),
    .pci_exp_rxp(pci_rxp_i),
    .pci_exp_rxn(pci_rxn_i),
    .sys_clk(sys_clk),
    .sys_rst_n(pci_perst_n_i));

  example_top ddr_example_i (
    .ddr3_dq(ddr3_dq_io),
    .ddr3_dqs_n(ddr3_dqs_n_io),
    .ddr3_dqs_p(ddr3_dqs_p_io),
    .ddr3_addr(ddr3_addr_o),
    .ddr3_ba(ddr3_ba_o),
    .ddr3_ras_n(ddr3_ras_n_o),
    .ddr3_cas_n(ddr3_cas_n_o),
    .ddr3_we_n(ddr3_we_n_o),
    .ddr3_reset_n(ddr3_rst_n_o),
    .ddr3_ck_p(ddr3_ck_p_o),
    .ddr3_ck_n(ddr3_ck_n_o),
    .ddr3_cke(ddr3_cke_o),
    .ddr3_cs_n(ddr3_cs_n_o),
    .ddr3_dm(ddr3_dm_o),
    .ddr3_odt(ddr3_odt_o),
    .sys_clk_p(ddr3_refclk_p_i),
    .sys_clk_n(ddr3_refclk_n_i),
    .tg_compare_error(),
    .init_calib_complete(),
    .device_temp_i(12'b0),
    .sys_rst(sys_rst));

endmodule
