
module testbench (
    input           sys_clk_i,
    input           sys_rst_i,

    output          tdo_pad_o,
    input           tms_pad_i,
    input           tck_pad_i,
    input           tdi_pad_i,
    input [7:0]     uart_tx_data_i,
    input           uart_tx_write_i
);
  parameter STDOUT = 32'h8000_0001;
  // 80 MHz / (16 * 115200 Baud) = ~43
  parameter UART_DIVISOR = 16'd43;
  // We want to use half the BPI Flash (which is 1 Gbit)
  // 1024^3 / 2 / 16 bit = 33554431 (64 MiB)
  parameter BPI_SIZE = 33554431;

  reg [15:0]  g18_mem [0:BPI_SIZE];

  wire [7:0]  uart_rx_data;
  wire        uart_rx_done;
  wire        uart_tx_done;
  reg         uart_tx_wr = 1'b0;
  reg         uart_tx_busy = 1'b0;
  wire        uart_txd;
  wire        uart_rxd;
  wire        dbg_tck;
  wire        dbg_if_select;
  wire        dbg_if_tdo;
  wire        jtag_tap_tdo;
  wire        jtag_tap_shift_dr;
  wire        jtag_tap_pause_dr;
  wire        jtag_tap_update_dr;
  wire        jtag_tap_capture_dr;

  wire [15:0] g18_dat;
  wire [24:0] g18_adr;

  orpsoc soc_i (
    .sys_clk_i            (sys_clk_i),
    .sys_rst_i            (sys_rst_i),
    .uart0_srx_pad_i      (uart_rxd),
    .uart0_stx_pad_o      (uart_txd),
    .dbg_tck_i            (dbg_tck),
    .dbg_if_select_i      (dbg_if_select),
    .dbg_if_tdo_o         (dbg_if_tdo),
    .jtag_tap_tdo_i       (jtag_tap_tdo),
    .jtag_tap_shift_dr_i  (jtag_tap_shift_dr),
    .jtag_tap_pause_dr_i  (jtag_tap_pause_dr),
    .jtag_tap_update_dr_i (jtag_tap_update_dr),
    .jtag_tap_capture_dr_i(jtag_tap_capture_dr),
    .g18_dat_i            (g18_dat),
    .g18_adr_o            (g18_adr)
  );

  tap_top jtag_tap0 (
    .tdo_pad_o(tdo_pad_o),
    .tms_pad_i(tms_pad_i),
    .tck_pad_i(dbg_tck),
    .trst_pad_i(sys_rst_i),
    .tdi_pad_i(tdi_pad_i),
    .tdo_padoe_o(),
    .tdo_o(jtag_tap_tdo),
    .shift_dr_o(jtag_tap_shift_dr),
    .pause_dr_o(jtag_tap_pause_dr),
    .update_dr_o(jtag_tap_update_dr),
    .capture_dr_o(jtag_tap_capture_dr),
    .extest_select_o(),
    .sample_preload_select_o(),
    .mbist_select_o(),
    .debug_select_o(dbg_if_select),
    .bs_chain_tdi_i(1'b0),
    .mbist_tdi_i(1'b0),
    .debug_tdi_i(dbg_if_tdo)
  );

  uart_transceiver uart_i (
    .sys_rst(sys_rst_i),
    .sys_clk(sys_clk_i),
    .uart_rx(uart_txd),
    .uart_tx(uart_rxd),
    .divisor(UART_DIVISOR),
    .rx_data(uart_rx_data),
    .rx_done(uart_rx_done),
    .tx_data(uart_tx_data_i),
    .tx_wr(uart_tx_wr),
    .tx_done(uart_tx_done),
    .rx_break()
  );

  always @(posedge sys_clk_i)
  begin
    if (uart_rx_done) begin
      $write("%c", uart_rx_data);
      $fflush(STDOUT);
    end
  end

  always @(posedge sys_clk_i)
  begin
    uart_tx_wr <= 1'b0;
    if (uart_tx_done) begin
      uart_tx_busy <= 1'b0;
    end
    if (uart_tx_write_i) begin
      if (~uart_tx_busy & ~sys_rst_i) begin
        uart_tx_wr <= 1'b1;
        uart_tx_busy <= 1'b1;
      end
    end
  end

  always @(posedge sys_clk_i)
  begin
    g18_dat <= g18_mem[g18_adr];
  end

  initial
  begin
    $display("Mexiko Testbench started");
    $readmemh("../../src/mexiko.memh", g18_mem);
    $display("Boot ROM: %04x%04x", g18_mem[26'h0], g18_mem[26'h1]);
    $display("Diag ROM: %04x%04x", g18_mem[26'h800000], g18_mem[26'h800001]);
  end

endmodule
