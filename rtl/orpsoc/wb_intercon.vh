wire [31:0] wb_m2s_or1k_i_adr;
wire [31:0] wb_m2s_or1k_i_dat;
wire  [3:0] wb_m2s_or1k_i_sel;
wire        wb_m2s_or1k_i_we;
wire        wb_m2s_or1k_i_cyc;
wire        wb_m2s_or1k_i_stb;
wire  [2:0] wb_m2s_or1k_i_cti;
wire  [1:0] wb_m2s_or1k_i_bte;
wire [31:0] wb_s2m_or1k_i_dat;
wire        wb_s2m_or1k_i_ack;
wire        wb_s2m_or1k_i_err;
wire        wb_s2m_or1k_i_rty;
wire [31:0] wb_m2s_or1k_d_adr;
wire [31:0] wb_m2s_or1k_d_dat;
wire  [3:0] wb_m2s_or1k_d_sel;
wire        wb_m2s_or1k_d_we;
wire        wb_m2s_or1k_d_cyc;
wire        wb_m2s_or1k_d_stb;
wire  [2:0] wb_m2s_or1k_d_cti;
wire  [1:0] wb_m2s_or1k_d_bte;
wire [31:0] wb_s2m_or1k_d_dat;
wire        wb_s2m_or1k_d_ack;
wire        wb_s2m_or1k_d_err;
wire        wb_s2m_or1k_d_rty;
wire [31:0] wb_m2s_dbg_adr;
wire [31:0] wb_m2s_dbg_dat;
wire  [3:0] wb_m2s_dbg_sel;
wire        wb_m2s_dbg_we;
wire        wb_m2s_dbg_cyc;
wire        wb_m2s_dbg_stb;
wire  [2:0] wb_m2s_dbg_cti;
wire  [1:0] wb_m2s_dbg_bte;
wire [31:0] wb_s2m_dbg_dat;
wire        wb_s2m_dbg_ack;
wire        wb_s2m_dbg_err;
wire        wb_s2m_dbg_rty;
wire [31:0] wb_m2s_uart0_adr;
wire  [7:0] wb_m2s_uart0_dat;
wire  [3:0] wb_m2s_uart0_sel;
wire        wb_m2s_uart0_we;
wire        wb_m2s_uart0_cyc;
wire        wb_m2s_uart0_stb;
wire  [2:0] wb_m2s_uart0_cti;
wire  [1:0] wb_m2s_uart0_bte;
wire  [7:0] wb_s2m_uart0_dat;
wire        wb_s2m_uart0_ack;
wire        wb_s2m_uart0_err;
wire        wb_s2m_uart0_rty;
wire [31:0] wb_m2s_rom0_adr;
wire [31:0] wb_m2s_rom0_dat;
wire  [3:0] wb_m2s_rom0_sel;
wire        wb_m2s_rom0_we;
wire        wb_m2s_rom0_cyc;
wire        wb_m2s_rom0_stb;
wire  [2:0] wb_m2s_rom0_cti;
wire  [1:0] wb_m2s_rom0_bte;
wire [31:0] wb_s2m_rom0_dat;
wire        wb_s2m_rom0_ack;
wire        wb_s2m_rom0_err;
wire        wb_s2m_rom0_rty;

