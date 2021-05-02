-- ID Stage top-level entity
library IEEE;
use IEEE.std_logic_1164.all;
use work.constants.all;
use work.instruction_set.all;

entity Decode is
	port( CLK          : in std_logic; 
		  RST          : in std_logic;
		  REG_LATCH_EN : in std_logic; -- Enables the register file and the pipeline registers
		  RD1		   : in std_logic; -- Enables the read port 1 of the register file
		  RD2		   : in std_logic; -- Enables the read port 2 of the register file
		  RF_WE		   : in std_logic; -- Enables the write port of the register file
		  ZERO_FLAG    : in std_logic; -- Zero Flag coming from Execute stage, used as flush if branch taken
		  PC_IN        : in std_logic_vector(NBIT-1 downto 0); -- PC coming from the Fetch stage
		  INS_IN	   : in std_logic_vector(NBIT-1 downto 0); -- Instruction coming from the IR in the Fetch stage
		  ADD_WR       : in std_logic_vector(NBIT_ADD-1 downto 0); -- Address of the destination register, from WB stage
		  DATA_WR_IN   : in std_logic_vector(NBIT-1 downto 0); -- Data to be written in the RF coming from the WB stage
		  PC_OUT       : out std_logic_vector(NBIT-1 downto 0); -- PC to Execute stage
		  A_OUT        : out std_logic_vector(NBIT-1 downto 0); -- First operand output
		  B_OUT        : out std_logic_vector(NBIT-1 downto 0); -- Second operand output
		  IMM_OUT      : out std_logic_vector(NBIT-1 downto 0); -- Immediate register output
		  ADD_RS1_HDU  : out std_logic_vector(NBIT_ADD-1 downto 0); -- RS1 address for Hazard Detection
		  ADD_RS2_HDU  : out std_logic_vector(NBIT_ADD-1 downto 0); -- RS2 address for Hazard Detection
		  ADD_WR_OUT   : out std_logic_vector(NBIT_ADD-1 downto 0); -- ADD_WR output, will be used for writeback
		  ADD_RS1_OUT  : out std_logic_vector(NBIT_ADD-1 downto 0); -- RS1 address for forwarding
		  ADD_RS2_OUT  : out std_logic_vector(NBIT_ADD-1 downto 0)); -- RS2 address for forwarding   
end Decode;

architecture struct of Decode is

-- Component declarations
component regn is
	generic(N : integer);
	port( DIN  : in std_logic_vector(N-1 downto 0);
		  CLK  : in std_logic; 
		  EN   : in std_logic;
		  RST  : in std_logic;
		  DOUT : out std_logic_vector(N-1 downto 0));
end component;

component instruction_type is
	port( INST_IN : in std_logic_vector(NBIT-1 downto 0); -- Instruction from IR
		  Rtype   : out std_logic;
		  Itype   : out std_logic;
		  Jtype   : out std_logic);
end component;

component instruction_decomposition is
	port( INST_IN : in std_logic_vector(NBIT-1 downto 0); -- Instruction from IR
		  Rtype   : in std_logic;
		  Itype   : in std_logic;
		  Jtype   : in std_logic;
		  ADD_RS1 : out std_logic_vector(NBIT_ADD-1 downto 0); -- sent to regfile
		  ADD_RS2 : out std_logic_vector(NBIT_ADD-1 downto 0); -- sent to regfile
		  ADD_WR  : out std_logic_vector(NBIT_ADD-1 downto 0); -- sent to intermediate reg in ID stage, to be used in writeback
		  IMM     : out std_logic_vector(NBIT-1 downto 0)); -- sent to intermediate reg in ID stage
end component;

