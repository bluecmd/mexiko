//////////////////////////////////////////////////////////////////////
//
// Xilinx specific 8x10G Ethernet PHY module
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

module xilinx_octa10g (
  input             refclk_p_i,
  input             refclk_n_i,
  input             areset_i,
  output            resetdone_o,

  input             mdio_clk_i,
  input             mdio_i,
  output reg        mdio_o,
  input [2:0]       mdio_sel_i,

  /* lane specific */
  input  [63:0]     xgmii_txd_i           [0:7],
  input  [7:0]      xgmii_txc_i           [0:7],
  output reg [63:0] xgmii_rxd_o           [0:7],
  output reg [7:0]  xgmii_rxc_o           [0:7],
  output [0:7]      txp_o,
  output [0:7]      txn_o,
  input  [0:7]      rxp_i,
  input  [0:7]      rxn_i,
  input  [0:7]      signal_detect_i,
  input  [0:7]      tx_fault_i,
  output [0:7]      tx_disable_o
);

  wire refclk;
  wire clk156;
  wire txclk322 [0:7];
  wire dclk;
  wire areset_clk156;
  wire gttxreset;
  wire gtrxreset;
  wire txuserrdy;
  wire txusrclk;
  wire txusrclk2;
  wire reset_counter_done;
  wire resetdone_lane [0:7];
  wire mdio_lane_out [0:7];

  wire qpllreset;
  wire qplllock [0:1];
  wire qplloutclk [0:1];
  wire qplloutrefclk [0:1];
  wire qplllock_all;

  assign qplllock_all = qplllock[0] & qplllock[1];
  
  /* TODO(bluecmd): this is probably super bad for timing */
  assign mdio_o = mdio_lane_out[mdio_sel_i];

  assign resetdone_o = (
    resetdone_lane[0] & resetdone_lane[1] & resetdone_lane[2] &
    resetdone_lane[3] & resetdone_lane[4] & resetdone_lane[5] &
    resetdone_lane[6] & resetdone_lane[7]);

  xilinx_phy10g_shared_logic shared_logic_i(
    .areset_i(areset_i),
    .refclk_p_i(refclk_p_i),
    .refclk_n_i(refclk_n_i),
    .refclk_o(refclk),
    .clk156_o(clk156),
    .txclk322_i(txclk322[0]),
    .dclk_o(dclk),
    .qplllock_i(qplllock_all),
    .areset_clk156_o(areset_clk156),
    .gttxreset_o(gttxreset),
    .gtrxreset_o(gtrxreset),
    .txuserrdy_o(txuserrdy),
    .txusrclk_o(txusrclk),
    .txusrclk2_o(txusrclk2),
    .qpllreset_o(qpllreset),
    .reset_counter_done_o(reset_counter_done)
  );

  genvar idx;
  generate
    for (idx=0; idx < 2; idx=idx+1) 
    begin: gen_quad_logic
      xilinx_phy10g_quad_logic quad_logic_i(
        .refclk_i(refclk),
        .qpllreset_i(qpllreset),
        .qplllock_o(qplllock[idx]),
        .qplloutclk_o(qplloutclk[idx]),
        .qplloutrefclk_o(qplloutrefclk[idx])
      );
    end
  endgenerate

  generate
    for (idx=0; idx < 8; idx=idx+1) 
    begin: gen_lane
      xilinx_lane lane(
        /* shared between lanes */
        .clk156_i(clk156),
        .reset_i(areset_i),
        .txusrclk_i(txusrclk),
        .txusrclk2_i(txusrclk2),
        .dclk_i(dclk),
        .areset_clk156_i(areset_clk156),
        .gttxreset_i(gttxreset),
        .gtrxreset_i(gtrxreset),
        .qplllock_i(qplllock[idx < 4 ? 0 : 1]),
        .qplloutclk_i(qplloutclk[idx < 4 ? 0 : 1]),
        .qplloutrefclk_i(qplloutrefclk[idx < 4 ? 0 : 1]),
        .txuserrdy_i(txuserrdy),
        .reset_counter_done_i(reset_counter_done),

        /* lane specific */
        .txclk322_o(txclk322[idx]),
        .xgmii_txd_i(xgmii_txd_i[idx]),
        .xgmii_txc_i(xgmii_txc_i[idx]),
        .xgmii_rxd_o(xgmii_rxd_o[idx]),
        .xgmii_rxc_o(xgmii_rxc_o[idx]),
        .txp_o(txp_o[idx]),
        .txn_o(txn_o[idx]),
        .rxp_i(rxp_i[idx]),
        .rxn_i(rxn_i[idx]),
        .mdio_clk_i(mdio_clk_i),
        .mdio_i(mdio_i),
        .mdio_o(mdio_lane_out[idx]),
        .mdio_prtad_i(5'b0),
        .core_status_o(),
        .resetdone_o(resetdone_lane[idx]),
        .signal_detect_i(signal_detect_i[idx]),
        .tx_fault_i(tx_fault_i[idx]),
        .tx_disable_o(tx_disable_o[idx])
      );
     end
  endgenerate

endmodule
