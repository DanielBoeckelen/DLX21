onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 30 RF
add wave -noupdate -format Logic /tb_dlx/u1/dp/decodestage/rf/clk
add wave -noupdate -format Logic /tb_dlx/u1/dp/decodestage/rf/rst
add wave -noupdate -format Logic /tb_dlx/u1/dp/decodestage/rf/enable
add wave -noupdate -format Logic /tb_dlx/u1/dp/decodestage/rf/rd1
add wave -noupdate -format Logic /tb_dlx/u1/dp/decodestage/rf/rd2
add wave -noupdate -format Logic /tb_dlx/u1/dp/decodestage/rf/wr
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/decodestage/rf/add_wr
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/decodestage/rf/add_rs1
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/decodestage/rf/add_rs2
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/decodestage/rf/datain
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/decodestage/rf/out1
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/decodestage/rf/out2
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/decodestage/rf/registers
add wave -noupdate -divider -height 30 ALU
add wave -noupdate -format Literal /tb_dlx/u1/dp/executestage/alu0/alu_opc
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/op1
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/op2
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/alu_res
add wave -noupdate -divider {ALU sigs}
add wave -noupdate -format Literal /tb_dlx/u1/dp/executestage/alu0/opsel
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/comp_res
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/shift_res
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/logic_res
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/add_sub_res
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/mul_res
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/sig_alu_res
add wave -noupdate -format Logic /tb_dlx/u1/dp/executestage/alu0/logic_arith
add wave -noupdate -format Logic /tb_dlx/u1/dp/executestage/alu0/left_right
add wave -noupdate -format Logic /tb_dlx/u1/dp/executestage/alu0/add_sub
add wave -noupdate -format Logic /tb_dlx/u1/dp/executestage/alu0/select_zero_sig
add wave -noupdate -divider -height 30 DRAM
add wave -noupdate -format Logic /tb_dlx/u1/dram_i/en
add wave -noupdate -format Logic /tb_dlx/u1/dram_i/rst
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dram_i/addr_in
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dram_i/data_in
add wave -noupdate -format Literal /tb_dlx/u1/dram_i/load_type
add wave -noupdate -format Logic /tb_dlx/u1/dram_i/store_type
add wave -noupdate -format Logic /tb_dlx/u1/dram_i/dram_w
add wave -noupdate -format Logic /tb_dlx/u1/dram_i/dram_r
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dram_i/data_out
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dram_i/drammem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {18 ns} 0}
configure wave -namecolwidth 330
configure wave -valuecolwidth 143
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
WaveRestoreZoom {8 ns} {29 ns}
