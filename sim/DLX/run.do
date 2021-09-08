vsim -t 100ps -novopt work.TB_DLX(test)
do ./wave.do
run 300ns
