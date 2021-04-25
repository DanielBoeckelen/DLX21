onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal -radix decimal /tb_shifter/dut_shifter/a
add wave -noupdate -format Literal -radix decimal /tb_shifter/dut_shifter/b
add wave -noupdate -format Logic /tb_shifter/dut_shifter/logic_arith
add wave -noupdate -format Logic /tb_shifter/dut_shifter/left_right
add wave -noupdate -format Literal -radix decimal /tb_shifter/dut_shifter/res
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {67900 ps} 0}
configure wave -namecolwidth 207
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
WaveRestoreZoom {0 ps} {499 ns}
