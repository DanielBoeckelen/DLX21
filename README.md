# DLX21

-----------

Progress as of 21/08/21:

Solved final synthesis problems for the basic version; completed Innovus Place&Route. After this we could consider the basic version as working, although it would still need
some adjustments like comments etc...
We will then start working on the PRO instruction set.

-----------

Progress as of 10/08/21:

The Synthesis error of the shifter (about the constants) has been solved.

Error: extra positional option ' ' (CMD-012), is still not corrected (from surfing the web, we know that this error could rise when there is a space in a file name), but we don't find any file with blanck spaces.

The extended error info (for CMD-012) says:

can't unset "project99" : no such variable
    while executing
"unset project99"

-----------

Progress as of 09/08/21:

Problems with inferred latches in synthesis have been solved. Next steps: make sure that the change just mentioned did not cause errors in the programs already tested. Also,
there is still one Synthesis error to be solved at line 22 of shifter.vhd: for some reason, it asks for a constant in the process sensitivity list.

-----------

Progress as of 31/07/21:

"basic_test.asm" has been tested and works as intended. It tests all arithmetic instructions that hadn't been tested yet. The NOP has always been working properly, but it is now usable
as an independent instruction (this is required by the instruction set), whereas before it was only used to idle the ALU and to stall the pipeline.
An issue has been fixed with the shifter, which would cause a wrong value when shifting by zero.

Next step: running the synthesis to avoid inferred latches.

-----------

Progress as of 14/07/21:

"Branch2.asm" has been tested and works as intended. It is very similar to Branch.asm, but uses a loop with BEQZ and JAL. Two issues have been solved:
- JAL would set "sig_rst" to '0', which would cause BEQZ to be ignored and, as a result, produce a wrong address. This has been fixed by inserting sig_rst also in
"Branch_Cond_Unit.vhd": in this way, if RST = '0', PC_SEL and ZERO flag are reset.
- There was a bug at the end of the loop, where the value "4" would be produced by JAL and stored in R0. This has been fixed by changing the write condition in the register file:
the writeback signal must be '1', and the write address must not be zero.

Next step: verify remaining instructions, with different loops and implementations, before trying to use the synthesizer.

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
