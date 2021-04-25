onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider D
add wave -noupdate -color Cyan -format Logic /tb_cu/dut/reg_latch_en
add wave -noupdate -color Cyan -format Logic /tb_cu/dut/rd1
add wave -noupdate -color Cyan -format Logic /tb_cu/dut/rd2
add wave -noupdate -divider EXE
add wave -noupdate -color Cyan -format Logic /tb_cu/dut/mux_a_sel
add wave -noupdate -color Cyan -format Logic /tb_cu/dut/mux_b_sel
add wave -noupdate -color Cyan -format Literal /tb_cu/dut/alu_opc
add wave -noupdate -color Cyan -format Logic /tb_cu/dut/alu_outreg_en
add wave -noupdate -color Cyan -format Logic /tb_cu/dut/dram_r_in
add wave -noupdate -divider MEM
add wave -noupdate -color Cyan -format Logic /tb_cu/dut/mem_en_in
add wave -noupdate -color Cyan -format Logic /tb_cu/dut/dram_w_in
add wave -noupdate -color Cyan -format Logic /tb_cu/dut/rf_we
add wave -noupdate -divider WB
add wave -noupdate -color Cyan -format Logic /tb_cu/dut/dram_en_in
add wave -noupdate -color Cyan -format Logic /tb_cu/dut/wb_mux_sel
add wave -noupdate -divider inputs
add wave -noupdate -format Literal /tb_cu/dut/opcode
add wave -noupdate -format Literal /tb_cu/dut/func
add wave -noupdate -format Logic /tb_cu/dut/clk
add wave -noupdate -format Logic /tb_cu/dut/rst
add wave -noupdate -divider ir_op_func
add wave -noupdate -format Literal /tb_cu/dut/ir_opcode
add wave -noupdate -format Literal /tb_cu/dut/ir_func
add wave -noupdate -divider CWs
add wave -noupdate -color Gold -format Literal /tb_cu/dut/cw
add wave -noupdate -color Gold -format Literal /tb_cu/dut/cw1
add wave -noupdate -color Gold -format Literal /tb_cu/dut/cw2
add wave -noupdate -color Gold -format Literal /tb_cu/dut/cw3
add wave -noupdate -color Gold -format Literal /tb_cu/dut/cw4
add wave -noupdate -divider aluops
add wave -noupdate -color {Medium Orchid} -format Literal /tb_cu/dut/aluop_d
add wave -noupdate -color {Medium Orchid} -format Literal /tb_cu/dut/aluop_e
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 204
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {298 ns} {303300 ps}
