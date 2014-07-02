//////////////////////////////////////////////////////////////////////
//
// FF based synchronizer
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

module ff_syncer #(
  parameter SYNC_REGS = 4,
  parameter RESET_VAL = 1'b0
) (
  input   clk_i,
  input   rst_i,
  input   data_i,
  output  data_o
);

  /* note: this _must_ be named sync_r for the timing constraint false paths
     to find this construct. */
  (* shreg_extract = "no", ASYNC_REG = "TRUE"
  *) reg  [SYNC_REGS-1:0] sync_r = {SYNC_REGS{RESET_VAL}};

  assign data_o = sync_r[SYNC_REGS-1];

  always @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
      sync_r <= {SYNC_REGS{RESET_VAL}};
    else
      sync_r <= {sync_r[SYNC_REGS-2:0], data_i};
  end
endmodule
