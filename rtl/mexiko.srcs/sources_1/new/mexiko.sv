`timescale 1ns / 1ps

module mexiko(
    input             qsfp_refclk_p_i,
    input             qsfp_refclk_n_i,
    input             areset_i,
    output            resetdone_o,

    output [0:7]      qsfp_txp_o,
    output [0:7]      qsfp_txn_o,
    input  [0:7]      qsfp_rxp_i,
    input  [0:7]      qsfp_rxn_i
);

  network network_i (
    .refclk_p_i(qsfp_refclk_p_i),
    .refclk_n_i(qsfp_refclk_n_i),
    .areset_i(areset_i),
    .resetdone_o(resetdone_o),
    .txp_o(qsfp_txp_o),
    .txn_o(qsfp_txn_o),
    .rxp_i(qsfp_rxp_i),
    .rxn_i(qsfp_rxn_i)
  );

endmodule
