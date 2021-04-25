vsim -t 100ps -novopt work.tb_RF(test)
do ./wave.do
run 500ns
