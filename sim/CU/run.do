vsim -t 100ps -novopt work.tb_CU(test)
do ./wave.do
run 300ns
