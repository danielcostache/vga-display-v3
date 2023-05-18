set_property PACKAGE_PIN T10 [get_ports {seg7_cathodes_n[0]}]
set_property PACKAGE_PIN R10 [get_ports {seg7_cathodes_n[1]}]
set_property PACKAGE_PIN K16 [get_ports {seg7_cathodes_n[2]}]
set_property PACKAGE_PIN K13 [get_ports {seg7_cathodes_n[3]}]
set_property PACKAGE_PIN P15 [get_ports {seg7_cathodes_n[4]}]
set_property PACKAGE_PIN T11 [get_ports {seg7_cathodes_n[5]}]
set_property PACKAGE_PIN L18 [get_ports {seg7_cathodes_n[6]}]
set_property PACKAGE_PIN H15 [get_ports {seg7_cathodes_n[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports -regexp {seg7_cathodes_n\[\d+\]}]
set_false_path -to [get_ports -regexp {seg7_cathodes_n\[\d+\]}]

set_property PACKAGE_PIN J17 [get_ports {seg7_anodes_n[0]}]
set_property PACKAGE_PIN J18 [get_ports {seg7_anodes_n[1]}]
set_property PACKAGE_PIN T9  [get_ports {seg7_anodes_n[2]}]
set_property PACKAGE_PIN J14 [get_ports {seg7_anodes_n[3]}]
set_property PACKAGE_PIN P14 [get_ports {seg7_anodes_n[4]}]
set_property PACKAGE_PIN T14 [get_ports {seg7_anodes_n[5]}]
set_property PACKAGE_PIN K2  [get_ports {seg7_anodes_n[6]}]
set_property PACKAGE_PIN U13 [get_ports {seg7_anodes_n[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports -regexp {seg7_anodes_n\[\d+\]}]
set_false_path -to [get_ports -regexp {seg7_anodes_n\[\d+\]}]
