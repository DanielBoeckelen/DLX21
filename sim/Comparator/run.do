vsim -t 100ps -novopt work.tb_comparator(test)
do ./wave.do
run 500ns
