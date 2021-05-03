vcom -93 -work ./work ../../src/constants.vhd
vcom -93 -work ./work ../../src/a.c-IRAM.vhd
vcom -93 -work ./work ../../tb/TB_a.c-IRAM.vhd
vsim work.tb_IRAM
