onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_rf/dut/clk
add wave -noupdate -format Logic /tb_rf/dut/reset
add wave -noupdate -format Logic /tb_rf/dut/enable
add wave -noupdate -format Logic /tb_rf/dut/rd1
add wave -noupdate -format Logic /tb_rf/dut/rd2
add wave -noupdate -format Logic /tb_rf/dut/wr
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix decimal /tb_rf/dut/add_wr
add wave -noupdate -format Literal -radix decimal /tb_rf/dut/add_rd1
add wave -noupdate -format Literal -radix decimal /tb_rf/dut/add_rd2
add wave -noupdate -format Literal -radix decimal /tb_rf/dut/datain
add wave -noupdate -format Literal -radix decimal /tb_rf/dut/out1
add wave -noupdate -format Literal -radix decimal /tb_rf/dut/out2
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /tb_rf/dut/state_rf
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal -radix decimal /tb_rf/dut/registers
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {149 ns} 0}
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
