# 156.25 MHz in from QSFP module
create_clock -period 6.400 -name qsfp_refclk [get_ports qsfp_refclk_p_i]

# Needed for the phy10g constraints to find our clock
set clk156name [get_clocks -of_objects [get_pins *clk156 -hierarchical]]

# These are async regs, don't try to constrain to them
 set_false_path -to [get_pins -of_objects [get_cells -hierarchical -filter {NAME =~ *sync_r_reg*}] -filter {NAME =~ *PRE}]
 set_false_path -to [get_pins -of_objects [get_cells -hierarchical -filter {NAME =~ *sync_r_reg*}] -filter {NAME =~ *CLR}]