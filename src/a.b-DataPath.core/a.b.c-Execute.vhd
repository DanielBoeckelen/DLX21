-- EX Stage top-level entity
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use work.constants.all;
use work.instruction_set.all;

entity Execute is
	port( CLK           : in std_logic; 
		  RST           : in std_logic;
		  MUX_A_SEL     : in std_logic; -- coming from Control Unit
		  MUX_B_SEL     : in std_logic_vector(1 downto 0); -- coming from Control Unit
		  ALU_OPC       : in aluOp; -- coming from Control Unit
		  ALU_OUTREG_EN : in std_logic; -- coming from Control Unit
		  JUMP_TYPE     : in std_logic_vector(1 downto 0); -- coming from CU
		  PC_IN         : in std_logic_vector(NBIT-1 downto 0); -- From ID stage
		  A_IN          : in std_logic_vector(NBIT-1 downto 0); -- From ID stage
		  B_IN          : in std_logic_vector(NBIT-1 downto 0); -- From ID stage
		  IMM_IN        : in std_logic_vector(NBIT-1 downto 0); -- From ID stage
		  ADD_WR_IN     : in std_logic_vector(NBIT_ADD-1 downto 0); -- From ID stage
		  ADD_RS1_IN    : in std_logic_vector(NBIT_ADD-1 downto 0); -- From ID stage, for forwarding
		  ADD_RS2_IN    : in std_logic_vector(NBIT_ADD-1 downto 0); -- From ID stage, for forwarding
		  ADD_WR_MEM	: in std_logic_vector(NBIT_ADD-1 downto 0); -- MEM stage write address, for forwarding
		  ADD_WR_WB     : in std_logic_vector(NBIT_ADD-1 downto 0); -- WB stage write address, for forwarding
		  RF_WE_MEM     : in std_logic; -- RF Write signal for instruction currently in MEM stage
		  RF_WE_WB      : in std_logic; -- RF Write signal for instruction currently in WB stage
		  OP_MEM		: in std_logic_vector(NBIT-1 downto 0); -- Operand in MEM stage
		  OP_WB		    : in std_logic_vector(NBIT-1 downto 0); -- Operand in WB stage
		  PC_SEL        : out std_logic_vector(1 downto 0); -- PC MUX Selection signal, to MEM stage
		  ZERO_FLAG     : out std_logic; -- Used for Flush in Fetch and Decode
		  NPC_ABS       : out std_logic_vector(NBIT-1 downto 0); -- Absolute NPC (for JALR/JR)
		  NPC_REL       : out std_logic_vector(NBIT-1 downto 0); -- Relative NPC (for J/JAL/BEQZ/BNEZ)
		  ALU_RES       : out std_logic_vector(NBIT-1 downto 0); -- ALUREG output, to MEM stage
		  B_OUT         : out std_logic_vector(NBIT-1 downto 0);
		  ADD_WR_OUT    : out std_logic_vector(NBIT_ADD-1 downto 0)); -- RF address for writeback, to MEM stage
end Execute;

architecture struct of Execute is

-- Component declarations
component Branch_Cond_Unit is
	generic(NBIT : integer);
	port( RST 	    : in std_logic;
		  A         : in std_logic_vector(NBIT-1 downto 0);
		  ALU_OPC   : in aluOp; -- coming from Control Unit
		  JUMP_TYPE : in std_logic_vector(1 downto 0); -- coming from Control Unit
		  PC_SEL    : out std_logic_vector(1 downto 0); -- PC MUX Selection signal, to MEM stage
		  ZERO      : out std_logic); -- Used for Flush in Fetch and Decode
end component;

component ALU is
	generic(NBIT : integer);
	port( OP1     : in std_logic_vector(NBIT-1 downto 0); -- Coming from mux1, selecting NPC or A
		  OP2     : in std_logic_vector(NBIT-1 downto 0); -- Coming from mux2, selecting IMM or B
		  ALU_OPC : in aluOp; -- coming from Control Unit
		  ALU_RES : out std_logic_vector(NBIT-1 downto 0)); -- going to EX/MEM Pipeline reg
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

component mux41 is
	generic(NBIT : integer);
	port( A : in std_logic_vector(NBIT-1 downto 0);
		  B : in std_logic_vector(NBIT-1 downto 0);
		  C : in std_logic_vector(NBIT-1 downto 0);
		  D : in std_logic_vector(NBIT-1 downto 0);
		  S : in std_logic_vector(1 downto 0);
		  Z : out std_logic_vector(NBIT-1 downto 0));
end component;

component regn is
	generic(N : integer);
	port( DIN  : in std_logic_vector(N-1 downto 0);
		  CLK  : in std_logic;
		  EN   : in std_logic;
		  RST  : in std_logic;
		  DOUT : out std_logic_vector(N-1 downto 0));
end component;

