vcom -93 -work ./work ../../src/constants.vhd
vcom -93 -work ./work ../../src/a.b-DataPath-core/a.b.b-Decode-core/a.b.b.a-registerfile.vhd
vcom -93 -work ./work ../../tb/TB_a.b.b.a-registerfile.vhd.vhd
vsim work.tb_RF
