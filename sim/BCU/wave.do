onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider inputs
add wave -noupdate -format Literal -radix decimal /tb_branch_cond_unit/a
add wave -noupdate -format Literal /tb_branch_cond_unit/alu_opc
add wave -noupdate -format Literal /tb_branch_cond_unit/jump_type
add wave -noupdate -divider outputs
add wave -noupdate -format Literal /tb_branch_cond_unit/pc_sel
add wave -noupdate -format Logic /tb_branch_cond_unit/zero
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {72600 ps} 0}
configure wave -namecolwidth 265
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
WaveRestoreZoom {0 ps} {210 ns}
