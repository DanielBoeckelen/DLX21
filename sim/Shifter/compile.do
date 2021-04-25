vcom -93 -work ./work ../../src/constants.vhd
vcom -93 -work ./work ../../src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.b-shifter.vhd
vcom -93 -work ./work ../../tb/TB_a.b.c.a.b-shifter.vhd
vsim work.tb_shifter
