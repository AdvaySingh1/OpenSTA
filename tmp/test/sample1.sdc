# Create clock with 10ns period (100MHz)
create_clock -name clk -period 10 [get_ports clk]

# Set input delays (assume 2ns from clock edge)
set_input_delay -clock clk -max 2.0 [get_ports {a b}]
set_input_delay -clock clk -min 0.5 [get_ports {a b}]

# Set output delays (assume 2ns to next register)
set_output_delay -clock clk -max 2.0 [get_ports {c[*]}]
set_output_delay -clock clk -min 0.5 [get_ports {c[*]}]

# Set input transition
set_input_transition 0.1 [all_inputs]

# Set load capacitance on outputs
set_load 0.01 [all_outputs]