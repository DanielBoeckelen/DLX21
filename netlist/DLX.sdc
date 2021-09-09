###################################################################

# Created by write_sdc on Thu Sep  9 10:36:28 2021

###################################################################
set sdc_version 1.9

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
create_clock [get_ports Clk]  -name MY_CLK  -period 0.63  -waveform {0 0.315}
