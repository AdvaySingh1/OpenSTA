# Read liberty library (replace with your actual library file)
read_liberty examples/nangate45_typ.lib.gz

# Read Verilog netlist
read_verilog tmp/test/sample1.v

# Link the design
link_design inc_if_eq

# Read SDC constraints
read_sdc tmp/test/sample1.sdc

# Report timing
report_checks -path_delay max -format full_clock_expanded
report_checks -path_delay min -format full_clock_expanded
report_tns
report_wns
report_worst_slack