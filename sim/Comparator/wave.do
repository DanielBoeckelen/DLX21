onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal -radix decimal /tb_comparator/dut/a
add wave -noupdate -format Literal -radix decimal /tb_comparator/dut/b
add wave -noupdate -format Literal -radix decimal /tb_comparator/dut/opsel
add wave -noupdate -format Literal -radix hexadecimal /tb_comparator/dut/res
add wave -noupdate -format Literal /tb_comparator/dut/comp_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {53300 ps} 0}
configure wave -namecolwidth 231
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
WaveRestoreZoom {20 ns} {71200 ps}
