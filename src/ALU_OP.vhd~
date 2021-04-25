library IEEE;
use IEEE.std_logic_1164.all;

package ALU_OPs is
	constant ALU_OPC_SIZE : integer := 4; -- Size of the ALU Opcode

	-- ADD, ADDI, AUIPC, LW, SW, JAL are all additions: they can be grouped in a single ADD functions (only origin of addends changes)
	constant FUNCT_SRAI : std_logic_vector(ALU_OPC_SIZE-1 downto 0) := "0000";
	constant FUNCT_ADD  : std_logic_vector(ALU_OPC_SIZE-1 downto 0) := "0001";
	constant FUNCT_ANDI : std_logic_vector(ALU_OPC_SIZE-1 downto 0) := "0010";
	constant FUNCT_XOR  : std_logic_vector(ALU_OPC_SIZE-1 downto 0) := "0011"; -- Also used for BEQ: XOR result is 0 if all bits of RS1 and RS2 are equal
	constant FUNCT_SLT  : std_logic_vector(ALU_OPC_SIZE-1 downto 0) := "0100";
end package;
