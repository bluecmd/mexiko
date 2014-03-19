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
  output            ddr3_reset_n_o,
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
  input  [0:0]      pci_refclk100_n_i
);

  assign pci_wake_n_o = 1'b1;
  
  network network_i (
    .refclk_p_i(qsfp_refclk_p_i),
    .refclk_n_i(qsfp_refclk_n_i),
    .areset_i(areset_i),
    .resetdone_o(resetdone_o),
    .txp_o(qsfp_txp_o),
    .txn_o(qsfp_txn_o),
    .rxp_i(qsfp_rxp_i),
    .rxn_i(qsfp_rxn_i)
  );

  xilinx_pcie_2_1_ep_7x pcie_example_i (
    .pci_exp_txp(pci_txp_o),
    .pci_exp_txn(pci_txn_o),
    .pci_exp_rxp(pci_rxp_i),
    .pci_exp_rxn(pci_rxn_i),
    .sys_clk_p(pci_refclk100_p_i[0]),
    .sys_clk_n(pci_refclk100_n_i[0]),
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
    .ddr3_reset_n(ddr3_reset_n_o),
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
    .sys_rst(1'b0));

endmodule
