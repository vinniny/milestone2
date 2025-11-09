# Timing Constraints for RISC-V Single-Cycle Processor
# DE-10 Standard FPGA - 10 MHz Operation

# Create clock constraint for 10 MHz (100 ns period)
# This matches the clock_10M divider output
create_clock -name {i_clk} -period 100.000 -waveform { 0.000 50.000 } [get_ports {i_clk}]

# Create clock for 50 MHz input (if analyzing wrapper)
create_clock -name {CLOCK_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50}]

# Derive PLL clocks if any (for clock divider)
derive_pll_clocks
derive_clock_uncertainty

# Set input delays relative to clock
# Assuming switches/buttons are asynchronous, give them relaxed constraints
set_input_delay -clock {i_clk} -max 10.000 [get_ports {i_io_sw[*]}]
set_input_delay -clock {i_clk} -min 0.000 [get_ports {i_io_sw[*]}]

# Set output delays for displays and LEDs
set_output_delay -clock {i_clk} -max 10.000 [get_ports {o_io_ledr[*]}]
set_output_delay -clock {i_clk} -min 0.000 [get_ports {o_io_ledr[*]}]
set_output_delay -clock {i_clk} -max 10.000 [get_ports {o_io_ledg[*]}]
set_output_delay -clock {i_clk} -min 0.000 [get_ports {o_io_ledg[*]}]
set_output_delay -clock {i_clk} -max 10.000 [get_ports {o_io_hex*[*]}]
set_output_delay -clock {i_clk} -min 0.000 [get_ports {o_io_hex*[*]}]

# Set false paths for asynchronous reset
set_false_path -from [get_ports {i_reset}] -to [all_registers]

# Set false paths for debug outputs (if not timing critical)
set_false_path -from [all_registers] -to [get_ports {o_pc_debug[*]}]
set_false_path -from [all_registers] -to [get_ports {o_insn_vld}]

# Multi-cycle paths (none for true single-cycle, but good practice)
# If memory is truly async-read, it completes in same cycle

# Timing exceptions for cross-domain signals (if any)

# Report timing after constraints
# Use: report_timing -from [get_clocks i_clk] -to [get_clocks i_clk] -setup -npaths 10
