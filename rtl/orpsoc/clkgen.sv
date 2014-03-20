//////////////////////////////////////////////////////////////////////
//
// ORPSoC clock generation
//
// Copyright (C) 2014 Christian Svensson <blue@cmd.nu>
// Based on the famous clkgen from ORPSoC
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

module clkgen (
  input  sys_clk_i,
  input  sys_rst_i,
  output  wb_clk_o,
  output  wb_rst_o
);
  /* Reset generation for wishbone */
  wire sync_rst;
  reg [15:0]  wb_rst_shr;

  assign wb_clk_o = sys_clk_i;
  assign wb_rst_o = wb_rst_shr[15];

  ff_syncer #(.RESET_VAL(1'b1)) sys_clk_sync_i (
    .clk_i(sys_clk_i),
    .rst_i(sys_rst_i),
    .data_i(1'b0),
    .data_o(sync_rst)
  );

  always @(posedge wb_clk_o or posedge sys_rst_i)
  begin
    if (sys_rst_i)
      wb_rst_shr <= 16'hffff;
    else
      wb_rst_shr <= {wb_rst_shr[14:0], sync_rst};
  end
endmodule
