
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
  // We want to use a quarter the BPI Flash (which is 512 Mbit)
  // 512*1024^2 / 4 / 16 bit = 8388608 (16 MiB)
  parameter BPI_SIZE = 8388608;

  reg [15:0]  g18_mem [BPI_SIZE:0];

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

  reg  [15:0] g18_dat_r;
  wire [15:0] g18_dat;
  wire [22:0] g18_adr;
  wire        g18_wen;

  wire [3:0]  gic_m2s_dat;
  wire [3:0]  gic_s2m_dat;
  wire        gic_cs;

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
    .g18_dat_io           (g18_dat),
    .g18_adr_o            (g18_adr),
    .g18_wen_o            (g18_wen),
    .gic_dat_i            (gic_s2m_dat),
    .gic_dat_o            (gic_m2s_dat),
    .gic_cs_o             (gic_cs)
  );

  assign g18_dat = g18_wen ? g18_dat_r : {16{1'bz}};

  kuba kuba_i (
    .sys_clk_i   (sys_clk_i),
    .sys_rst_i   (sys_rst_i),
    .gic_dat_i   (gic_m2s_dat),
    .gic_dat_o   (gic_s2m_dat),
    .eth0_tx_clk (sys_clk_i),
    .eth0_rx_clk (sys_clk_i),
    .eth0_rx_data(4'b0),
    .eth0_dv     (1'b0),
    .eth0_rx_er  (1'b0),
    .eth0_col    (1'b0),
    .eth0_crs    (1'b0)
  );

  tap_top jtag_tap_i (
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

  dpi_uart uart_i (
    .rst_i(sys_rst_i),
    .clk_i(sys_clk_i),
    .uart_rx_i(uart_txd),
    .uart_tx_o(uart_rxd),
    .divisor_i(UART_DIVISOR)
  );

  always @(posedge sys_clk_i)
  begin
    g18_dat_r <= g18_mem[g18_adr];
  end

  initial
  begin
    $display("Mexiko Testbench started");
    $readmemh("../../src/mexiko.memh", g18_mem);
    $display("Boot ROM: %04x%04x", g18_mem[23'h0], g18_mem[23'h1]);
    $display("Diag ROM: %04x%04x", g18_mem[23'h400000], g18_mem[23'h400001]);
  end

endmodule
