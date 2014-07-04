module wb_intercon
   (input         wb_clk_i,
    input         wb_rst_i,
    input  [31:0] wb_or1k_i_adr_i,
    input  [31:0] wb_or1k_i_dat_i,
    input   [3:0] wb_or1k_i_sel_i,
    input         wb_or1k_i_we_i,
    input         wb_or1k_i_cyc_i,
    input         wb_or1k_i_stb_i,
    input   [2:0] wb_or1k_i_cti_i,
    input   [1:0] wb_or1k_i_bte_i,
    output [31:0] wb_or1k_i_dat_o,
    output        wb_or1k_i_ack_o,
    output        wb_or1k_i_err_o,
    output        wb_or1k_i_rty_o,
    input  [31:0] wb_or1k_d_adr_i,
    input  [31:0] wb_or1k_d_dat_i,
    input   [3:0] wb_or1k_d_sel_i,
    input         wb_or1k_d_we_i,
    input         wb_or1k_d_cyc_i,
    input         wb_or1k_d_stb_i,
    input   [2:0] wb_or1k_d_cti_i,
    input   [1:0] wb_or1k_d_bte_i,
    output [31:0] wb_or1k_d_dat_o,
    output        wb_or1k_d_ack_o,
    output        wb_or1k_d_err_o,
    output        wb_or1k_d_rty_o,
    input  [31:0] wb_dbg_adr_i,
    input  [31:0] wb_dbg_dat_i,
    input   [3:0] wb_dbg_sel_i,
    input         wb_dbg_we_i,
    input         wb_dbg_cyc_i,
    input         wb_dbg_stb_i,
    input   [2:0] wb_dbg_cti_i,
    input   [1:0] wb_dbg_bte_i,
    output [31:0] wb_dbg_dat_o,
    output        wb_dbg_ack_o,
    output        wb_dbg_err_o,
    output        wb_dbg_rty_o,
    output [31:0] wb_qsfp_i2c0_adr_o,
    output  [7:0] wb_qsfp_i2c0_dat_o,
    output  [3:0] wb_qsfp_i2c0_sel_o,
    output        wb_qsfp_i2c0_we_o,
    output        wb_qsfp_i2c0_cyc_o,
    output        wb_qsfp_i2c0_stb_o,
    output  [2:0] wb_qsfp_i2c0_cti_o,
    output  [1:0] wb_qsfp_i2c0_bte_o,
    input   [7:0] wb_qsfp_i2c0_dat_i,
    input         wb_qsfp_i2c0_ack_i,
    input         wb_qsfp_i2c0_err_i,
    input         wb_qsfp_i2c0_rty_i,
    output [31:0] wb_qsfp_i2c1_adr_o,
    output  [7:0] wb_qsfp_i2c1_dat_o,
    output  [3:0] wb_qsfp_i2c1_sel_o,
    output        wb_qsfp_i2c1_we_o,
    output        wb_qsfp_i2c1_cyc_o,
    output        wb_qsfp_i2c1_stb_o,
    output  [2:0] wb_qsfp_i2c1_cti_o,
    output  [1:0] wb_qsfp_i2c1_bte_o,
    input   [7:0] wb_qsfp_i2c1_dat_i,
    input         wb_qsfp_i2c1_ack_i,
    input         wb_qsfp_i2c1_err_i,
    input         wb_qsfp_i2c1_rty_i,
    output [31:0] wb_rom0_adr_o,
    output [31:0] wb_rom0_dat_o,
    output  [3:0] wb_rom0_sel_o,
    output        wb_rom0_we_o,
    output        wb_rom0_cyc_o,
    output        wb_rom0_stb_o,
    output  [2:0] wb_rom0_cti_o,
    output  [1:0] wb_rom0_bte_o,
    input  [31:0] wb_rom0_dat_i,
    input         wb_rom0_ack_i,
    input         wb_rom0_err_i,
    input         wb_rom0_rty_i,
    output [31:0] wb_sysram_adr_o,
    output [31:0] wb_sysram_dat_o,
    output  [3:0] wb_sysram_sel_o,
    output        wb_sysram_we_o,
    output        wb_sysram_cyc_o,
    output        wb_sysram_stb_o,
    output  [2:0] wb_sysram_cti_o,
    output  [1:0] wb_sysram_bte_o,
    input  [31:0] wb_sysram_dat_i,
    input         wb_sysram_ack_i,
    input         wb_sysram_err_i,
    input         wb_sysram_rty_i,
    output [31:0] wb_uart0_adr_o,
    output  [7:0] wb_uart0_dat_o,
    output  [3:0] wb_uart0_sel_o,
    output        wb_uart0_we_o,
    output        wb_uart0_cyc_o,
    output        wb_uart0_stb_o,
    output  [2:0] wb_uart0_cti_o,
    output  [1:0] wb_uart0_bte_o,
    input   [7:0] wb_uart0_dat_i,
    input         wb_uart0_ack_i,
    input         wb_uart0_err_i,
    input         wb_uart0_rty_i,
    output [31:0] wb_bpi0_adr_o,
    output [31:0] wb_bpi0_dat_o,
    output  [3:0] wb_bpi0_sel_o,
    output        wb_bpi0_we_o,
    output        wb_bpi0_cyc_o,
    output        wb_bpi0_stb_o,
    output  [2:0] wb_bpi0_cti_o,
    output  [1:0] wb_bpi0_bte_o,
    input  [31:0] wb_bpi0_dat_i,
    input         wb_bpi0_ack_i,
    input         wb_bpi0_err_i,
    input         wb_bpi0_rty_i);

