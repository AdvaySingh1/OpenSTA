# delay calc example
read_liberty examples/nangate45_slow.lib
# read_verilog examples/example1.v
read_verilog tmp/test/sample1.v
link_design top
create_clock -name clk -period 10 {clk1 clk2 clk3}
set_input_delay -clock clk 0 {in1 in2}
report_checks

# NEW: show cells in top
set top_cells [get_cells -hier *]
puts "Cell count: [llength $top_cells]"
puts "First 5 cells: [lrange $top_cells 0 4]"

set r1 [get_cells r1]

puts "cell:           [get_property $r1 cell]"
puts "full_name:      [get_property $r1 full_name]"
puts "is_buffer:      [get_property $r1 is_buffer]"
puts "is_clock_gate:  [get_property $r1 is_clock_gate]"
puts "is_hierarchical:[get_property $r1 is_hierarchical]"
puts "is_inverter:    [get_property $r1 is_inverter]"
puts "is_macro:       [get_property $r1 is_macro]"
puts "is_memory:      [get_property $r1 is_memory]"
puts "liberty_cell:   [get_property $r1 liberty_cell]"
puts "name:           [get_property $r1 name]"


set all_r_cells [get_cells r*]

foreach c $all_r_cells {
  puts "---- $c ----"
  puts "cell:           [get_property $c cell]"
  puts "full_name:      [get_property $c full_name]"
  puts "is_buffer:      [get_property $c is_buffer]"
  puts "is_clock_gate:  [get_property $c is_clock_gate]"
  puts "is_hierarchical:[get_property $c is_hierarchical]"
  puts "is_inverter:    [get_property $c is_inverter]"
  puts "is_macro:       [get_property $c is_macro]"
  puts "is_memory:      [get_property $c is_memory]"
  puts "liberty_cell:   [get_property $c liberty_cell]"
  puts "name:           [get_property $c name]"
}