# hierarchial pattern matching with u_blk1/blk*
read_liberty examples/nangate45_slow.lib
read_verilog tmp/test/sample3.v
link_design dut
report_object_full_names [get_cells -hier u_blk1/blk*]