###################################################################

# Created by write_sdc on Sun Sep 12 11:20:09 2021

###################################################################
set sdc_version 1.9

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
create_clock [get_ports Clk]  -name MY_CLK  -period 1.1  -waveform {0 0.55}