wire [31:0] wb_m2s_or1k_i_rom0_adr;
wire [31:0] wb_m2s_or1k_i_rom0_dat;
wire  [3:0] wb_m2s_or1k_i_rom0_sel;
wire        wb_m2s_or1k_i_rom0_we;
wire        wb_m2s_or1k_i_rom0_cyc;
wire        wb_m2s_or1k_i_rom0_stb;
wire  [2:0] wb_m2s_or1k_i_rom0_cti;
wire  [1:0] wb_m2s_or1k_i_rom0_bte;
wire [31:0] wb_s2m_or1k_i_rom0_dat;
wire        wb_s2m_or1k_i_rom0_ack;
wire        wb_s2m_or1k_i_rom0_err;
wire        wb_s2m_or1k_i_rom0_rty;
wire [31:0] wb_m2s_or1k_i_sysram_adr;
wire [31:0] wb_m2s_or1k_i_sysram_dat;
wire  [3:0] wb_m2s_or1k_i_sysram_sel;
wire        wb_m2s_or1k_i_sysram_we;
wire        wb_m2s_or1k_i_sysram_cyc;
wire        wb_m2s_or1k_i_sysram_stb;
wire  [2:0] wb_m2s_or1k_i_sysram_cti;
wire  [1:0] wb_m2s_or1k_i_sysram_bte;
wire [31:0] wb_s2m_or1k_i_sysram_dat;
wire        wb_s2m_or1k_i_sysram_ack;
wire        wb_s2m_or1k_i_sysram_err;
wire        wb_s2m_or1k_i_sysram_rty;
wire [31:0] wb_m2s_or1k_d_rom0_adr;
wire [31:0] wb_m2s_or1k_d_rom0_dat;
wire  [3:0] wb_m2s_or1k_d_rom0_sel;
wire        wb_m2s_or1k_d_rom0_we;
wire        wb_m2s_or1k_d_rom0_cyc;
wire        wb_m2s_or1k_d_rom0_stb;
wire  [2:0] wb_m2s_or1k_d_rom0_cti;
wire  [1:0] wb_m2s_or1k_d_rom0_bte;
wire [31:0] wb_s2m_or1k_d_rom0_dat;
wire        wb_s2m_or1k_d_rom0_ack;
wire        wb_s2m_or1k_d_rom0_err;
wire        wb_s2m_or1k_d_rom0_rty;
wire [31:0] wb_m2s_or1k_d_bpi0_adr;
wire [31:0] wb_m2s_or1k_d_bpi0_dat;
wire  [3:0] wb_m2s_or1k_d_bpi0_sel;
wire        wb_m2s_or1k_d_bpi0_we;
wire        wb_m2s_or1k_d_bpi0_cyc;
wire        wb_m2s_or1k_d_bpi0_stb;
wire  [2:0] wb_m2s_or1k_d_bpi0_cti;
wire  [1:0] wb_m2s_or1k_d_bpi0_bte;
wire [31:0] wb_s2m_or1k_d_bpi0_dat;
wire        wb_s2m_or1k_d_bpi0_ack;
wire        wb_s2m_or1k_d_bpi0_err;
wire        wb_s2m_or1k_d_bpi0_rty;
wire [31:0] wb_m2s_or1k_d_uart0_adr;
wire [31:0] wb_m2s_or1k_d_uart0_dat;
wire  [3:0] wb_m2s_or1k_d_uart0_sel;
wire        wb_m2s_or1k_d_uart0_we;
wire        wb_m2s_or1k_d_uart0_cyc;
wire        wb_m2s_or1k_d_uart0_stb;
wire  [2:0] wb_m2s_or1k_d_uart0_cti;
wire  [1:0] wb_m2s_or1k_d_uart0_bte;
wire [31:0] wb_s2m_or1k_d_uart0_dat;
wire        wb_s2m_or1k_d_uart0_ack;
wire        wb_s2m_or1k_d_uart0_err;
wire        wb_s2m_or1k_d_uart0_rty;
wire [31:0] wb_m2s_or1k_d_sysram_adr;
wire [31:0] wb_m2s_or1k_d_sysram_dat;
wire  [3:0] wb_m2s_or1k_d_sysram_sel;
wire        wb_m2s_or1k_d_sysram_we;
wire        wb_m2s_or1k_d_sysram_cyc;
wire        wb_m2s_or1k_d_sysram_stb;
wire  [2:0] wb_m2s_or1k_d_sysram_cti;
wire  [1:0] wb_m2s_or1k_d_sysram_bte;
wire [31:0] wb_s2m_or1k_d_sysram_dat;
wire        wb_s2m_or1k_d_sysram_ack;
wire        wb_s2m_or1k_d_sysram_err;
wire        wb_s2m_or1k_d_sysram_rty;
wire [31:0] wb_m2s_or1k_d_qsfp_i2c0_adr;
wire [31:0] wb_m2s_or1k_d_qsfp_i2c0_dat;
wire  [3:0] wb_m2s_or1k_d_qsfp_i2c0_sel;
wire        wb_m2s_or1k_d_qsfp_i2c0_we;
wire        wb_m2s_or1k_d_qsfp_i2c0_cyc;
wire        wb_m2s_or1k_d_qsfp_i2c0_stb;
wire  [2:0] wb_m2s_or1k_d_qsfp_i2c0_cti;
wire  [1:0] wb_m2s_or1k_d_qsfp_i2c0_bte;
wire [31:0] wb_s2m_or1k_d_qsfp_i2c0_dat;
wire        wb_s2m_or1k_d_qsfp_i2c0_ack;
wire        wb_s2m_or1k_d_qsfp_i2c0_err;
wire        wb_s2m_or1k_d_qsfp_i2c0_rty;
wire [31:0] wb_m2s_or1k_d_qsfp_i2c1_adr;
wire [31:0] wb_m2s_or1k_d_qsfp_i2c1_dat;
wire  [3:0] wb_m2s_or1k_d_qsfp_i2c1_sel;
wire        wb_m2s_or1k_d_qsfp_i2c1_we;
wire        wb_m2s_or1k_d_qsfp_i2c1_cyc;
wire        wb_m2s_or1k_d_qsfp_i2c1_stb;
wire  [2:0] wb_m2s_or1k_d_qsfp_i2c1_cti;
wire  [1:0] wb_m2s_or1k_d_qsfp_i2c1_bte;
wire [31:0] wb_s2m_or1k_d_qsfp_i2c1_dat;
wire        wb_s2m_or1k_d_qsfp_i2c1_ack;
wire        wb_s2m_or1k_d_qsfp_i2c1_err;
wire        wb_s2m_or1k_d_qsfp_i2c1_rty;
wire [31:0] wb_m2s_dbg_rom0_adr;
wire [31:0] wb_m2s_dbg_rom0_dat;
wire  [3:0] wb_m2s_dbg_rom0_sel;
wire        wb_m2s_dbg_rom0_we;
wire        wb_m2s_dbg_rom0_cyc;
wire        wb_m2s_dbg_rom0_stb;
wire  [2:0] wb_m2s_dbg_rom0_cti;
wire  [1:0] wb_m2s_dbg_rom0_bte;
wire [31:0] wb_s2m_dbg_rom0_dat;
wire        wb_s2m_dbg_rom0_ack;
wire        wb_s2m_dbg_rom0_err;
wire        wb_s2m_dbg_rom0_rty;
wire [31:0] wb_m2s_dbg_bpi0_adr;
wire [31:0] wb_m2s_dbg_bpi0_dat;
wire  [3:0] wb_m2s_dbg_bpi0_sel;
wire        wb_m2s_dbg_bpi0_we;
wire        wb_m2s_dbg_bpi0_cyc;
wire        wb_m2s_dbg_bpi0_stb;
wire  [2:0] wb_m2s_dbg_bpi0_cti;
wire  [1:0] wb_m2s_dbg_bpi0_bte;
wire [31:0] wb_s2m_dbg_bpi0_dat;
wire        wb_s2m_dbg_bpi0_ack;
wire        wb_s2m_dbg_bpi0_err;
wire        wb_s2m_dbg_bpi0_rty;
wire [31:0] wb_m2s_dbg_uart0_adr;
wire [31:0] wb_m2s_dbg_uart0_dat;
wire  [3:0] wb_m2s_dbg_uart0_sel;
wire        wb_m2s_dbg_uart0_we;
wire        wb_m2s_dbg_uart0_cyc;
wire        wb_m2s_dbg_uart0_stb;
wire  [2:0] wb_m2s_dbg_uart0_cti;
wire  [1:0] wb_m2s_dbg_uart0_bte;
wire [31:0] wb_s2m_dbg_uart0_dat;
wire        wb_s2m_dbg_uart0_ack;
wire        wb_s2m_dbg_uart0_err;
wire        wb_s2m_dbg_uart0_rty;
wire [31:0] wb_m2s_dbg_sysram_adr;
wire [31:0] wb_m2s_dbg_sysram_dat;
wire  [3:0] wb_m2s_dbg_sysram_sel;
wire        wb_m2s_dbg_sysram_we;
wire        wb_m2s_dbg_sysram_cyc;
wire        wb_m2s_dbg_sysram_stb;
wire  [2:0] wb_m2s_dbg_sysram_cti;
wire  [1:0] wb_m2s_dbg_sysram_bte;
wire [31:0] wb_s2m_dbg_sysram_dat;
wire        wb_s2m_dbg_sysram_ack;
wire        wb_s2m_dbg_sysram_err;
wire        wb_s2m_dbg_sysram_rty;
wire [31:0] wb_m2s_dbg_qsfp_i2c0_adr;
wire [31:0] wb_m2s_dbg_qsfp_i2c0_dat;
wire  [3:0] wb_m2s_dbg_qsfp_i2c0_sel;
wire        wb_m2s_dbg_qsfp_i2c0_we;
wire        wb_m2s_dbg_qsfp_i2c0_cyc;
wire        wb_m2s_dbg_qsfp_i2c0_stb;
wire  [2:0] wb_m2s_dbg_qsfp_i2c0_cti;
wire  [1:0] wb_m2s_dbg_qsfp_i2c0_bte;
wire [31:0] wb_s2m_dbg_qsfp_i2c0_dat;
wire        wb_s2m_dbg_qsfp_i2c0_ack;
wire        wb_s2m_dbg_qsfp_i2c0_err;
wire        wb_s2m_dbg_qsfp_i2c0_rty;
wire [31:0] wb_m2s_dbg_qsfp_i2c1_adr;
wire [31:0] wb_m2s_dbg_qsfp_i2c1_dat;
wire  [3:0] wb_m2s_dbg_qsfp_i2c1_sel;
wire        wb_m2s_dbg_qsfp_i2c1_we;
wire        wb_m2s_dbg_qsfp_i2c1_cyc;
wire        wb_m2s_dbg_qsfp_i2c1_stb;
wire  [2:0] wb_m2s_dbg_qsfp_i2c1_cti;
wire  [1:0] wb_m2s_dbg_qsfp_i2c1_bte;
wire [31:0] wb_s2m_dbg_qsfp_i2c1_dat;
wire        wb_s2m_dbg_qsfp_i2c1_ack;
wire        wb_s2m_dbg_qsfp_i2c1_err;
wire        wb_s2m_dbg_qsfp_i2c1_rty;
wire [31:0] wb_m2s_resize_qsfp_i2c0_adr;
wire [31:0] wb_m2s_resize_qsfp_i2c0_dat;
wire  [3:0] wb_m2s_resize_qsfp_i2c0_sel;
wire        wb_m2s_resize_qsfp_i2c0_we;
wire        wb_m2s_resize_qsfp_i2c0_cyc;
wire        wb_m2s_resize_qsfp_i2c0_stb;
wire  [2:0] wb_m2s_resize_qsfp_i2c0_cti;
wire  [1:0] wb_m2s_resize_qsfp_i2c0_bte;
wire [31:0] wb_s2m_resize_qsfp_i2c0_dat;
wire        wb_s2m_resize_qsfp_i2c0_ack;
wire        wb_s2m_resize_qsfp_i2c0_err;
wire        wb_s2m_resize_qsfp_i2c0_rty;
wire [31:0] wb_m2s_resize_qsfp_i2c1_adr;
wire [31:0] wb_m2s_resize_qsfp_i2c1_dat;
wire  [3:0] wb_m2s_resize_qsfp_i2c1_sel;
wire        wb_m2s_resize_qsfp_i2c1_we;
wire        wb_m2s_resize_qsfp_i2c1_cyc;
wire        wb_m2s_resize_qsfp_i2c1_stb;
wire  [2:0] wb_m2s_resize_qsfp_i2c1_cti;
wire  [1:0] wb_m2s_resize_qsfp_i2c1_bte;
wire [31:0] wb_s2m_resize_qsfp_i2c1_dat;
wire        wb_s2m_resize_qsfp_i2c1_ack;
wire        wb_s2m_resize_qsfp_i2c1_err;
wire        wb_s2m_resize_qsfp_i2c1_rty;
wire [31:0] wb_m2s_resize_uart0_adr;
wire [31:0] wb_m2s_resize_uart0_dat;
wire  [3:0] wb_m2s_resize_uart0_sel;
wire        wb_m2s_resize_uart0_we;
wire        wb_m2s_resize_uart0_cyc;
wire        wb_m2s_resize_uart0_stb;
wire  [2:0] wb_m2s_resize_uart0_cti;
wire  [1:0] wb_m2s_resize_uart0_bte;
wire [31:0] wb_s2m_resize_uart0_dat;
wire        wb_s2m_resize_uart0_ack;
wire        wb_s2m_resize_uart0_err;
wire        wb_s2m_resize_uart0_rty;

