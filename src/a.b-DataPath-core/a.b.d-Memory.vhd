-- MEM Stage top-level entity
library IEEE;
use IEEE.std_logic_1164.all;
use work.constants.all;
use work.instruction_set.all;

entity Memory is
	port( CLK           : in std_logic; 
		  RST           : in std_logic;
		  MEM_EN_IN     : in std_logic; -- coming from Control Unit
		  DRAM_R_IN     : in std_logic; -- coming from Control Unit
		  DRAM_W_IN     : in std_logic; -- coming from Control Unit
		  PC_SEL        : in std_logic_vector(1 downto 0); -- PC MUX Selection, from EX stage
		  NPC_IN        : in std_logic_vector(NBIT-1 downto 0); -- NPC, from Fetch stage
		  NPC_ABS       : in std_logic_vector(NBIT-1 downto 0); -- Absolute NPC (for JALR/JR)
		  NPC_REL       : in std_logic_vector(NBIT-1 downto 0); -- Relative NPC (for J/JAL/BEQZ/BNEZ)
		  ALU_RES_IN    : in std_logic_vector(NBIT-1 downto 0); -- ALUREG output, from EX stage
		  B_IN          : in std_logic_vector(NBIT-1 downto 0); -- Data for store, from EX stage
		  ADD_WR_IN     : in std_logic_vector(NBIT_ADD-1 downto 0); -- Address for WB, from EX stage
		  DRAM_DATA_IN  : in std_logic_vector(NBIT-1 downto 0); -- Load data from DRAM
		  PC_OUT        : out std_logic_vector(NBIT-1 downto 0); -- PC value, to fetch stage
		  MEM_EN_OUT    : out std_logic; -- control signals to DRAM
		  DRAM_R_OUT    : out std_logic; -- control signals to DRAM
		  DRAM_W_OUT    : out std_logic; -- control signals to DRAM
		  DRAM_ADDR_OUT : out std_logic_vector(NBIT-1 downto 0); -- ALU output sent to DRAM
		  DRAM_DATA_OUT : out std_logic_vector(NBIT-1 downto 0); -- Data for store, to DRAM
		  DATA_OUT      : out std_logic_vector(NBIT-1 downto 0); -- Output of DRAM, to WB stage
		  ALU_RES_OUT   : out std_logic_vector(NBIT-1 downto 0); -- Data computed in ALU, to WB stage
		  OP_MEM        : out std_logic_vector(NBIT-1 downto 0); -- Operand sent back to EX stage for forwarding
		  ADD_WR_OUT    : out std_logic_vector(NBIT_ADD-1 downto 0)); -- Address for WB
end Memory;

architecture struct of Memory is

-- Component declarations
component regn is
	generic(N : integer);
	port( DIN  : in std_logic_vector(N-1 downto 0);
		  CLK  : in std_logic;
		  EN   : in std_logic;
		  RST  : in std_logic;
		  DOUT : out std_logic_vector(N-1 downto 0));
end component;

component mux41 is
	generic(NBIT : integer);
	port( A : in std_logic_vector(NBIT-1 downto 0);
		  B : in std_logic_vector(NBIT-1 downto 0);
		  C : in std_logic_vector(NBIT-1 downto 0);
		  D : in std_logic_vector(NBIT-1 downto 0);
		  S : in std_logic_vector(1 downto 0);
		  Z : out std_logic_vector(NBIT-1 downto 0));
end component;

begin
	
	DRAM_DATA_OUT <= B_IN; -- send data to be stored to DRAM
	DRAM_ADDR_OUT <= ALU_RES_IN; -- data computed in ALU is store address for DRAM (or Jump PC)
	OP_MEM <= ALU_RES_IN; -- Used for possible forwarding in EX stage
	MEM_EN_OUT <= MEM_EN_IN; -- control signals sent to DRAM
	DRAM_R_OUT <= DRAM_R_IN;
	DRAM_W_OUT <= DRAM_W_IN;
	
	LMD: regn generic map(N => NBIT)
		port map(DIN => DRAM_DATA_IN, CLK => CLK, EN => MEM_EN_IN, RST => RST, DOUT => DATA_OUT);
		
	reg0 : regn generic map(N => NBIT_ADD)
		port map(DIN => ADD_WR_IN, CLK => CLK, EN => MEM_EN_IN, RST => RST, DOUT => ADD_WR_OUT);
	
	reg1 : regn generic map(N => NBIT)
		port map(DIN => ALU_RES_IN, CLK => CLK, EN => MEM_EN_IN, RST => RST, DOUT => ALU_RES_OUT);
		
	PCsel: mux41 generic map(NBIT => NBIT)
		port map( A => NPC_IN, B => NPC_REL, C => NPC_ABS, D => (others => '0'), S => PC_SEL, Z => PC_OUT);

end struct;