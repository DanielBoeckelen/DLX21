vsim -t 100ps -novopt work.tb_Branch_Cond_Unit(test)
do ./wave.do
run 300ns
