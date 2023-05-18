set_property PACKAGE_PIN P17 [get_ports {Buttons[0]}]
set_property PACKAGE_PIN N17 [get_ports {Buttons[1]}]
set_property PACKAGE_PIN M17 [get_ports {Buttons[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports -regexp {Buttons\[\d+\]}]
set_false_path -from [get_ports -regexp {Buttons\[\d+\]}]






