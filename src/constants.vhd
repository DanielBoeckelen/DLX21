library IEEE;
use IEEE.std_logic_1164.all;

package constants is
	constant NBIT : integer := 32; -- Instructions, data, Program Counter are on 32 bits
	constant NBIT_ADD : integer := 5; -- Address for RS1, RS2 and RD
        constant NBIT_DATA: integer := 32;
	constant NBIT_PER_BLOCK: integer := 4; -- For P4 adder
    	constant NBLOCKS : integer := 8; -- For P4 adder
        constant CW_SIZE : integer := 15; --For CU
        constant OP_CODE_SIZE : integer := 6; --For CU
        --constant FUNC_SIZE : integer := 11; --(already declared in "001-instruction_set.vhd")
        constant MICROCODE_MEM_SIZE : integer := 11; --For CU
	--constant MEM_size : integer := 1024; -- Memories 1024x32 bit wide = 4kB, both data and instruction
	-- File paths for the Instruction and Data memories
	--constant path_IRAM : string := "../asm/IRAM.text";
	--constant path_DRAM : string := "../asm/DRAM.data"; 
	-- Base addresses for data and instruction segments
	--constant BASE_ADDR_text : std_logic_vector(NBIT-1 downto 0) := x"00400000";
	--constant BASE_ADDR_data : std_logic_vector(NBIT-1 downto 0) := x"10010000";

	type aluOp is (
		NOP, ADDS, SUBS, ANDS, ORS, XORS, SLLS, SRLS, BEQZS, BNEZS, SGES, SLES, NEQS
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
