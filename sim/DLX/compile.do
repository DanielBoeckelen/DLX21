vcom -93 -work ./work ../DLX21/src/constants.vhd
vcom -93 -work ./work ../DLX21/src/001-instruction_set.vhd
#vcom -93 -work ./work ../src/ALU_OPs.vhd
vcom -93 -work ./work ../DLX21/src/01-regn.vhd
vcom -93 -work ./work ../DLX21/src/002-func_external.vhd
vcom -93 -work ./work ../DLX21/src/02-mux21.vhd
vcom -93 -work ./work ../DLX21/src/03-mux41.vhd
vcom -93 -work ./work ../DLX21/src/04-ff.vhd

######## DATAPATH CORE ########
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.f-HazardDetection.vhd

######## FETCH STAGE ########
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.a-Fetch.vhd

######## DECODE STAGE ########
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.b-Decode-core/a.b.b.a-registerfile2.vhd
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.b-Decode-core/a.b.b.b-instruction_type.vhd
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.b-Decode-core/a.b.b.c-instruction_decomposition.vhd
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.b-Decode.vhd

######## EXECUTE STAGE ########
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.c-P4Adder-core/a.b.c.a.c.a-carry_generator_generic.vhd
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.c-P4Adder-core/a.b.c.a.c.b-sum_generator.vhd
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.c-P4Adder-core/a.b.c.a.c.c-carry_select_basic.vhd
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.c-P4Adder-core/a.b.c.a.c.d-PG_net_generic.vhd
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.c-P4Adder-core/a.b.c.a.c.e-PGblock.vhd
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.c-P4Adder-core/a.b.c.a.c.f-Gblock.vhd
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.c-P4Adder-core/a.b.c.a.c.g-rca.vhd
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.c-P4Adder-core/a.b.c.a.c.h-fa.vhd
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.a-comparator.vhd
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.b-shifter.vhd
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.c-P4Adder.vhd
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU.vhd
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.b-Branch_Cond_Unit.vhd
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.c-FWD_Unit.vhd
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.c-Execute.vhd

######## MEMORY STAGE ########
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.d-Memory.vhd

######## WRITE BACK STAGE ########
vcom -93 -work ./work ../DLX21/src/a.b-DataPath-core/a.b.e-Writeback.vhd

##################################
vcom -93 -work ./work ../DLX21/src/a.a-CU.vhd
vcom -93 -work ./work ../DLX21/src/a.b-Datapath.vhd
vcom -93 -work ./work ../DLX21/src/a-DLX.vhd
vcom -93 -work ./work ../DLX21/src/a.c-IRAM.vhd
vcom -93 -work ./work ../DLX21/src/a.d-DRAM.vhd
#vlog -work ./work ../netlist/RISCV_lite_post_syn.v
#vlog -work ./work ../innovus/RISCV_lite_postroute.v

######## TESTBENCH ########
vcom -93 -work ./work ../../tb/TB_DLX.vhd
vsim work.tb_dlx