wb_intercon wb_intercon0
   (.wb_clk_i        (wb_clk),
    .wb_rst_i        (wb_rst),
    .wb_or1k_i_adr_i (wb_m2s_or1k_i_adr),
    .wb_or1k_i_dat_i (wb_m2s_or1k_i_dat),
    .wb_or1k_i_sel_i (wb_m2s_or1k_i_sel),
    .wb_or1k_i_we_i  (wb_m2s_or1k_i_we),
    .wb_or1k_i_cyc_i (wb_m2s_or1k_i_cyc),
    .wb_or1k_i_stb_i (wb_m2s_or1k_i_stb),
    .wb_or1k_i_cti_i (wb_m2s_or1k_i_cti),
    .wb_or1k_i_bte_i (wb_m2s_or1k_i_bte),
    .wb_or1k_i_dat_o (wb_s2m_or1k_i_dat),
    .wb_or1k_i_ack_o (wb_s2m_or1k_i_ack),
    .wb_or1k_i_err_o (wb_s2m_or1k_i_err),
    .wb_or1k_i_rty_o (wb_s2m_or1k_i_rty),
    .wb_or1k_d_adr_i (wb_m2s_or1k_d_adr),
    .wb_or1k_d_dat_i (wb_m2s_or1k_d_dat),
    .wb_or1k_d_sel_i (wb_m2s_or1k_d_sel),
    .wb_or1k_d_we_i  (wb_m2s_or1k_d_we),
    .wb_or1k_d_cyc_i (wb_m2s_or1k_d_cyc),
    .wb_or1k_d_stb_i (wb_m2s_or1k_d_stb),
    .wb_or1k_d_cti_i (wb_m2s_or1k_d_cti),
    .wb_or1k_d_bte_i (wb_m2s_or1k_d_bte),
    .wb_or1k_d_dat_o (wb_s2m_or1k_d_dat),
    .wb_or1k_d_ack_o (wb_s2m_or1k_d_ack),
    .wb_or1k_d_err_o (wb_s2m_or1k_d_err),
    .wb_or1k_d_rty_o (wb_s2m_or1k_d_rty),
    .wb_dbg_adr_i    (wb_m2s_dbg_adr),
    .wb_dbg_dat_i    (wb_m2s_dbg_dat),
    .wb_dbg_sel_i    (wb_m2s_dbg_sel),
    .wb_dbg_we_i     (wb_m2s_dbg_we),
    .wb_dbg_cyc_i    (wb_m2s_dbg_cyc),
    .wb_dbg_stb_i    (wb_m2s_dbg_stb),
    .wb_dbg_cti_i    (wb_m2s_dbg_cti),
    .wb_dbg_bte_i    (wb_m2s_dbg_bte),
    .wb_dbg_dat_o    (wb_s2m_dbg_dat),
    .wb_dbg_ack_o    (wb_s2m_dbg_ack),
    .wb_dbg_err_o    (wb_s2m_dbg_err),
    .wb_dbg_rty_o    (wb_s2m_dbg_rty),
    .wb_uart0_adr_o  (wb_m2s_uart0_adr),
    .wb_uart0_dat_o  (wb_m2s_uart0_dat),
    .wb_uart0_sel_o  (wb_m2s_uart0_sel),
    .wb_uart0_we_o   (wb_m2s_uart0_we),
    .wb_uart0_cyc_o  (wb_m2s_uart0_cyc),
    .wb_uart0_stb_o  (wb_m2s_uart0_stb),
    .wb_uart0_cti_o  (wb_m2s_uart0_cti),
    .wb_uart0_bte_o  (wb_m2s_uart0_bte),
    .wb_uart0_dat_i  (wb_s2m_uart0_dat),
    .wb_uart0_ack_i  (wb_s2m_uart0_ack),
    .wb_uart0_err_i  (wb_s2m_uart0_err),
    .wb_uart0_rty_i  (wb_s2m_uart0_rty),
    .wb_rom0_adr_o   (wb_m2s_rom0_adr),
    .wb_rom0_dat_o   (wb_m2s_rom0_dat),
    .wb_rom0_sel_o   (wb_m2s_rom0_sel),
    .wb_rom0_we_o    (wb_m2s_rom0_we),
    .wb_rom0_cyc_o   (wb_m2s_rom0_cyc),
    .wb_rom0_stb_o   (wb_m2s_rom0_stb),
    .wb_rom0_cti_o   (wb_m2s_rom0_cti),
    .wb_rom0_bte_o   (wb_m2s_rom0_bte),
    .wb_rom0_dat_i   (wb_s2m_rom0_dat),
    .wb_rom0_ack_i   (wb_s2m_rom0_ack),
    .wb_rom0_err_i   (wb_s2m_rom0_err),
    .wb_rom0_rty_i   (wb_s2m_rom0_rty));

