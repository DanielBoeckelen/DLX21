onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_dlx/u1/dp/decodestage/rf/clk
add wave -noupdate -format Logic /tb_dlx/u1/dp/decodestage/rf/rst
add wave -noupdate -color {Yellow Green} -format Literal /tb_dlx/u1/dp/executestage/alu0/alu_opc
add wave -noupdate -divider RF
add wave -noupdate -color {Yellow Green} -format Literal -radix decimal /tb_dlx/u1/dp/decodestage/rf/registers
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
add wave -noupdate -divider -height 30 ALU
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/op1
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/op2
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/alu_opc
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/alu_res
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/opsel
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/comp_res
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/shift_res
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/logic_res
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/add_sub_res
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/mul_res
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/sig_alu_res
add wave -noupdate -format Logic -radix decimal /tb_dlx/u1/dp/executestage/alu0/logic_arith
add wave -noupdate -format Logic -radix decimal /tb_dlx/u1/dp/executestage/alu0/left_right
add wave -noupdate -format Logic -radix decimal /tb_dlx/u1/dp/executestage/alu0/add_sub
add wave -noupdate -format Logic -radix decimal /tb_dlx/u1/dp/executestage/alu0/cout
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/a_add
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/b_add
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/a_shf
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/b_shf
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/a_cmp
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/b_cmp
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/a_mul
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/b_mul
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/select_type_sig
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/alu0/sig_intramux
add wave -noupdate -format Logic -radix decimal /tb_dlx/u1/dp/executestage/alu0/select_zero_sig
add wave -noupdate -format Logic -radix decimal /tb_dlx/u1/dp/executestage/alu0/select_mul
add wave -noupdate -divider -height 30 FWD
add wave -noupdate -format Logic -radix decimal /tb_dlx/u1/dp/executestage/fwd/rst
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/fwd/add_rs1
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/fwd/add_rs2
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/fwd/add_wr_mem
add wave -noupdate -format Literal -radix decimal /tb_dlx/u1/dp/executestage/fwd/add_wr_wb
add wave -noupdate -format Literal -radix binary /tb_dlx/u1/dp/executestage/fwd/fwda
add wave -noupdate -format Literal -radix binary /tb_dlx/u1/dp/executestage/fwd/fwdb
add wave -noupdate -format Logic -radix decimal /tb_dlx/u1/dp/executestage/fwd/rf_we_mem
add wave -noupdate -format Logic -radix decimal /tb_dlx/u1/dp/executestage/fwd/rf_we_wb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1108500 ps} 0}
configure wave -namecolwidth 281
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
WaveRestoreZoom {1094600 ps} {1127 ns}
