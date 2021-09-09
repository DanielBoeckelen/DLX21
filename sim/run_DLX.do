vsim -t 100ps -novopt work.TB_DLX(test)
do ./wave_basic.do
run 150ns
