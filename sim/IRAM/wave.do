onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_iram/dut/rst
add wave -noupdate -format Literal -radix unsigned /tb_iram/dut/addr
add wave -noupdate -format Literal -radix hexadecimal /tb_iram/dut/dout
add wave -noupdate -divider -height 25 {IRAM content}
add wave -noupdate -format Literal -radix hexadecimal /tb_iram/dut/iram_mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3900 ps} 0}
configure wave -namecolwidth 199
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
WaveRestoreZoom {0 ps} {125800 ps}
