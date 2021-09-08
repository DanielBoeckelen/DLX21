onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_dlx/u1/dp/decodestage/rf/clk
add wave -noupdate -format Logic /tb_dlx/u1/dp/decodestage/rf/rst
add wave -noupdate -color {Yellow Green} -format Literal /tb_dlx/u1/dp/executestage/alu0/alu_opc
add wave -noupdate -divider RF
add wave -noupdate -color {Yellow Green} -format Literal -radix decimal -expand /tb_dlx/u1/dp/decodestage/rf/registers
add wave -noupdate -divider DRAM
add wave -noupdate -color {Yellow Green} -format Literal -radix decimal /tb_dlx/u1/dram_i/drammem
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dram_i/addr_in
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dram_i/data_in
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dram_i/load_type
add wave -noupdate -format Logic -radix decimal /tb_dlx/u1/dram_i/store_type
add wave -noupdate -format Logic -radix decimal /tb_dlx/u1/dram_i/dram_w
add wave -noupdate -format Logic -radix decimal /tb_dlx/u1/dram_i/dram_r
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dram_i/data_out
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dram_i/drammem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {54500 ps} 0}
configure wave -namecolwidth 250
configure wave -valuecolwidth 85
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
WaveRestoreZoom {23100 ps} {89100 ps}
