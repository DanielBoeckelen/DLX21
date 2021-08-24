library IEEE;
use IEEE.std_logic_1164.all;

package constants is
	constant NBIT : integer := 32; -- Instructions, data, Program Counter are on 32 bits
	constant NBIT_ADD : integer := 5; -- Address for RS1, RS2 and RD
    constant NBIT_DATA: integer := 32;
	constant NBIT_PER_BLOCK: integer := 4; -- For P4 adder
   	constant NBLOCKS : integer := 8; -- For P4 adder
    constant CW_SIZE : integer := 15; -- For CU
    constant MICROCODE_MEM_SIZE : integer := 11; -- For CU
	constant MEM_size : integer := 1024; -- Memories 1024x32 bit wide = 4kB, both data and instruction (before it was 1024)
	-- File paths for the Instruction and Data memories
	--constant path_IRAM : string := "../asm/IRAM.text";
	--constant path_DRAM : string := "../asm/DRAM.data"; 

	type aluOp is (
		NOP, ADDS, ADDUS, SUBS, SUBUS, MULTS, ANDS, ORS, XORS, SLLS, SRLS, SRAS, BEQZS, BNEZS, SGES, SGEUS, SGTS, SGTUS, SLES, SLTS, SLTUS, SEQS, NEQS -- LB, LBU, LHI, LHU, SB
	);

    type shifter_OP is (
      NOP, Logic_Right, Logic_Arith_Left, Arith_Right
    );

    type comparator_OP is (
      NOP, E, NE, G, GE, L, LE
    );

    type RF_OP is (
      NOP, reading, writing, resetting
    );

end package;
