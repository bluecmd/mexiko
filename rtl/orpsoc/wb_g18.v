
// TODO(bluecmd): This module assumes that the G18 Flash is in 
// asynchronous mode. It will assume 16 cycles latency (> worst case) and
// will not do brusts. Quite a lot of areas to improve :-).

module wb_g18 #(
  parameter g18_size  = 67108864, // 512 Mbit
  parameter g18_aw    = $clog2(g18_size/2),
  parameter wb_dw     = 32,
  parameter wb_aw     = 32
) (
  input               wb_clk_i,
  input               wb_rst_i,
  input  [wb_aw-1:0]  wb_adr_i,
  input  [wb_dw-1:0]  wb_dat_i,
  input  [3:0]        wb_sel_i,
  input               wb_we_i,
  input  [1:0]        wb_bte_i,
  input  [2:0]        wb_cti_i,
  input               wb_cyc_i,
  input               wb_stb_i,
  output              wb_ack_o,
  output              wb_err_o,
  output [wb_dw-1:0]  wb_dat_o,

  input  [15:0]       g18_dat_i,
  output [15:0]       g18_adr_o,
  output              g18_csn_o,
  output              g18_oen_o,
  output              g18_wen_o,
  output              g18_advn_o,
  output              g18_clk_o,
  output              g18_rstn_o
);
  reg [g18_aw-1:0]    g18_adr_r = 0;
  reg [3:0]           latency_r = 4'hf;
  reg [3:0]           data_valid_cntr_r = 0;
  reg                 data_half_r = 1'b0;
  reg                 valid_r = 1'b0;
  reg                 adr_valid_r = 1'b0;
  reg                 wb_ack_r = 1'b0;

  reg [wb_dw-1:0]     wb_dat_r = 0;

  wire valid = wb_cyc_i & wb_stb_i;
  wire new_cycle = valid & !valid_r;
  wire data_valid = (data_valid_cntr_r == 0);

  assign wb_ack_o = wb_ack_r;
  assign wb_dat_o = wb_dat_r;

  assign g18_rstn_o = ~wb_rst_i;
  assign g18_clk_o = 1'b0;

  assign g18_csn_o = 1'b0;
  assign g18_oen_o = 1'b0;
  assign g18_wen_o = 1'b1;

  assign g18_adr_o = g18_adr_r;
  assign g18_advn_o = ~adr_valid_r;

  always @(posedge wb_clk_i)
  begin
    if (wb_rst_i) begin
      adr_valid_r <= 1'b0;
      valid_r <= 1'b0;
      g18_adr_r <= 0;
    end else begin
      adr_valid_r <= 1'b0;
      valid_r <= valid;

      if (new_cycle) begin
        adr_valid_r <= 1'b1;
        g18_adr_r <= wb_adr_i[1+:g18_aw];
      end
    end
  end

  always @(posedge wb_clk_i)
  begin
    if (wb_rst_i) begin
      data_half_r <= 1'b0;
      data_valid_cntr_r <= data_valid_cntr_r - 4'b1;
    end else begin
      if (~data_valid) begin
        data_valid_cntr_r <= data_valid_cntr_r - 4'b1;
      end

      if (new_cycle) begin
        data_half_r <= 1'b0;
        data_valid_cntr_r <= latency_r;
      end
      if (data_valid & ~data_half_r) begin
        data_half_r <= 1'b1;
        g18_adr_r <= g18_adr_r + 1;
        data_valid_cntr_r <= latency_r;
        wb_dat_r[31:16] = g18_dat_i;
      end

      if (data_valid & data_half_r) begin
        wb_dat_r[15:0] = g18_dat_i;
      end
    end
  end

  always @(posedge wb_clk_i)
  begin
    if (wb_rst_i) begin
      wb_ack_r <= 1'b0;
    end else begin
      wb_ack_r <= valid & data_valid & ~wb_ack_r & ~new_cycle & data_half_r;
    end
  end

`ifdef DEBUG
  always @(posedge wb_clk_i)
  begin
    if (adr_valid_r) begin
      $display("New read cycle: 0x%08x", {g18_adr_r, 1'b0});
    end
    if (wb_ack_r) begin
      $display("Finished read cycle: 0x%08x", {g18_adr_r, 1'b0});
      $display("Data returned: 0x%08x", wb_dat_o);
      $display("Data returned: 0x%08x", g18_dat_i);
    end
  end
`endif
endmodule