vsim -t 100ps -novopt work.tb_IRAM(test)
do ./wave.do
run 200ns
