library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.constants.all;
use work.instruction_set.all;

entity Fetch is
	port( CLK          : in std_logic; 
		  RST	       : in std_logic;
		  --IR_LATCH_EN  : in std_logic;
		  --NPC_LATCH_EN : in std_logic;
		  ZERO_FLAG    : in std_logic; -- Zero Flag coming from Execute stage, used as flush if branch taken
		  PC_EXT       : in std_logic_vector(NBIT-1 downto 0); -- Coming from memory stage
		  INS_IN       : in std_logic_vector(NBIT-1 downto 0); -- Instruction coming from the IRAM
		  Bubble_in    : in std_logic; -- Bubble signal from HazardDetection, for stall management
		  HDU_INS_IN   : in std_logic_vector(NBIT-1 downto 0); -- Current instruction, possibly causing Load-Use Hazard
		  HDU_PC_IN    : in std_logic_vector(NBIT-1 downto 0); -- PC of the current instruction, possibly causing the Load-Use Hazard
		  HDU_NPC_IN   : in std_logic_vector(NBIT-1 downto 0); -- NPC, of the instruction after the possible the Load-Use Hazard
		  PC_OUT       : out std_logic_vector(NBIT-1 downto 0); -- Current PC output, used for hazard detection
		  ADDR_OUT     : out std_logic_vector(NBIT-1 downto 0); -- To Instruction memory
		  NPC_OUT      : out std_logic_vector(NBIT-1 downto 0); -- Next program counter
		  INS_OUT      : out std_logic_vector(NBIT-1 downto 0)); -- Instruction to decode stage and CU
end Fetch;

architecture struct of Fetch is

-- Component declarations

component regn is
	generic(N : integer);
	port( DIN  : in std_logic_vector(N-1 downto 0);
		  CLK  : in std_logic;
		  EN   : in std_logic;
		  RST  : in std_logic;
		  DOUT : out std_logic_vector(N-1 downto 0));
end component;

component mux21 is
	generic(NBIT : integer);
	port( A : in std_logic_vector(NBIT-1 downto 0);
		  B : in std_logic_vector(NBIT-1 downto 0);
		  S : in std_logic;
		  Z : out std_logic_vector(NBIT-1 downto 0));
end component;

-- Signal declarations
signal sig_RST : std_logic;
signal NPC, sig_PC, sig_NPC, PC_MUX_OUT, sig_INS : std_logic_vector(NBIT-1 downto 0);

begin

	sig_RST <= (not(ZERO_FLAG)) and RST; -- If a branch is taken in the EX stage, reset the registers containing instructions fetched after the branch
	ADDR_OUT <= sig_PC;
	NPC_OUT <= sig_PC + 4;
	
	NPC_or_NPC_HDU : mux21 generic map(NBIT => NBIT)
		port map(A => PC_EXT, B => HDU_NPC_IN, S => Bubble_in, Z => sig_NPC); -- Mux taking either the external NPC (NPC or Branch Target) or the NPC coming from the Hazard Detection
		
	PC_or_PC_HDU : mux21 generic map(NBIT => NBIT)
		port map(A => sig_PC, B => HDU_PC_IN, S => Bubble_in, Z => PC_MUX_OUT);	
		
	INS_or_HDU_INS : mux21 generic map(NBIT => NBIT)
		port map(A => INS_IN, B => HDU_INS_IN, S => Bubble_in, Z => sig_INS);
	
	PC: regn generic map(N => NBIT)
		port map(DIN => sig_NPC, CLK => CLK, EN => '1', RST => RST, DOUT => sig_PC); -- Program Counter
	
	PC_reg: regn generic map(N => NBIT)
		port map(DIN => PC_MUX_OUT, CLK => CLK, EN => '1', RST => sig_RST, DOUT => PC_OUT);
	
	IR : regn generic map(N => NBIT)
		port map(DIN => sig_INS, CLK => CLK, EN => '1', RST => sig_RST, DOUT => INS_OUT);
				
end struct;
