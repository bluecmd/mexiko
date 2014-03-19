`timescale 1ns / 1ps

module xilinx_phy10g_shared_logic(
  input  areset_i,
  input  refclk_p_i,
  input  refclk_n_i,
  output refclk_o, 

  input  txclk322_i,
  output clk156_o,
  output dclk_o,
  input  qplllock_i,
  output wire areset_clk156_o,
  output gttxreset_o,
  output gtrxreset_o,
  output reg txuserrdy_o,
  output txusrclk_o,
  output txusrclk2_o,

  output qpllreset_o,
  output reset_counter_done_o
);

  wire      clk156;
  wire      txusrclk;
  wire      txusrclk2;
  wire      gttxreset;
  wire      qplllock_txusrclk2;
  reg [7:0] reset_counter = 8'h00;
  reg [3:0] reset_pulse = 4'b1110;
  wire      gttxreset_txusrclk2;

  assign reset_counter_done = reset_counter[7];
  assign txusrclk2 = txusrclk;

  assign dclk_o = clk156_o;
  assign txusrclk_o = txusrclk;
  assign txusrclk2_o = txusrclk2;
  assign reset_counter_done_o = reset_counter_done;

  assign gttxreset = reset_pulse[0];
  assign gttxreset_o = gttxreset;

  assign qpllreset_o = reset_pulse[0];
  assign gtrxreset_o = reset_pulse[0];

  assign clk156_o = clk156;

  IBUFDS_GTE2 refclk_ibufds_i (
    .O     (refclk_o),
    .ODIV2 (),
    .CEB   (1'b0),
    .I     (refclk_p_i),
    .IB    (refclk_n_i)
  );

  BUFG tx322clk_bufg_i (
    .I (txclk322_i),
    .O (txusrclk)
  );

  BUFG clk156_bufg_i (
    .I (refclk_o),
    .O (clk156)
  );

  ff_syncer #(.SYNC_REGS(4), .RESET_VAL(1'b1)) areset_clk156_sync_i (
    .clk_i(clk156),
    .rst_i(areset_i),
    .data_i(1'b0),
    .data_o(areset_clk156_o)
  );

  ff_syncer #(.SYNC_REGS(4), .RESET_VAL(1'b0)) qplllock_txusrclk2_sync_i (
    .clk_i(txusrclk2),
    .rst_i(!qplllock_i),
    .data_i(1'b1),
    .data_o(qplllock_txusrclk2)
  );

  ff_syncer #(.SYNC_REGS(4), .RESET_VAL(1'b1)) gttxreset_txusrclk2_sync_i (
    .clk_i(txusrclk2),
    .rst_i(gttxreset),
    .data_i(1'b0),
    .data_o(gttxreset_txusrclk2)
  );

  // Hold off release the GT resets until 500ns after configuration.
  // 128 ticks at 6.4ns period will be >> 500 ns.
  always @(posedge clk156)
  begin
    if (!reset_counter[7])
      reset_counter   <=   reset_counter + 1'b1;   
    else
      reset_counter   <=   reset_counter;
  end

  always @(posedge clk156)
  begin
    if (areset_clk156_o == 1'b1)  
      reset_pulse   <=   4'b1110;
    else if(reset_counter[7])
      reset_pulse   <=   {1'b0, reset_pulse[3:1]};
  end

  always @(posedge txusrclk2 or posedge gttxreset_txusrclk2)
  begin
    if(gttxreset_txusrclk2)
      txuserrdy_o <= 1'b0;
    else
      txuserrdy_o <= qplllock_txusrclk2;
  end

endmodule
