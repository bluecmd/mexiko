
module testbench (
    input           sys_clk_i,
    input           sys_rst_i,

    output          tdo_pad_o,
    input           tms_pad_i,
    input           tck_pad_i,
    input           tdi_pad_i
);
  wire [7:0]  uart_rx_data;
  wire        uart_rx_done;
  wire        uart_rxd;
  wire        uart_txd;
  wire        dbg_tck;
  wire        dbg_if_select;
  wire        dbg_if_tdo;
  wire        jtag_tap_tdo;
  wire        jtag_tap_shift_dr;
  wire        jtag_tap_pause_dr;
  wire        jtag_tap_update_dr;
  wire        jtag_tap_capture_dr;

  orpsoc soc_i (
    .sys_clk_i(sys_clk_i),
    .sys_rst_i(sys_rst_i),
    .uart0_srx_pad_i(uart_rxd),
    .uart0_stx_pad_o(uart_txd),
    .dbg_tck_i(dbg_tck),
    .dbg_if_select_i(dbg_if_select),
    .dbg_if_tdo_o(dbg_if_tdo),
    .jtag_tap_tdo_i(jtag_tap_tdo),
    .jtag_tap_shift_dr_i(jtag_tap_shift_dr),
    .jtag_tap_pause_dr_i(jtag_tap_pause_dr),
    .jtag_tap_update_dr_i(jtag_tap_update_dr),
    .jtag_tap_capture_dr_i(jtag_tap_capture_dr)
  );

  tap_top jtag_tap0 (
    .tdo_pad_o(tdo_pad_o),
    .tms_pad_i(tms_pad_i),
    .tck_pad_i(dbg_tck),
    .trst_pad_i(sys_rst_i),
    .tdi_pad_i(tdi_pad_i),
    .tdo_padoe_o(tdo_padoe_o),
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

     /* TODO(bluecmd): Remove magic number */
    .divisor(16'd26),

    .rx_data(uart_rx_data),
    .rx_done(uart_rx_done),
    .tx_data(8'h00),
    .tx_wr(1'b0),
    .tx_done(),
    .rx_break()
  );

  always @(posedge sys_clk_i)
  begin
    if (uart_rx_done)
      $write("%c", uart_rx_data);
  end

  initial
  begin
    $display("Mexiko Testbench started");
  end

endmodule
