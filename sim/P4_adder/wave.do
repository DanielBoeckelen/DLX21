onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal /tb_p4adder/dut/a
add wave -noupdate -format Literal /tb_p4adder/dut/b
add wave -noupdate -format Logic /tb_p4adder/dut/cin
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /tb_p4adder/dut/s
add wave -noupdate -format Logic /tb_p4adder/dut/cout
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /tb_p4adder/dut/ctmp
add wave -noupdate -format Literal /tb_p4adder/dut/csum
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {295 ns} 0}
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ns} {1 us}
