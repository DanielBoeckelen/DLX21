vsim -t 100ps -novopt work.tb_shifter(test)
do ./wave_shifter.do
run 500ns
