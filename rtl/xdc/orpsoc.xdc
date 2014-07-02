create_clock -period 12.500 -name emerg_clk [get_ports emerg_clk_i]
create_clock -period 4.000  -name user_clk  [get_ports user_clk_p_i]