wb_mux
  #(.num_slaves (2),
    .MATCH_ADDR ({32'hf0000000, 32'h00000000}),
    .MATCH_MASK ({32'hfffff000, 32'hfffc0000}))
 wb_mux_or1k_i
   (.wb_clk_i  (wb_clk_i),
    .wb_rst_i  (wb_rst_i),
    .wbm_adr_i (wb_or1k_i_adr_i),
    .wbm_dat_i (wb_or1k_i_dat_i),
    .wbm_sel_i (wb_or1k_i_sel_i),
    .wbm_we_i  (wb_or1k_i_we_i),
    .wbm_cyc_i (wb_or1k_i_cyc_i),
    .wbm_stb_i (wb_or1k_i_stb_i),
    .wbm_cti_i (wb_or1k_i_cti_i),
    .wbm_bte_i (wb_or1k_i_bte_i),
    .wbm_dat_o (wb_or1k_i_dat_o),
    .wbm_ack_o (wb_or1k_i_ack_o),
    .wbm_err_o (wb_or1k_i_err_o),
    .wbm_rty_o (wb_or1k_i_rty_o),
    .wbs_adr_o ({wb_m2s_or1k_i_rom0_adr, wb_m2s_or1k_i_sysram_adr}),
    .wbs_dat_o ({wb_m2s_or1k_i_rom0_dat, wb_m2s_or1k_i_sysram_dat}),
    .wbs_sel_o ({wb_m2s_or1k_i_rom0_sel, wb_m2s_or1k_i_sysram_sel}),
    .wbs_we_o  ({wb_m2s_or1k_i_rom0_we, wb_m2s_or1k_i_sysram_we}),
    .wbs_cyc_o ({wb_m2s_or1k_i_rom0_cyc, wb_m2s_or1k_i_sysram_cyc}),
    .wbs_stb_o ({wb_m2s_or1k_i_rom0_stb, wb_m2s_or1k_i_sysram_stb}),
    .wbs_cti_o ({wb_m2s_or1k_i_rom0_cti, wb_m2s_or1k_i_sysram_cti}),
    .wbs_bte_o ({wb_m2s_or1k_i_rom0_bte, wb_m2s_or1k_i_sysram_bte}),
    .wbs_dat_i ({wb_s2m_or1k_i_rom0_dat, wb_s2m_or1k_i_sysram_dat}),
    .wbs_ack_i ({wb_s2m_or1k_i_rom0_ack, wb_s2m_or1k_i_sysram_ack}),
    .wbs_err_i ({wb_s2m_or1k_i_rom0_err, wb_s2m_or1k_i_sysram_err}),
    .wbs_rty_i ({wb_s2m_or1k_i_rom0_rty, wb_s2m_or1k_i_sysram_rty}));

