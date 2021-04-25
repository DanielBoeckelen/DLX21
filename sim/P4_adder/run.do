vsim -t 100ps -novopt work.tb_P4adder(test)
do ./wave_shifter.do
run 300ns
