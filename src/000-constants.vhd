library IEEE;
use IEEE.std_logic_1164.all;

package constants is
	constant NBIT : integer := 32; -- Instructions, data, Program Counter are on 32 bits
	constant NBIT_ADD : integer := 5; -- Address bits for RS1, RS2 and RD
    constant NBIT_DATA: integer := 32;
	constant NBIT_PER_BLOCK: integer := 4; -- For P4 adder
   	constant NBLOCKS : integer := 8; -- For P4 adder
    constant CW_SIZE : integer := 14; -- For CU
    constant MICROCODE_MEM_SIZE : integer := 15; -- For CU, size of the memory array containing the CWs
	constant MEM_size : integer := 1024; -- DRAM and IRAM sizes

	type aluOp is ( -- Operation types, used by the ALU
		NOP, ADDS, ADDUS, SUBS, SUBUS, MULTS, ANDS, ORS, XORS, SLLS, SRLS, SRAS, BEQZS, BNEZS, SGES, SGEUS, SGTS, SGTUS, SLES, SLTS, SLTUS, SEQS, NEQS, LHIS
	);

end package;