wb_mux
  #(.num_slaves (6),
    .MATCH_ADDR ({32'hf0000000, 32'hee000000, 32'h90000000, 32'h00000000, 32'he0000000, 32'he0010000}),
    .MATCH_MASK ({32'hfffff000, 32'hfe000000, 32'hffffffe0, 32'hfffc0000, 32'hfffffff8, 32'hfffffff8}))
 wb_mux_or1k_d
   (.wb_clk_i  (wb_clk_i),
    .wb_rst_i  (wb_rst_i),
    .wbm_adr_i (wb_or1k_d_adr_i),
    .wbm_dat_i (wb_or1k_d_dat_i),
    .wbm_sel_i (wb_or1k_d_sel_i),
    .wbm_we_i  (wb_or1k_d_we_i),
    .wbm_cyc_i (wb_or1k_d_cyc_i),
    .wbm_stb_i (wb_or1k_d_stb_i),
    .wbm_cti_i (wb_or1k_d_cti_i),
    .wbm_bte_i (wb_or1k_d_bte_i),
    .wbm_dat_o (wb_or1k_d_dat_o),
    .wbm_ack_o (wb_or1k_d_ack_o),
    .wbm_err_o (wb_or1k_d_err_o),
    .wbm_rty_o (wb_or1k_d_rty_o),
    .wbs_adr_o ({wb_m2s_or1k_d_rom0_adr, wb_m2s_or1k_d_bpi0_adr, wb_m2s_or1k_d_uart0_adr, wb_m2s_or1k_d_sysram_adr, wb_m2s_or1k_d_qsfp_i2c0_adr, wb_m2s_or1k_d_qsfp_i2c1_adr}),
    .wbs_dat_o ({wb_m2s_or1k_d_rom0_dat, wb_m2s_or1k_d_bpi0_dat, wb_m2s_or1k_d_uart0_dat, wb_m2s_or1k_d_sysram_dat, wb_m2s_or1k_d_qsfp_i2c0_dat, wb_m2s_or1k_d_qsfp_i2c1_dat}),
    .wbs_sel_o ({wb_m2s_or1k_d_rom0_sel, wb_m2s_or1k_d_bpi0_sel, wb_m2s_or1k_d_uart0_sel, wb_m2s_or1k_d_sysram_sel, wb_m2s_or1k_d_qsfp_i2c0_sel, wb_m2s_or1k_d_qsfp_i2c1_sel}),
    .wbs_we_o  ({wb_m2s_or1k_d_rom0_we, wb_m2s_or1k_d_bpi0_we, wb_m2s_or1k_d_uart0_we, wb_m2s_or1k_d_sysram_we, wb_m2s_or1k_d_qsfp_i2c0_we, wb_m2s_or1k_d_qsfp_i2c1_we}),
    .wbs_cyc_o ({wb_m2s_or1k_d_rom0_cyc, wb_m2s_or1k_d_bpi0_cyc, wb_m2s_or1k_d_uart0_cyc, wb_m2s_or1k_d_sysram_cyc, wb_m2s_or1k_d_qsfp_i2c0_cyc, wb_m2s_or1k_d_qsfp_i2c1_cyc}),
    .wbs_stb_o ({wb_m2s_or1k_d_rom0_stb, wb_m2s_or1k_d_bpi0_stb, wb_m2s_or1k_d_uart0_stb, wb_m2s_or1k_d_sysram_stb, wb_m2s_or1k_d_qsfp_i2c0_stb, wb_m2s_or1k_d_qsfp_i2c1_stb}),
    .wbs_cti_o ({wb_m2s_or1k_d_rom0_cti, wb_m2s_or1k_d_bpi0_cti, wb_m2s_or1k_d_uart0_cti, wb_m2s_or1k_d_sysram_cti, wb_m2s_or1k_d_qsfp_i2c0_cti, wb_m2s_or1k_d_qsfp_i2c1_cti}),
    .wbs_bte_o ({wb_m2s_or1k_d_rom0_bte, wb_m2s_or1k_d_bpi0_bte, wb_m2s_or1k_d_uart0_bte, wb_m2s_or1k_d_sysram_bte, wb_m2s_or1k_d_qsfp_i2c0_bte, wb_m2s_or1k_d_qsfp_i2c1_bte}),
    .wbs_dat_i ({wb_s2m_or1k_d_rom0_dat, wb_s2m_or1k_d_bpi0_dat, wb_s2m_or1k_d_uart0_dat, wb_s2m_or1k_d_sysram_dat, wb_s2m_or1k_d_qsfp_i2c0_dat, wb_s2m_or1k_d_qsfp_i2c1_dat}),
    .wbs_ack_i ({wb_s2m_or1k_d_rom0_ack, wb_s2m_or1k_d_bpi0_ack, wb_s2m_or1k_d_uart0_ack, wb_s2m_or1k_d_sysram_ack, wb_s2m_or1k_d_qsfp_i2c0_ack, wb_s2m_or1k_d_qsfp_i2c1_ack}),
    .wbs_err_i ({wb_s2m_or1k_d_rom0_err, wb_s2m_or1k_d_bpi0_err, wb_s2m_or1k_d_uart0_err, wb_s2m_or1k_d_sysram_err, wb_s2m_or1k_d_qsfp_i2c0_err, wb_s2m_or1k_d_qsfp_i2c1_err}),
    .wbs_rty_i ({wb_s2m_or1k_d_rom0_rty, wb_s2m_or1k_d_bpi0_rty, wb_s2m_or1k_d_uart0_rty, wb_s2m_or1k_d_sysram_rty, wb_s2m_or1k_d_qsfp_i2c0_rty, wb_s2m_or1k_d_qsfp_i2c1_rty}));

