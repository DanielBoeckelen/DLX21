vsim -t 100ps -novopt work.tb_ALU(test)
do ./wave.do
run 50ns
