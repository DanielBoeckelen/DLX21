onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider comparator
add wave -noupdate -format Literal -radix decimal /tb_alu/dut/comp/a
add wave -noupdate -format Literal -radix decimal /tb_alu/dut/comp/b
add wave -noupdate -format Literal -radix decimal /tb_alu/dut/comp/opsel
add wave -noupdate -format Literal -radix decimal /tb_alu/dut/comp/res
add wave -noupdate -format Literal /tb_alu/dut/comp/comp_state
add wave -noupdate -divider shifter
add wave -noupdate -format Literal -radix decimal /tb_alu/dut/shift/a
add wave -noupdate -format Literal -radix decimal /tb_alu/dut/shift/b
add wave -noupdate -format Logic -radix decimal /tb_alu/dut/shift/logic_arith
add wave -noupdate -format Logic -radix decimal /tb_alu/dut/shift/left_right
add wave -noupdate -format Literal -radix decimal /tb_alu/dut/shift/res
add wave -noupdate -format Literal /tb_alu/dut/shift/shf_state
add wave -noupdate -divider P4
add wave -noupdate -format Literal -radix decimal /tb_alu/dut/add_sub_unit/a
add wave -noupdate -format Literal -radix decimal /tb_alu/dut/add_sub_unit/b
add wave -noupdate -format Logic -radix decimal /tb_alu/dut/add_sub_unit/cin
add wave -noupdate -format Literal -radix decimal /tb_alu/dut/add_sub_unit/s
add wave -noupdate -format Logic -radix decimal /tb_alu/dut/add_sub_unit/cout
add wave -noupdate -format Literal -radix decimal /tb_alu/dut/add_sub_unit/ctmp
add wave -noupdate -format Literal -radix decimal /tb_alu/dut/add_sub_unit/csum
add wave -noupdate -divider ALU
add wave -noupdate -format Literal -radix decimal /tb_alu/dut/op1
add wave -noupdate -format Literal -radix decimal /tb_alu/dut/op2
add wave -noupdate -format Literal -radix decimal /tb_alu/dut/alu_opc
add wave -noupdate -format Literal -radix decimal /tb_alu/dut/alu_res
add wave -noupdate -format Literal -radix decimal /tb_alu/dut/opsel
add wave -noupdate -format Literal -radix decimal /tb_alu/dut/comp_res
add wave -noupdate -format Literal -radix decimal /tb_alu/dut/shift_res
add wave -noupdate -format Literal -radix decimal /tb_alu/dut/logic_res
add wave -noupdate -format Literal -radix decimal /tb_alu/dut/add_sub_res
add wave -noupdate -format Literal -radix decimal /tb_alu/dut/b
add wave -noupdate -format Logic -radix decimal /tb_alu/dut/logic_arith
add wave -noupdate -format Logic -radix decimal /tb_alu/dut/left_right
add wave -noupdate -format Logic -radix decimal /tb_alu/dut/add_sub
add wave -noupdate -format Logic -radix decimal /tb_alu/dut/cout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {66400 ps} 0}
configure wave -namecolwidth 327
configure wave -valuecolwidth 203
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
WaveRestoreZoom {0 ps} {315 ns}