wb_mux
  #(.num_slaves (6),
    .MATCH_ADDR ({32'hf0000000, 32'hee000000, 32'h90000000, 32'h00000000, 32'he0000000, 32'he0010000}),
    .MATCH_MASK ({32'hfffff000, 32'hfe000000, 32'hffffffe0, 32'hfffc0000, 32'hfffffff8, 32'hfffffff8}))
 wb_mux_dbg
   (.wb_clk_i  (wb_clk_i),
    .wb_rst_i  (wb_rst_i),
    .wbm_adr_i (wb_dbg_adr_i),
    .wbm_dat_i (wb_dbg_dat_i),
    .wbm_sel_i (wb_dbg_sel_i),
    .wbm_we_i  (wb_dbg_we_i),
    .wbm_cyc_i (wb_dbg_cyc_i),
    .wbm_stb_i (wb_dbg_stb_i),
    .wbm_cti_i (wb_dbg_cti_i),
    .wbm_bte_i (wb_dbg_bte_i),
    .wbm_dat_o (wb_dbg_dat_o),
    .wbm_ack_o (wb_dbg_ack_o),
    .wbm_err_o (wb_dbg_err_o),
    .wbm_rty_o (wb_dbg_rty_o),
    .wbs_adr_o ({wb_m2s_dbg_rom0_adr, wb_m2s_dbg_bpi0_adr, wb_m2s_dbg_uart0_adr, wb_m2s_dbg_sysram_adr, wb_m2s_dbg_qsfp_i2c0_adr, wb_m2s_dbg_qsfp_i2c1_adr}),
    .wbs_dat_o ({wb_m2s_dbg_rom0_dat, wb_m2s_dbg_bpi0_dat, wb_m2s_dbg_uart0_dat, wb_m2s_dbg_sysram_dat, wb_m2s_dbg_qsfp_i2c0_dat, wb_m2s_dbg_qsfp_i2c1_dat}),
    .wbs_sel_o ({wb_m2s_dbg_rom0_sel, wb_m2s_dbg_bpi0_sel, wb_m2s_dbg_uart0_sel, wb_m2s_dbg_sysram_sel, wb_m2s_dbg_qsfp_i2c0_sel, wb_m2s_dbg_qsfp_i2c1_sel}),
    .wbs_we_o  ({wb_m2s_dbg_rom0_we, wb_m2s_dbg_bpi0_we, wb_m2s_dbg_uart0_we, wb_m2s_dbg_sysram_we, wb_m2s_dbg_qsfp_i2c0_we, wb_m2s_dbg_qsfp_i2c1_we}),
    .wbs_cyc_o ({wb_m2s_dbg_rom0_cyc, wb_m2s_dbg_bpi0_cyc, wb_m2s_dbg_uart0_cyc, wb_m2s_dbg_sysram_cyc, wb_m2s_dbg_qsfp_i2c0_cyc, wb_m2s_dbg_qsfp_i2c1_cyc}),
    .wbs_stb_o ({wb_m2s_dbg_rom0_stb, wb_m2s_dbg_bpi0_stb, wb_m2s_dbg_uart0_stb, wb_m2s_dbg_sysram_stb, wb_m2s_dbg_qsfp_i2c0_stb, wb_m2s_dbg_qsfp_i2c1_stb}),
    .wbs_cti_o ({wb_m2s_dbg_rom0_cti, wb_m2s_dbg_bpi0_cti, wb_m2s_dbg_uart0_cti, wb_m2s_dbg_sysram_cti, wb_m2s_dbg_qsfp_i2c0_cti, wb_m2s_dbg_qsfp_i2c1_cti}),
    .wbs_bte_o ({wb_m2s_dbg_rom0_bte, wb_m2s_dbg_bpi0_bte, wb_m2s_dbg_uart0_bte, wb_m2s_dbg_sysram_bte, wb_m2s_dbg_qsfp_i2c0_bte, wb_m2s_dbg_qsfp_i2c1_bte}),
    .wbs_dat_i ({wb_s2m_dbg_rom0_dat, wb_s2m_dbg_bpi0_dat, wb_s2m_dbg_uart0_dat, wb_s2m_dbg_sysram_dat, wb_s2m_dbg_qsfp_i2c0_dat, wb_s2m_dbg_qsfp_i2c1_dat}),
    .wbs_ack_i ({wb_s2m_dbg_rom0_ack, wb_s2m_dbg_bpi0_ack, wb_s2m_dbg_uart0_ack, wb_s2m_dbg_sysram_ack, wb_s2m_dbg_qsfp_i2c0_ack, wb_s2m_dbg_qsfp_i2c1_ack}),
    .wbs_err_i ({wb_s2m_dbg_rom0_err, wb_s2m_dbg_bpi0_err, wb_s2m_dbg_uart0_err, wb_s2m_dbg_sysram_err, wb_s2m_dbg_qsfp_i2c0_err, wb_s2m_dbg_qsfp_i2c1_err}),
    .wbs_rty_i ({wb_s2m_dbg_rom0_rty, wb_s2m_dbg_bpi0_rty, wb_s2m_dbg_uart0_rty, wb_s2m_dbg_sysram_rty, wb_s2m_dbg_qsfp_i2c0_rty, wb_s2m_dbg_qsfp_i2c1_rty}));

wb_arbiter
  #(.num_masters (2))
 wb_arbiter_qsfp_i2c0
   (.wb_clk_i  (wb_clk_i),
    .wb_rst_i  (wb_rst_i),
    .wbm_adr_i ({wb_m2s_or1k_d_qsfp_i2c0_adr, wb_m2s_dbg_qsfp_i2c0_adr}),
    .wbm_dat_i ({wb_m2s_or1k_d_qsfp_i2c0_dat, wb_m2s_dbg_qsfp_i2c0_dat}),
    .wbm_sel_i ({wb_m2s_or1k_d_qsfp_i2c0_sel, wb_m2s_dbg_qsfp_i2c0_sel}),
    .wbm_we_i  ({wb_m2s_or1k_d_qsfp_i2c0_we, wb_m2s_dbg_qsfp_i2c0_we}),
    .wbm_cyc_i ({wb_m2s_or1k_d_qsfp_i2c0_cyc, wb_m2s_dbg_qsfp_i2c0_cyc}),
    .wbm_stb_i ({wb_m2s_or1k_d_qsfp_i2c0_stb, wb_m2s_dbg_qsfp_i2c0_stb}),
    .wbm_cti_i ({wb_m2s_or1k_d_qsfp_i2c0_cti, wb_m2s_dbg_qsfp_i2c0_cti}),
    .wbm_bte_i ({wb_m2s_or1k_d_qsfp_i2c0_bte, wb_m2s_dbg_qsfp_i2c0_bte}),
    .wbm_dat_o ({wb_s2m_or1k_d_qsfp_i2c0_dat, wb_s2m_dbg_qsfp_i2c0_dat}),
    .wbm_ack_o ({wb_s2m_or1k_d_qsfp_i2c0_ack, wb_s2m_dbg_qsfp_i2c0_ack}),
    .wbm_err_o ({wb_s2m_or1k_d_qsfp_i2c0_err, wb_s2m_dbg_qsfp_i2c0_err}),
    .wbm_rty_o ({wb_s2m_or1k_d_qsfp_i2c0_rty, wb_s2m_dbg_qsfp_i2c0_rty}),
    .wbs_adr_o (wb_m2s_resize_qsfp_i2c0_adr),
    .wbs_dat_o (wb_m2s_resize_qsfp_i2c0_dat),
    .wbs_sel_o (wb_m2s_resize_qsfp_i2c0_sel),
    .wbs_we_o  (wb_m2s_resize_qsfp_i2c0_we),
    .wbs_cyc_o (wb_m2s_resize_qsfp_i2c0_cyc),
    .wbs_stb_o (wb_m2s_resize_qsfp_i2c0_stb),
    .wbs_cti_o (wb_m2s_resize_qsfp_i2c0_cti),
    .wbs_bte_o (wb_m2s_resize_qsfp_i2c0_bte),
    .wbs_dat_i (wb_s2m_resize_qsfp_i2c0_dat),
    .wbs_ack_i (wb_s2m_resize_qsfp_i2c0_ack),
    .wbs_err_i (wb_s2m_resize_qsfp_i2c0_err),
    .wbs_rty_i (wb_s2m_resize_qsfp_i2c0_rty));

