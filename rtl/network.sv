//////////////////////////////////////////////////////////////////////
//
// 8x10GbE module for Mexiko
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

module network(
    input             refclk_p_i,
    input             refclk_n_i,
    input             areset_i,
    output            resetdone_o,

    output [0:7]      txp_o,
    output [0:7]      txn_o,
    input  [0:7]      rxp_i,
    input  [0:7]      rxn_i
);

  wire [63:0] xgmii_txd [0:7];
  wire [7:0]  xgmii_txc [0:7];
  wire [63:0] xgmii_rxd [0:7];
  wire [7:0]  xgmii_rxc [0:7];

  genvar idx;
  generate
    for (idx = 0; idx < 8; idx=idx+1)
    begin: gen_test_loop
      assign xgmii_txd[idx] = xgmii_rxd[7-idx];
      assign xgmii_txc[idx] = xgmii_rxc[7-idx];
    end
  endgenerate

  xilinx_octa10g octa_i (
    .refclk_p_i(refclk_p_i),
    .refclk_n_i(refclk_n_i),
    .areset_i(areset_i),
    .resetdone_o(resetdone_o),

    .mdio_clk_i(1'b0),
    .mdio_i(1'b0),
    .mdio_o(),
    .mdio_sel_i(3'b0),

    .txp_o(txp_o),
    .txn_o(txn_o),
    .rxp_i(rxp_i),
    .rxn_i(rxn_i),

    .xgmii_txd_i(xgmii_txd),
    .xgmii_txc_i(xgmii_txc),
    .xgmii_rxd_o(xgmii_rxd),
    .xgmii_rxc_o(xgmii_rxc),

    .signal_detect_i(8'b0),
    .tx_fault_i(8'b0),
    .tx_disable_o()
  );

endmodule
