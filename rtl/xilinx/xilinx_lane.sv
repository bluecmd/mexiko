//////////////////////////////////////////////////////////////////////
//
// Xilinx specific 10G Ethernet PHY module
// A 10 Gigabit/s Ethernet lane.
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

module xilinx_lane(
    /* shared between lanes */
    input             clk156_i,
    input             reset_i,
    input             txusrclk_i,
    input             txusrclk2_i,
    input             dclk_i,
    input             areset_clk156_i,
    input             gttxreset_i,
    input             gtrxreset_i,
    input             qplllock_i,
    input             qplloutclk_i,
    input             qplloutrefclk_i,
    input             txuserrdy_i,
    input             reset_counter_done_i,

    /* lane specific */
    output            txclk322_o,
    input  [63:0]     xgmii_txd_i,
    input  [7:0]      xgmii_txc_i,
    output reg [63:0] xgmii_rxd_o,
    output reg [7:0]  xgmii_rxc_o,
    output            txp_o,
    output            txn_o,
    input             rxp_i,
    input             rxn_i,
    input             mdio_clk_i,
    input             mdio_i,
    output reg        mdio_o,
    input [4:0]       mdio_prtad_i,
    output [7:0]      core_status_o,
    output            resetdone_o,
    input             signal_detect_i,
    input             tx_fault_i,
    output            tx_disable_o);

    wire drp_gnt;
    wire drp_req;
    wire drp_den_o;
    wire drp_dwe_o;
    wire [15:0] drp_daddr_o;
    wire [15:0] drp_di_o;
    wire drp_drdy_o;
    wire [15:0] drp_drpdo_o;
    wire drp_den_i;
    wire drp_dwe_i;
    wire [15:0] drp_daddr_i;
    wire [15:0] drp_di_i;
    wire drp_drdy_i;
    wire [15:0] drp_drpdo_i;

    wire tx_resetdone_int;
    wire rx_resetdone_int;

    assign resetdone_o = tx_resetdone_int && rx_resetdone_int;

    assign drp_gnt = drp_req;
    assign drp_den_i = drp_den_o;
    assign drp_dwe_i = drp_dwe_o;
    assign drp_daddr_i = drp_daddr_o;
    assign drp_di_i = drp_di_o;
    assign drp_drdy_i = drp_drdy_o;
    assign drp_drpdo_i = drp_drpdo_o;

    xilinx_phy10g xilinx_phy10g_i
        (
            /* shared logic inputs */
            .clk156(clk156_i),
            .txusrclk(txusrclk_i),
            .txusrclk2(txusrclk2_i),
            .dclk(dclk_i),
            .areset(reset_i),
            .areset_clk156(areset_clk156_i),

            .gttxreset(gttxreset_i),
            .gtrxreset(gtrxreset_i),
            .qplllock(qplllock_i),
            .qplloutclk(qplloutclk_i),
            .qplloutrefclk(qplloutrefclk_i),

            .reset_counter_done(reset_counter_done_i),
            .tx_resetdone(tx_resetdone_int),
            .rx_resetdone(rx_resetdone_int),

            .txuserrdy(txuserrdy_i),
            .xgmii_txd(xgmii_txd_i),
            .xgmii_txc(xgmii_txc_i),
            .xgmii_rxd(xgmii_rxd_o),
            .xgmii_rxc(xgmii_rxc_o),

            .txp(txp_o),
            .txn(txn_o),
            .rxp(rxp_i),
            .rxn(rxn_i),
            .mdc(mdio_clk_i),
            .mdio_in(mdio_i),
            .mdio_out(mdio_o),
            .mdio_tri(),
            .prtad(mdio_prtad_i),

            .signal_detect(signal_detect_i),
            .tx_fault(tx_fault_i),
            .tx_disable(tx_disable_o),
            .txclk322(txclk322_o),

            /* misc signals */
            .core_status(core_status_o),
            /* 111 = 10GBASE-SR
               110 = 10GBASE-LR
               101 = 10GBASE-ER */
            .pma_pmd_type(3'b110),

            /* dynamic reconfiguration port (DRP) things */
            .drp_req(drp_req),
            .drp_gnt(drp_gnt),
            .drp_den_o(drp_den_o),
            .drp_dwe_o(drp_dwe_o),
            .drp_daddr_o(drp_daddr_o),
            .drp_di_o(drp_di_o),
            .drp_drdy_o(drp_drdy_o),
            .drp_drpdo_o(drp_drpdo_o),
            .drp_den_i(drp_den_i),
            .drp_dwe_i(drp_dwe_i),
            .drp_daddr_i(drp_daddr_i),
            .drp_di_i(drp_di_i),
            .drp_drdy_i(drp_drdy_i),
            .drp_drpdo_i(drp_drpdo_i)
        );
endmodule
