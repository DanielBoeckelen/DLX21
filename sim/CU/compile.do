vcom -93 -work ./work ../../src/constants.vhd
vcom -93 -work ./work ../../src/001-instruction_set.vhd

vcom -93 -work ./work ../../src/a.a-CU.vhd

vcom -93 -work ./work ../../tb/TB_a.a-CU.vhd
vsim work.tb_CU