component register_file is
 generic( NBIT_ADD: integer;
		  NBIT_DATA: integer);
 port ( CLK: 		IN std_logic;
        RESET: 	    IN std_logic;
	 	ENABLE: 	IN std_logic;
	 	RD1: 		IN std_logic;
	 	RD2: 		IN std_logic;
	 	WR: 		IN std_logic;
	 	ADD_WR: 	IN std_logic_vector(NBIT_ADD-1 downto 0);
	 	ADD_RD1: 	IN std_logic_vector(NBIT_ADD-1 downto 0);
	 	ADD_RD2: 	IN std_logic_vector(NBIT_ADD-1 downto 0);
	 	DATAIN: 	IN std_logic_vector(NBIT_DATA-1 downto 0);
        OUT1: 		OUT std_logic_vector(NBIT_DATA-1 downto 0);
	 	OUT2: 		OUT std_logic_vector(NBIT_DATA-1 downto 0));
end component;



-- Signal declarations
signal sig_Rtype, sig_Itype, sig_Jtype, sig_RST:  std_logic;
signal sig_ADD_RS1, sig_ADD_RS2, sig_ADD_WR, ADD_RD_reg, ADD_RS1_reg, ADD_RS2_reg : std_logic_vector(NBIT_ADD-1 downto 0);		
signal sig_IMM, IMM_reg : std_logic_vector(NBIT-1 downto 0);
--signal sig_A, sig_B : std_logic_vector(NBIT-1 downto 0);

begin
	
	sig_RST <= (not(ZERO_FLAG)) and RST; -- If a branch is taken in the EX stage, reset the registers containing instructions fetched after the branch
	
	ins_type : instruction_type port map( INST_IN => INS_IN,
						Rtype => sig_Rtype,
						Itype => sig_Itype,
						Jtype => sig_Jtype);

	ins_dec : instruction_decomposition port map( INST_IN => INS_IN,
							Rtype => sig_Rtype,
							Itype => sig_Itype,
							Jtype => sig_Jtype,				  	
							ADD_RS1 => sig_ADD_RS1,
							ADD_RS2 => sig_ADD_RS2,
							ADD_WR => sig_ADD_WR,
							IMM => sig_IMM);
							
	ADD_RS1_HDU <= sig_ADD_RS1;
	ADD_RS2_HDU <= sig_ADD_RS2;

	regPC : regn generic map(N => NBIT)
		port map(DIN => PC_IN, CLK => CLK, EN => REG_LATCH_EN, RST => sig_RST, DOUT => PC_OUT);
		
	--regA : regn generic map(N => NBIT)
		--port map(DIN => sig_A, CLK => CLK, EN => REG_LATCH_EN, RST => RST, DOUT => A_OUT);
	
	--regB : regn generic map(N => NBIT)
		--port map(DIN => sig_B, CLK => CLK, EN => REG_LATCH_EN, RST => RST, DOUT => B_OUT);
	
	regIMM : regn generic map(N => NBIT)
		port map(DIN => sig_IMM, CLK => CLK, EN => REG_LATCH_EN, RST => sig_RST, DOUT => IMM_OUT);
		
	regWR : regn generic map(N => NBIT_ADD)
		port map(DIN => sig_ADD_WR, CLK => CLK, EN => REG_LATCH_EN, RST => sig_RST, DOUT => ADD_WR_OUT);
		
	regRS1 : regn generic map(N => NBIT_ADD)
		port map(DIN => sig_ADD_RS1, CLK => CLK, EN => REG_LATCH_EN, RST => sig_RST, DOUT => ADD_RS1_OUT);
	
	regRS2 : regn generic map(N => NBIT_ADD)
		port map(DIN => sig_ADD_RS2, CLK => CLK, EN => REG_LATCH_EN, RST => sig_RST, DOUT => ADD_RS2_OUT);

	rf :register_file generic map(NBIT_ADD => NBIT_ADD, NBIT_DATA => NBIT)
		port map(CLK => CLK,    
		RESET => RST,
		ENABLE => REG_LATCH_EN,
		RD1 => RD1,   
		RD2 => RD2,
		WR => RF_WE,   
		ADD_WR => ADD_WR,
		ADD_RD1 => sig_ADD_RS1,
		ADD_RD2 => sig_ADD_RS2,
		DATAIN => DATA_WR_IN,
		OUT1 => A_OUT, 
		OUT2 => B_OUT);
		
end struct;