# delay calc example
read_liberty examples/nangate45_slow.lib
read_verilog examples/example1.v
link_design top
create_clock -name clk -period 10 {clk1 clk2 clk3}
set_input_delay -clock clk 0 {in1 in2}
report_checks
