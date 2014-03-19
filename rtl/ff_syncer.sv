`timescale 1ns / 1ps

module ff_syncer #(
  parameter SYNC_REGS = 3,
  parameter RESET_VAL = 1'b0
) (
  input   wire  clk_i,
  input   wire  rst_i,
  input   wire  data_i,
  output  wire  data_o
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