wb_data_resize
  #(.aw  (32),
    .mdw (32),
    .sdw (8))
 wb_data_resize_qsfp_i2c0
   (.wbm_adr_i (wb_m2s_resize_qsfp_i2c0_adr),
    .wbm_dat_i (wb_m2s_resize_qsfp_i2c0_dat),
    .wbm_sel_i (wb_m2s_resize_qsfp_i2c0_sel),
    .wbm_we_i  (wb_m2s_resize_qsfp_i2c0_we),
    .wbm_cyc_i (wb_m2s_resize_qsfp_i2c0_cyc),
    .wbm_stb_i (wb_m2s_resize_qsfp_i2c0_stb),
    .wbm_cti_i (wb_m2s_resize_qsfp_i2c0_cti),
    .wbm_bte_i (wb_m2s_resize_qsfp_i2c0_bte),
    .wbm_dat_o (wb_s2m_resize_qsfp_i2c0_dat),
    .wbm_ack_o (wb_s2m_resize_qsfp_i2c0_ack),
    .wbm_err_o (wb_s2m_resize_qsfp_i2c0_err),
    .wbm_rty_o (wb_s2m_resize_qsfp_i2c0_rty),
    .wbs_adr_o (wb_qsfp_i2c0_adr_o),
    .wbs_dat_o (wb_qsfp_i2c0_dat_o),
    .wbs_we_o  (wb_qsfp_i2c0_we_o),
    .wbs_cyc_o (wb_qsfp_i2c0_cyc_o),
    .wbs_stb_o (wb_qsfp_i2c0_stb_o),
    .wbs_cti_o (wb_qsfp_i2c0_cti_o),
    .wbs_bte_o (wb_qsfp_i2c0_bte_o),
    .wbs_dat_i (wb_qsfp_i2c0_dat_i),
    .wbs_ack_i (wb_qsfp_i2c0_ack_i),
    .wbs_err_i (wb_qsfp_i2c0_err_i),
    .wbs_rty_i (wb_qsfp_i2c0_rty_i));

wb_arbiter
  #(.num_masters (2))
 wb_arbiter_qsfp_i2c1
   (.wb_clk_i  (wb_clk_i),
    .wb_rst_i  (wb_rst_i),
    .wbm_adr_i ({wb_m2s_or1k_d_qsfp_i2c1_adr, wb_m2s_dbg_qsfp_i2c1_adr}),
    .wbm_dat_i ({wb_m2s_or1k_d_qsfp_i2c1_dat, wb_m2s_dbg_qsfp_i2c1_dat}),
    .wbm_sel_i ({wb_m2s_or1k_d_qsfp_i2c1_sel, wb_m2s_dbg_qsfp_i2c1_sel}),
    .wbm_we_i  ({wb_m2s_or1k_d_qsfp_i2c1_we, wb_m2s_dbg_qsfp_i2c1_we}),
    .wbm_cyc_i ({wb_m2s_or1k_d_qsfp_i2c1_cyc, wb_m2s_dbg_qsfp_i2c1_cyc}),
    .wbm_stb_i ({wb_m2s_or1k_d_qsfp_i2c1_stb, wb_m2s_dbg_qsfp_i2c1_stb}),
    .wbm_cti_i ({wb_m2s_or1k_d_qsfp_i2c1_cti, wb_m2s_dbg_qsfp_i2c1_cti}),
    .wbm_bte_i ({wb_m2s_or1k_d_qsfp_i2c1_bte, wb_m2s_dbg_qsfp_i2c1_bte}),
    .wbm_dat_o ({wb_s2m_or1k_d_qsfp_i2c1_dat, wb_s2m_dbg_qsfp_i2c1_dat}),
    .wbm_ack_o ({wb_s2m_or1k_d_qsfp_i2c1_ack, wb_s2m_dbg_qsfp_i2c1_ack}),
    .wbm_err_o ({wb_s2m_or1k_d_qsfp_i2c1_err, wb_s2m_dbg_qsfp_i2c1_err}),
    .wbm_rty_o ({wb_s2m_or1k_d_qsfp_i2c1_rty, wb_s2m_dbg_qsfp_i2c1_rty}),
    .wbs_adr_o (wb_m2s_resize_qsfp_i2c1_adr),
    .wbs_dat_o (wb_m2s_resize_qsfp_i2c1_dat),
    .wbs_sel_o (wb_m2s_resize_qsfp_i2c1_sel),
    .wbs_we_o  (wb_m2s_resize_qsfp_i2c1_we),
    .wbs_cyc_o (wb_m2s_resize_qsfp_i2c1_cyc),
    .wbs_stb_o (wb_m2s_resize_qsfp_i2c1_stb),
    .wbs_cti_o (wb_m2s_resize_qsfp_i2c1_cti),
    .wbs_bte_o (wb_m2s_resize_qsfp_i2c1_bte),
    .wbs_dat_i (wb_s2m_resize_qsfp_i2c1_dat),
    .wbs_ack_i (wb_s2m_resize_qsfp_i2c1_ack),
    .wbs_err_i (wb_s2m_resize_qsfp_i2c1_err),
    .wbs_rty_i (wb_s2m_resize_qsfp_i2c1_rty));

