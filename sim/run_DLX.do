vsim -t 100ps -novopt work.TB_DLX(test)
do ./wave_FWD.do
run 150ns
