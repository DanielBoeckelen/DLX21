# DLX21

-----------

Progress as of 27/05/21:

"Branch.asm" has been tested and works as intended. It shows correct functionality of a loop implemented with BNEZ, load and store (LW/SW) and also an example of load/use hazard
as the pipeline stalls, a bubble is created, and the instruction after the load is re-fetched to allow for the completion of the LW.
With this, the basic DLX should be working as intended, although not all R-type and I-type instructions have been tested already. If there are issues, they should be related to wrong computations.

Next step will be testing all other basic R-type and I-type instructions, as well as BEQZ and JAL; after this, we move on to the advanced instruction-set.

-----------

Progress as of 22/05/21:

"my_Jump.asm" has been tested and works as intended. It shows correct functionality of the J instruction, allowing to loop correctly, and it also showcases data forwarding.
It is pretty much identical to "Jump.asm" provided with the course material, but since SEQ is not yet present in our instruction set, we substituted it with SGE.

The control word for the NOP was modified to have REG_LATCH_EN = '1', because otherwise old instructions in their writeback stage would not be able to complete, due to the NOP disabling the RF.
Instead, when there is a reset, the CW is set to all zeros so that everything is reset.

Next step will be verifying BNEZ/BEQZ/JAL relative jumps (they should work, since the J relative jump computes the address correctly), followed by absolute jumps (JR/JALR).

-----------

Progress as of 14/05/21:

"first_test.asm" has been tested and works as intended. It shows correct functionality of some I-type and R-type instructions, in a way which also exploits data forwarding from both the memory and writeback stages.

In theory, as shown in some slides/materials, the CU and the DP would receive the instruction in parallel, from the Instruction Register (IR). However, since we need control signals in the decode stage itself, they
would arrive one cycle too late. For this reason, in the DLX.vhd entity, now the CU is receiving the instruction one cycle earlier (directly from the IRAM, bypassing the IR). This will, however, be a source of wrong timing
in regards to the Hazard Detection Unit, so it will need to be looked into as some point.

Next step will be verifying correct jump functionality by using one or more programs with loops.

-----------