wb_data_resize
  #(.aw  (32),
    .mdw (32),
    .sdw (8))
 wb_data_resize_qsfp_i2c1
   (.wbm_adr_i (wb_m2s_resize_qsfp_i2c1_adr),
    .wbm_dat_i (wb_m2s_resize_qsfp_i2c1_dat),
    .wbm_sel_i (wb_m2s_resize_qsfp_i2c1_sel),
    .wbm_we_i  (wb_m2s_resize_qsfp_i2c1_we),
    .wbm_cyc_i (wb_m2s_resize_qsfp_i2c1_cyc),
    .wbm_stb_i (wb_m2s_resize_qsfp_i2c1_stb),
    .wbm_cti_i (wb_m2s_resize_qsfp_i2c1_cti),
    .wbm_bte_i (wb_m2s_resize_qsfp_i2c1_bte),
    .wbm_dat_o (wb_s2m_resize_qsfp_i2c1_dat),
    .wbm_ack_o (wb_s2m_resize_qsfp_i2c1_ack),
    .wbm_err_o (wb_s2m_resize_qsfp_i2c1_err),
    .wbm_rty_o (wb_s2m_resize_qsfp_i2c1_rty),
    .wbs_adr_o (wb_qsfp_i2c1_adr_o),
    .wbs_dat_o (wb_qsfp_i2c1_dat_o),
    .wbs_we_o  (wb_qsfp_i2c1_we_o),
    .wbs_cyc_o (wb_qsfp_i2c1_cyc_o),
    .wbs_stb_o (wb_qsfp_i2c1_stb_o),
    .wbs_cti_o (wb_qsfp_i2c1_cti_o),
    .wbs_bte_o (wb_qsfp_i2c1_bte_o),
    .wbs_dat_i (wb_qsfp_i2c1_dat_i),
    .wbs_ack_i (wb_qsfp_i2c1_ack_i),
    .wbs_err_i (wb_qsfp_i2c1_err_i),
    .wbs_rty_i (wb_qsfp_i2c1_rty_i));

wb_arbiter
  #(.num_masters (3))
 wb_arbiter_rom0
   (.wb_clk_i  (wb_clk_i),
    .wb_rst_i  (wb_rst_i),
    .wbm_adr_i ({wb_m2s_or1k_i_rom0_adr, wb_m2s_or1k_d_rom0_adr, wb_m2s_dbg_rom0_adr}),
    .wbm_dat_i ({wb_m2s_or1k_i_rom0_dat, wb_m2s_or1k_d_rom0_dat, wb_m2s_dbg_rom0_dat}),
    .wbm_sel_i ({wb_m2s_or1k_i_rom0_sel, wb_m2s_or1k_d_rom0_sel, wb_m2s_dbg_rom0_sel}),
    .wbm_we_i  ({wb_m2s_or1k_i_rom0_we, wb_m2s_or1k_d_rom0_we, wb_m2s_dbg_rom0_we}),
    .wbm_cyc_i ({wb_m2s_or1k_i_rom0_cyc, wb_m2s_or1k_d_rom0_cyc, wb_m2s_dbg_rom0_cyc}),
    .wbm_stb_i ({wb_m2s_or1k_i_rom0_stb, wb_m2s_or1k_d_rom0_stb, wb_m2s_dbg_rom0_stb}),
    .wbm_cti_i ({wb_m2s_or1k_i_rom0_cti, wb_m2s_or1k_d_rom0_cti, wb_m2s_dbg_rom0_cti}),
    .wbm_bte_i ({wb_m2s_or1k_i_rom0_bte, wb_m2s_or1k_d_rom0_bte, wb_m2s_dbg_rom0_bte}),
    .wbm_dat_o ({wb_s2m_or1k_i_rom0_dat, wb_s2m_or1k_d_rom0_dat, wb_s2m_dbg_rom0_dat}),
    .wbm_ack_o ({wb_s2m_or1k_i_rom0_ack, wb_s2m_or1k_d_rom0_ack, wb_s2m_dbg_rom0_ack}),
    .wbm_err_o ({wb_s2m_or1k_i_rom0_err, wb_s2m_or1k_d_rom0_err, wb_s2m_dbg_rom0_err}),
    .wbm_rty_o ({wb_s2m_or1k_i_rom0_rty, wb_s2m_or1k_d_rom0_rty, wb_s2m_dbg_rom0_rty}),
    .wbs_adr_o (wb_rom0_adr_o),
    .wbs_dat_o (wb_rom0_dat_o),
    .wbs_sel_o (wb_rom0_sel_o),
    .wbs_we_o  (wb_rom0_we_o),
    .wbs_cyc_o (wb_rom0_cyc_o),
    .wbs_stb_o (wb_rom0_stb_o),
    .wbs_cti_o (wb_rom0_cti_o),
    .wbs_bte_o (wb_rom0_bte_o),
    .wbs_dat_i (wb_rom0_dat_i),
    .wbs_ack_i (wb_rom0_ack_i),
    .wbs_err_i (wb_rom0_err_i),
    .wbs_rty_i (wb_rom0_rty_i));

wb_arbiter
  #(.num_masters (3))
 wb_arbiter_sysram
   (.wb_clk_i  (wb_clk_i),
    .wb_rst_i  (wb_rst_i),
    .wbm_adr_i ({wb_m2s_or1k_i_sysram_adr, wb_m2s_or1k_d_sysram_adr, wb_m2s_dbg_sysram_adr}),
    .wbm_dat_i ({wb_m2s_or1k_i_sysram_dat, wb_m2s_or1k_d_sysram_dat, wb_m2s_dbg_sysram_dat}),
    .wbm_sel_i ({wb_m2s_or1k_i_sysram_sel, wb_m2s_or1k_d_sysram_sel, wb_m2s_dbg_sysram_sel}),
    .wbm_we_i  ({wb_m2s_or1k_i_sysram_we, wb_m2s_or1k_d_sysram_we, wb_m2s_dbg_sysram_we}),
    .wbm_cyc_i ({wb_m2s_or1k_i_sysram_cyc, wb_m2s_or1k_d_sysram_cyc, wb_m2s_dbg_sysram_cyc}),
    .wbm_stb_i ({wb_m2s_or1k_i_sysram_stb, wb_m2s_or1k_d_sysram_stb, wb_m2s_dbg_sysram_stb}),
    .wbm_cti_i ({wb_m2s_or1k_i_sysram_cti, wb_m2s_or1k_d_sysram_cti, wb_m2s_dbg_sysram_cti}),
    .wbm_bte_i ({wb_m2s_or1k_i_sysram_bte, wb_m2s_or1k_d_sysram_bte, wb_m2s_dbg_sysram_bte}),
    .wbm_dat_o ({wb_s2m_or1k_i_sysram_dat, wb_s2m_or1k_d_sysram_dat, wb_s2m_dbg_sysram_dat}),
    .wbm_ack_o ({wb_s2m_or1k_i_sysram_ack, wb_s2m_or1k_d_sysram_ack, wb_s2m_dbg_sysram_ack}),
    .wbm_err_o ({wb_s2m_or1k_i_sysram_err, wb_s2m_or1k_d_sysram_err, wb_s2m_dbg_sysram_err}),
    .wbm_rty_o ({wb_s2m_or1k_i_sysram_rty, wb_s2m_or1k_d_sysram_rty, wb_s2m_dbg_sysram_rty}),
    .wbs_adr_o (wb_sysram_adr_o),
    .wbs_dat_o (wb_sysram_dat_o),
    .wbs_sel_o (wb_sysram_sel_o),
    .wbs_we_o  (wb_sysram_we_o),
    .wbs_cyc_o (wb_sysram_cyc_o),
    .wbs_stb_o (wb_sysram_stb_o),
    .wbs_cti_o (wb_sysram_cti_o),
    .wbs_bte_o (wb_sysram_bte_o),
    .wbs_dat_i (wb_sysram_dat_i),
    .wbs_ack_i (wb_sysram_ack_i),
    .wbs_err_i (wb_sysram_err_i),
    .wbs_rty_i (wb_sysram_rty_i));

