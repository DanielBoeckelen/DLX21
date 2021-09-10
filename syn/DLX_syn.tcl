analyze -format vhdl -library WORK ../src/constants.vhd
analyze -format vhdl -library WORK ../src/001-instruction_set.vhd
#analyze -format vhdl -library WORK ../src/ALU_OPs.vhd
analyze -format vhdl -library WORK ../src/01-regn.vhd
analyze -format vhdl -library WORK ../src/002-func_external.vhd
analyze -format vhdl -library WORK ../src/02-mux21.vhd
analyze -format vhdl -library WORK ../src/03-mux41.vhd
analyze -format vhdl -library WORK ../src/04-ff.vhd

######## DATAPATH CORE ########
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.f-HazardDetection.vhd

######## FETCH STAGE ########
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.a-Fetch.vhd

######## DECODE STAGE ########
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.b-Decode-core/a.b.b.a-registerfile.vhd
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.b-Decode-core/a.b.b.b-instruction_type.vhd
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.b-Decode-core/a.b.b.c-instruction_decomposition.vhd
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.b-Decode.vhd

######## EXECUTE STAGE ########
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.c-P4Adder-core/a.b.c.a.c.a-carry_generator_generic.vhd
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.c-P4Adder-core/a.b.c.a.c.b-sum_generator.vhd
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.c-P4Adder-core/a.b.c.a.c.c-carry_select_basic.vhd
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.c-P4Adder-core/a.b.c.a.c.d-PG_net_generic.vhd
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.c-P4Adder-core/a.b.c.a.c.e-PGblock.vhd
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.c-P4Adder-core/a.b.c.a.c.f-Gblock.vhd
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.c-P4Adder-core/a.b.c.a.c.g-rca.vhd
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.c-P4Adder-core/a.b.c.a.c.h-fa.vhd
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.a-comparator.vhd
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.b-shifter.vhd
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU-core/a.b.c.a.c-P4Adder.vhd
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.a-ALU.vhd
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.b-Branch_Cond_Unit.vhd
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.c-Execute-core/a.b.c.c-FWD_Unit.vhd
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.c-Execute.vhd

######## MEMORY STAGE ########
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.d-Memory.vhd

######## WRITE BACK STAGE ########
analyze -format vhdl -library WORK ../src/a.b-DataPath-core/a.b.e-Writeback.vhd

##################################
analyze -format vhdl -library WORK ../src/a.a-CU.vhd
analyze -format vhdl -library WORK ../src/a.b-Datapath.vhd
analyze -format vhdl -library WORK ../src/a-DLX.vhd

# Elaborate and save output to a log file
#set power_preserve_rtl_hier_names true
elaborate DLX -arch dlx_rtl -library WORK > ./elaborate.txt

# Clock definition, first with 0 period and then iterate to find fmax, and uncertainty/delays
create_clock -name "MY_CLK" -period 0.63 Clk
#set_dont_touch_network MY_CLK
#set_clock_uncertainty 0.07 [get_clocks MY_CLK]
#set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection [all_inputs] CLK]
#set_output_delay 0.5 -max -clock MY_CLK [all_outputs]
### OR
#set_max_delay 2 -from [all_inputs] -to [all_outputs]

# Set a load to the output
#set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
#set_load $OLOAD [all_outputs]

compile
report_resources > ./report_resources.txt
report_timing > ./report_timing.txt
report_area > ./report_area.txt
report_power > ./report_power.txt

write -hierarchy -format ddc -output DLX_postsyn.ddc
write -hierarchy -format vhdl -output DLX_postsyn.vhdl

change_names -hierarchy -rules verilog
write -f verilog -hierarchy -output ../netlist/DLX_postsyn.v
write_sdf ../netlist/DLX.sdf
write_sdc ../netlist/DLX.sdc
