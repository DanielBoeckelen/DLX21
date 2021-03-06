-- ID Stage top-level entity
library IEEE;
use IEEE.std_logic_1164.all;
use work.constants.all;
use work.instruction_set.all;

entity Decode is
	port( CLK          : in std_logic; 
		  RST          : in std_logic;
		  Bubble       : in std_logic;
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

component ff is
	port( D   : in std_logic;
		  CLK : in std_logic;
		  EN  : in std_logic;
		  RST : in std_logic;
		  Q   : out std_logic);
end component;

component mux21 is
	generic(NBIT : integer);
	port( A : in std_logic_vector(NBIT-1 downto 0);
		  B : in std_logic_vector(NBIT-1 downto 0);
		  S : in std_logic;
		  Z : out std_logic_vector(NBIT-1 downto 0));
end component;

component instruction_type is
	port( INST_IN : in std_logic_vector(NBIT-1 downto 0); -- Instruction from IR
		  Rtype   : out std_logic;
		  Itype   : out std_logic;
		  Jtype   : out std_logic);
end component;

component instruction_decomposition is
	port( INST_IN    : in std_logic_vector(NBIT-1 downto 0); -- Instruction from IR
		  Rtype      : in std_logic;
		  Itype      : in std_logic;
		  Jtype      : in std_logic;
		  ADD_RS1    : out std_logic_vector(NBIT_ADD-1 downto 0); -- sent to regfile
		  ADD_RS2    : out std_logic_vector(NBIT_ADD-1 downto 0); -- sent to regfile
		  ADD_WR     : out std_logic_vector(NBIT_ADD-1 downto 0); -- sent to intermediate reg in ID stage, to be used in writeback
		  IMM        : out std_logic_vector(NBIT-1 downto 0); -- sent to intermediate reg in ID stage
		  RD1		 : out std_logic; -- Enables the read port 1 of the register file
		  RD2		 : out std_logic); -- Enables the read port 2 of the register file
end component;

component register_file is
 generic( NBIT_ADD: integer;
		  NBIT_DATA: integer);
 port ( CLK: 		IN std_logic;
        RST: 	    IN std_logic;
	 	ENABLE: 	IN std_logic;
	 	RD1: 		IN std_logic;
	 	RD2: 		IN std_logic;
	 	WR: 		IN std_logic;
	 	ADD_WR: 	IN std_logic_vector(NBIT_ADD-1 downto 0);
	 	ADD_RS1: 	IN std_logic_vector(NBIT_ADD-1 downto 0);
	 	ADD_RS2: 	IN std_logic_vector(NBIT_ADD-1 downto 0);
	 	DATAIN: 	IN std_logic_vector(NBIT_DATA-1 downto 0);
        OUT1: 		OUT std_logic_vector(NBIT_DATA-1 downto 0);
	 	OUT2: 		OUT std_logic_vector(NBIT_DATA-1 downto 0));
end component;



-- Signal declarations
signal sig_Rtype, sig_Itype, sig_Jtype, sig_RST, RD1, RD2:  std_logic;
signal sig_ADD_RS1, sig_ADD_RS2, sig_ADD_WR, sig_ADD_RS1HAZ, sig_ADD_RS2HAZ, sig_ADD_WRHAZ : std_logic_vector(NBIT_ADD-1 downto 0);		
signal sig_IMM : std_logic_vector(NBIT-1 downto 0);

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
							IMM => sig_IMM,
							RD1 => RD1,
							RD2 => RD2);
							
	ADD_RS1_HDU <= sig_ADD_RS1; -- Current instruction source addresses are sent to the Hazard Detection Unit
	ADD_RS2_HDU <= sig_ADD_RS2;

	regPC : regn generic map(N => NBIT)
		port map(DIN => PC_IN, CLK => CLK, EN => '1', RST => sig_RST, DOUT => PC_OUT);
	
	regIMM : regn generic map(N => NBIT)
		port map(DIN => sig_IMM, CLK => CLK, EN => '1', RST => sig_RST, DOUT => IMM_OUT);

	muxRS1 : mux21 generic map(NBIT => NBIT_ADD)
		port map(A => sig_ADD_RS1, B => (others => '0'), S => Bubble, Z => sig_ADD_RS1HAZ); -- If Bubble is asserted, send 0 as address to avoid unwanted writebacks

	muxRS2 : mux21 generic map(NBIT => NBIT_ADD)
		port map(A => sig_ADD_RS2, B => (others => '0'), S => Bubble, Z => sig_ADD_RS2HAZ); -- If Bubble is asserted, send 0 as address to avoid unwanted writebacks

	muxWR : mux21 generic map(NBIT => NBIT_ADD)
		port map(A => sig_ADD_WR, B => (others => '0'), S => Bubble, Z => sig_ADD_WRHAZ); -- If Bubble is asserted, send 0 as address to avoid unwanted writebacks
		
	regWR : regn generic map(N => NBIT_ADD)
		port map(DIN => sig_ADD_WRHAZ, CLK => CLK, EN => '1', RST => sig_RST, DOUT => ADD_WR_OUT);
		
	regRS1 : regn generic map(N => NBIT_ADD)
		port map(DIN => sig_ADD_RS1HAZ, CLK => CLK, EN => '1', RST => sig_RST, DOUT => ADD_RS1_OUT);
	
	regRS2 : regn generic map(N => NBIT_ADD)
		port map(DIN => sig_ADD_RS2HAZ, CLK => CLK, EN => '1', RST => sig_RST, DOUT => ADD_RS2_OUT);

	rf :register_file generic map(NBIT_ADD => NBIT_ADD, NBIT_DATA => NBIT)
		port map(CLK => CLK,    
		RST => RST,
		ENABLE => '1',
		RD1 => RD1,   
		RD2 => RD2,
		WR => RF_WE,   
		ADD_WR => ADD_WR,
		ADD_RS1 => sig_ADD_RS1,
		ADD_RS2 => sig_ADD_RS2,
		DATAIN => DATA_WR_IN,
		OUT1 => A_OUT, 
		OUT2 => B_OUT);
		
end struct;