wb_arbiter
  #(.num_masters (2))
 wb_arbiter_uart0
   (.wb_clk_i  (wb_clk_i),
    .wb_rst_i  (wb_rst_i),
    .wbm_adr_i ({wb_m2s_or1k_d_uart0_adr, wb_m2s_dbg_uart0_adr}),
    .wbm_dat_i ({wb_m2s_or1k_d_uart0_dat, wb_m2s_dbg_uart0_dat}),
    .wbm_sel_i ({wb_m2s_or1k_d_uart0_sel, wb_m2s_dbg_uart0_sel}),
    .wbm_we_i  ({wb_m2s_or1k_d_uart0_we, wb_m2s_dbg_uart0_we}),
    .wbm_cyc_i ({wb_m2s_or1k_d_uart0_cyc, wb_m2s_dbg_uart0_cyc}),
    .wbm_stb_i ({wb_m2s_or1k_d_uart0_stb, wb_m2s_dbg_uart0_stb}),
    .wbm_cti_i ({wb_m2s_or1k_d_uart0_cti, wb_m2s_dbg_uart0_cti}),
    .wbm_bte_i ({wb_m2s_or1k_d_uart0_bte, wb_m2s_dbg_uart0_bte}),
    .wbm_dat_o ({wb_s2m_or1k_d_uart0_dat, wb_s2m_dbg_uart0_dat}),
    .wbm_ack_o ({wb_s2m_or1k_d_uart0_ack, wb_s2m_dbg_uart0_ack}),
    .wbm_err_o ({wb_s2m_or1k_d_uart0_err, wb_s2m_dbg_uart0_err}),
    .wbm_rty_o ({wb_s2m_or1k_d_uart0_rty, wb_s2m_dbg_uart0_rty}),
    .wbs_adr_o (wb_m2s_resize_uart0_adr),
    .wbs_dat_o (wb_m2s_resize_uart0_dat),
    .wbs_sel_o (wb_m2s_resize_uart0_sel),
    .wbs_we_o  (wb_m2s_resize_uart0_we),
    .wbs_cyc_o (wb_m2s_resize_uart0_cyc),
    .wbs_stb_o (wb_m2s_resize_uart0_stb),
    .wbs_cti_o (wb_m2s_resize_uart0_cti),
    .wbs_bte_o (wb_m2s_resize_uart0_bte),
    .wbs_dat_i (wb_s2m_resize_uart0_dat),
    .wbs_ack_i (wb_s2m_resize_uart0_ack),
    .wbs_err_i (wb_s2m_resize_uart0_err),
    .wbs_rty_i (wb_s2m_resize_uart0_rty));

wb_data_resize
  #(.aw  (32),
    .mdw (32),
    .sdw (8))
 wb_data_resize_uart0
   (.wbm_adr_i (wb_m2s_resize_uart0_adr),
    .wbm_dat_i (wb_m2s_resize_uart0_dat),
    .wbm_sel_i (wb_m2s_resize_uart0_sel),
    .wbm_we_i  (wb_m2s_resize_uart0_we),
    .wbm_cyc_i (wb_m2s_resize_uart0_cyc),
    .wbm_stb_i (wb_m2s_resize_uart0_stb),
    .wbm_cti_i (wb_m2s_resize_uart0_cti),
    .wbm_bte_i (wb_m2s_resize_uart0_bte),
    .wbm_dat_o (wb_s2m_resize_uart0_dat),
    .wbm_ack_o (wb_s2m_resize_uart0_ack),
    .wbm_err_o (wb_s2m_resize_uart0_err),
    .wbm_rty_o (wb_s2m_resize_uart0_rty),
    .wbs_adr_o (wb_uart0_adr_o),
    .wbs_dat_o (wb_uart0_dat_o),
    .wbs_we_o  (wb_uart0_we_o),
    .wbs_cyc_o (wb_uart0_cyc_o),
    .wbs_stb_o (wb_uart0_stb_o),
    .wbs_cti_o (wb_uart0_cti_o),
    .wbs_bte_o (wb_uart0_bte_o),
    .wbs_dat_i (wb_uart0_dat_i),
    .wbs_ack_i (wb_uart0_ack_i),
    .wbs_err_i (wb_uart0_err_i),
    .wbs_rty_i (wb_uart0_rty_i));

wb_arbiter
  #(.num_masters (2))
 wb_arbiter_bpi0
   (.wb_clk_i  (wb_clk_i),
    .wb_rst_i  (wb_rst_i),
    .wbm_adr_i ({wb_m2s_or1k_d_bpi0_adr, wb_m2s_dbg_bpi0_adr}),
    .wbm_dat_i ({wb_m2s_or1k_d_bpi0_dat, wb_m2s_dbg_bpi0_dat}),
    .wbm_sel_i ({wb_m2s_or1k_d_bpi0_sel, wb_m2s_dbg_bpi0_sel}),
    .wbm_we_i  ({wb_m2s_or1k_d_bpi0_we, wb_m2s_dbg_bpi0_we}),
    .wbm_cyc_i ({wb_m2s_or1k_d_bpi0_cyc, wb_m2s_dbg_bpi0_cyc}),
    .wbm_stb_i ({wb_m2s_or1k_d_bpi0_stb, wb_m2s_dbg_bpi0_stb}),
    .wbm_cti_i ({wb_m2s_or1k_d_bpi0_cti, wb_m2s_dbg_bpi0_cti}),
    .wbm_bte_i ({wb_m2s_or1k_d_bpi0_bte, wb_m2s_dbg_bpi0_bte}),
    .wbm_dat_o ({wb_s2m_or1k_d_bpi0_dat, wb_s2m_dbg_bpi0_dat}),
    .wbm_ack_o ({wb_s2m_or1k_d_bpi0_ack, wb_s2m_dbg_bpi0_ack}),
    .wbm_err_o ({wb_s2m_or1k_d_bpi0_err, wb_s2m_dbg_bpi0_err}),
    .wbm_rty_o ({wb_s2m_or1k_d_bpi0_rty, wb_s2m_dbg_bpi0_rty}),
    .wbs_adr_o (wb_bpi0_adr_o),
    .wbs_dat_o (wb_bpi0_dat_o),
    .wbs_sel_o (wb_bpi0_sel_o),
    .wbs_we_o  (wb_bpi0_we_o),
    .wbs_cyc_o (wb_bpi0_cyc_o),
    .wbs_stb_o (wb_bpi0_stb_o),
    .wbs_cti_o (wb_bpi0_cti_o),
    .wbs_bte_o (wb_bpi0_bte_o),
    .wbs_dat_i (wb_bpi0_dat_i),
    .wbs_ack_i (wb_bpi0_ack_i),
    .wbs_err_i (wb_bpi0_err_i),
    .wbs_rty_i (wb_bpi0_rty_i));

endmodule
