# hierarchical pattern matching with u_blk1/blk*
read_liberty ../examples/nangate45_slow.lib.gz
read_verilog get_cell_hierarchy.v
link_design dut
report_object_full_names [get_cells -hier u_blk1/blk*]