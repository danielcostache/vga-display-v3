set_property PACKAGE_PIN E3 [get_ports Clock]
set_property IOSTANDARD LVCMOS33 [get_ports Clock]
create_clock -period 10.000 -name PIN_SystemClock_100MHz [get_ports Clock]

create_generated_clock -name vga_sync/vga_sync/temp_clock -source [get_ports Clock] -divide_by 2 [get_pins vga_sync/vga_sync/temp_clock_reg/Q]

create_generated_clock -name refresh_divider/refresh_clock -source [get_ports Clock] -divide_by 420000 [get_pins refresh_divider/temp_clock_reg/Q]
