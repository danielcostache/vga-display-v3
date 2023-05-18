set_property PACKAGE_PIN B11 [get_ports H_sync]
set_property IOSTANDARD LVCMOS33 [get_ports H_sync]

set_property PACKAGE_PIN B12 [get_ports V_sync]
set_property IOSTANDARD LVCMOS33 [get_ports V_sync]

set_property PACKAGE_PIN A3 [get_ports {VGA_red[0]}]
set_property PACKAGE_PIN B4 [get_ports {VGA_red[1]}]
set_property PACKAGE_PIN C5 [get_ports {VGA_red[2]}]
set_property PACKAGE_PIN A4 [get_ports {VGA_red[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports -regexp {VGA_red\[\d+\]}]

set_property PACKAGE_PIN C6 [get_ports {VGA_grn[0]}]
set_property PACKAGE_PIN A5 [get_ports {VGA_grn[1]}]
set_property PACKAGE_PIN B6 [get_ports {VGA_grn[2]}]
set_property PACKAGE_PIN A6 [get_ports {VGA_grn[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports -regexp {VGA_grn\[\d+\]}]

set_property PACKAGE_PIN B7 [get_ports {VGA_blu[0]}]
set_property PACKAGE_PIN C7 [get_ports {VGA_blu[1]}]
set_property PACKAGE_PIN D7 [get_ports {VGA_blu[2]}]
set_property PACKAGE_PIN D8 [get_ports {VGA_blu[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports -regexp {VGA_blu\[\d+\]}]






