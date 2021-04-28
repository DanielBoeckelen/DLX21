vcom -93 -work ./work ../../src/constants.vhd
vcom -93 -work ./work ../../src/001-instruction_set.vhd

vcom -93 -work ./work ../../src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.b-Branch_Cond_Unit.vhd

vcom -93 -work ./work ../../tb/TB_a.b.c.b-Branch_Cond_Unit.vhd
vsim work.tb_Branch_Cond_Unit
