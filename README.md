# DLX21

-----------

Progress as of 14/05/21:

"first_test.asm" has been tested and works as intended. It shows correct functionality of some I-type and R-type instructions, in a way which also exploits data forwarding from both the memory and writeback stages.

In theory, as shown in some slides/materials, the CU and the DP would receive the instruction in parallel, from the Instruction Register (IR). However, since we need control signals in the decode stage itself, they
would arrive one cycle too late. For this reason, in the DLX.vhd entity, now the CU is receiving the instruction one cycle earlier (directly from the IRAM, bypassing the IR). This will, however, be a source of wrong timing
in regards to the Hazard Detection Unit, so it will need to be looked into as some point.

Next step will be verifying correct jump functionality by using one or more programs with loops.

-----------