component FWD_Unit is
	port ( RST 	      : in std_logic;
		   ADD_RS1    : in std_logic_vector(NBIT_ADD-1 downto 0); -- From ID stage, for forwarding
		   ADD_RS2    : in std_logic_vector(NBIT_ADD-1 downto 0); -- From ID stage, for forwarding
		   ADD_WR_MEM : in std_logic_vector(NBIT_ADD-1 downto 0); -- MEM stage write address, for forwarding
		   ADD_WR_WB  : in std_logic_vector(NBIT_ADD-1 downto 0); -- WB stage write address, for forwarding
		   RF_WE_MEM  : in std_logic; -- RF Write signal for instruction currently in MEM stage
		   RF_WE_WB   : in std_logic; -- RF Write signal for instruction currently in WB stage
		   FWDA 	  : out std_logic_vector(1 downto 0); -- 00 OP1 from RF, 10 OP1 forwarded from MEM, 01 OP1 from WB
		   FWDB 	  : out std_logic_vector(1 downto 0));  -- 00 OP2 from RF, 10 OP2 forwarded from MEM, 01 OP2 from WB
end component;

-- Signal declarations
signal sig_ZERO_FLAG, reg_ZERO_FLAG, sig_RST : std_logic;
signal sig_OP1, sig_OP2, sig_ALU_RES, OP1_FW, OP2_FW, sig_NPC_ABS, sig_NPC_REL : std_logic_vector(NBIT-1 downto 0);
signal FWDA, FWDB, sig_PC_SEL : std_logic_vector(1 downto 0);

begin
	
	sig_RST <= (not(reg_ZERO_FLAG)) and RST; -- If a branch is taken in the EX stage, reset the registers containing instructions fetched after the branch
	
	sig_NPC_ABS <= OP1_FW; -- Absolute jump (JALR/JR): PC <- regA
	
	sig_NPC_REL <= PC_IN + 4 + IMM_IN; -- Relative jump (J/JAL/BEQZ/BNEZ): PC <- PC + IMM
		
	Branch_Cond : Branch_Cond_Unit generic map(NBIT => NBIT)
		port map(RST => sig_RST, A => OP1_FW, ALU_OPC => ALU_OPC, JUMP_TYPE => JUMP_TYPE, PC_SEL => sig_PC_SEL, ZERO => sig_ZERO_FLAG);
		
	ff0 : ff port map(D => sig_ZERO_FLAG, CLK => CLK, EN => '1', RST => RST, Q => reg_ZERO_FLAG);

	ZERO_FLAG <= reg_ZERO_FLAG;
	
	reg0 : regn generic map(N => 2)
		port map(DIN => sig_PC_SEL, CLK => CLK, EN => '1', RST => RST, DOUT => PC_SEL); -- The PC_SEL must always reach the PC MUX in the Memory stage, so it's always enabled
	
	FWD: FWD_Unit port map(RST => sig_RST, ADD_RS1 => ADD_RS1_IN, ADD_RS2 => ADD_RS2_IN, ADD_WR_MEM => ADD_WR_MEM, ADD_WR_WB => ADD_WR_WB,
		RF_WE_MEM => RF_WE_MEM, RF_WE_WB => RF_WE_WB, FWDA => FWDA, FWDB => FWDB); -- Generation of mux selection signals for forwarding multiplexers
	
	FW1: mux41 generic map(NBIT => NBIT)
		port map( A => A_IN, B => OP_WB, C => OP_MEM, D => A_IN, S => FWDA, Z => OP1_FW);
	
	FW2: mux41 generic map(NBIT => NBIT)
		port map( A => B_IN, B => OP_WB, C => OP_MEM, D => B_IN, S => FWDB, Z => OP2_FW);
	
	muxA : mux21 generic map(NBIT => NBIT)
		port map(A => OP1_FW, B => PC_IN, S => MUX_A_SEL, Z => sig_OP1);
		
	muxB : mux41 generic map(NBIT => NBIT)
		port map( A => OP2_FW, B => IMM_IN, C => std_logic_vector(to_unsigned(4, sig_OP2'length)), D => (others => '0'), S => MUX_B_SEL, Z => sig_OP2); -- 4 is used to do R31 <= PC + 4 in JAL/JALR
		
	alu0 : ALU generic map(NBIT => NBIT)
		port map(OP1 => sig_OP1, OP2 => sig_OP2, ALU_OPC => ALU_OPC, ALU_RES => sig_ALU_RES);
	
	alureg : regn generic map(N => NBIT)
		port map(DIN => sig_ALU_RES, CLK => CLK, EN => ALU_OUTREG_EN, RST => RST, DOUT => ALU_RES);
		
	B_reg : regn generic map(N => NBIT)
		port map(DIN => OP2_FW, CLK => CLK, EN => ALU_OUTREG_EN, RST => RST, DOUT => B_OUT);
	
	ADD_WR_reg : regn generic map(N => NBIT_ADD)
		port map(DIN => ADD_WR_IN, CLK => CLK, EN => '1', RST => RST, DOUT => ADD_WR_OUT);
		
	NPC_ABS_reg : regn generic map(N => NBIT)
		port map(DIN => sig_NPC_ABS, CLK => CLK, EN => ALU_OUTREG_EN, RST => RST, DOUT => NPC_ABS);
	
	NPC_REL_reg : regn generic map(N => NBIT)
		port map(DIN => sig_NPC_REL, CLK => CLK, EN => ALU_OUTREG_EN, RST => RST, DOUT => NPC_REL);

end struct;
