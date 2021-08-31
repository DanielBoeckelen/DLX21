-- Datapath top-level entity
library IEEE;
use IEEE.std_logic_1164.all;
use work.constants.all;
use work.instruction_set.all;

entity Datapath is
	port( CLK     : in std_logic; 
		  RST	  : in std_logic; -- Reset signal, active low
		  INS_IN  : in std_logic_vector(NBIT-1 downto 0); -- from instruction memory
		  DATA_IN : in std_logic_vector(NBIT-1 downto 0); -- from data memory
		  -- Fetch stage control signals ?
		  --IR_LATCH_EN  : in std_logic;
		  --NPC_LATCH_EN : in std_logic;
		  -- Decode CU signals
		  REG_LATCH_EN : in std_logic; -- Enables the register file and the pipeline registers
		  RD1		   : in std_logic; -- Enables the read port 1 of the register file
		  RD2		   : in std_logic; -- Enables the read port 2 of the register file
		  -- Execute CU signals
		  MUX_A_SEL     : in std_logic; -- Mux Selection for Operand A or NPC
		  MUX_B_SEL     : in std_logic_vector(1 downto 0); -- Mux Selection for Operand B, IMM or "4" (used for JAL/JALR when RD <- PC + 4)
		  ALU_OPC       : in aluOp; -- Operation type for ALU
		  ALU_OUTREG_EN : in std_logic; -- Enable output register
		  JUMP_TYPE     : in std_logic_vector(1 downto 0); -- "00" if not a jump, "01" if BEQZ/BNEZ, "10" if J/JAL, "11" if JALR/JR
		  DRAM_R_IN     : in std_logic; -- DRAM Read enable, sent at this stage for Hazard Detection
		  -- Memory CU signals
		  MEM_EN_IN     : in std_logic; -- Register enable signal
		  DRAM_W_IN     : in std_logic; -- DRAM write enable
		  RF_WE		    : in std_logic; -- RF write enable, sent at this stage for forwarding check
		  DRAM_EN_IN    : in std_logic; -- DRAM enable
		  -- Writeback CU signals
		  WB_MUX_SEL : in std_logic; -- Control signal for WB mux
		  --
		  INS_OUT       : out std_logic_vector(NBIT-1 downto 0); -- Instruction sent to CU
		  IRAM_ADDR_OUT : out std_logic_vector(NBIT-1 downto 0); -- from Fetch stage to IRAM
		  DRAM_ADDR_OUT : out std_logic_vector(NBIT-1 downto 0); -- from MEM stage to DRAM
		  DATA_OUT      : out std_logic_vector(NBIT-1 downto 0); -- from MEM stage to DRAM
		  DRAM_EN_OUT   : out std_logic; -- DRAM enable
		  DRAM_R_OUT    : out std_logic; -- sent to DRAM
		  DRAM_W_OUT    : out std_logic; -- sent to DRAM
		  Bubble_out    : out std_logic; -- Bubble signal for pipeline stall, sent to CU to generate a NOP
	      LOAD_TYPE     : out std_logic_vector(1 downto 0); -- "00" LW, "01" LB, "10" LBU, "11" LHU; to DRAM
		  STORE_TYPE    : out std_logic); -- '0' SW, '1' SB; to DRAM
end Datapath;

architecture struct of Datapath is

-- Component declarations
component ff is
	port( D   : in std_logic;
		  CLK : in std_logic;
		  EN  : in std_logic;
		  RST : in std_logic;
		  Q   : out std_logic);
end component;

component Fetch is
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
end component;

component Decode is
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
		  ADD_RS2_OUT  : out std_logic_vector(NBIT_ADD-1 downto 0); -- RS2 address for forwarding
		  LOAD_TYPE    : out std_logic_vector(1 downto 0); -- "00" LW, "01" LB, "10" LBU, "11" LHU
		  STORE_TYPE   : out std_logic); -- '0' SW, '1' SB    
end component;

component Execute is
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
		  LOAD_TYPE_IN  : in std_logic_vector(1 downto 0); -- "00" LW, "01" LB, "10" LBU, "11" LHU
	      STORE_TYPE_IN : in std_logic; -- '0' SW, '1' SB
		  PC_SEL        : out std_logic_vector(1 downto 0); -- PC MUX Selection signal, to MEM stage
		  ZERO_FLAG     : out std_logic; -- Used for Flush in Fetch and Decode
		  NPC_ABS       : out std_logic_vector(NBIT-1 downto 0); -- Absolute NPC (for JALR/JR)
		  NPC_REL       : out std_logic_vector(NBIT-1 downto 0); -- Relative NPC (for J/JAL/BEQZ/BNEZ)
		  ALU_RES       : out std_logic_vector(NBIT-1 downto 0); -- ALUREG output, to MEM stage
		  B_OUT         : out std_logic_vector(NBIT-1 downto 0);
		  ADD_WR_OUT    : out std_logic_vector(NBIT_ADD-1 downto 0); -- RF address for writeback, to MEM stage
		  LOAD_TYPE_OUT  : out std_logic_vector(1 downto 0); -- "00" LW, "01" LB, "10" LBU, "11" LHU
		  STORE_TYPE_OUT : out std_logic); -- '0' SW, '1' SB 
end component;

component Memory is
	port( CLK           : in std_logic; 
		  RST           : in std_logic;
		  MEM_EN_IN     : in std_logic; -- coming from Control Unit
		  DRAM_R_IN     : in std_logic; -- coming from Control Unit
		  DRAM_W_IN     : in std_logic; -- coming from Control Unit
		  DRAM_EN_IN    : in std_logic; -- DRAM enable
		  PC_SEL        : in std_logic_vector(1 downto 0); -- PC MUX Selection, from EX stage
		  NPC_IN        : in std_logic_vector(NBIT-1 downto 0); -- NPC, from Fetch stage
		  NPC_ABS       : in std_logic_vector(NBIT-1 downto 0); -- Absolute NPC (for JALR/JR)
		  NPC_REL       : in std_logic_vector(NBIT-1 downto 0); -- Relative NPC (for J/JAL/BEQZ/BNEZ)
		  ALU_RES_IN    : in std_logic_vector(NBIT-1 downto 0); -- ALUREG output, from EX stage
		  B_IN          : in std_logic_vector(NBIT-1 downto 0); -- Data for store, from EX stage
		  ADD_WR_IN     : in std_logic_vector(NBIT_ADD-1 downto 0); -- Address for WB, from EX stage
		  DRAM_DATA_IN  : in std_logic_vector(NBIT-1 downto 0); -- Load data from DRAM
		  LOAD_TYPE_IN  : in std_logic_vector(1 downto 0); -- "00" LW, "01" LB, "10" LBU, "11" LHU
	      STORE_TYPE_IN : in std_logic; -- '0' SW, '1' SB
		  PC_OUT        : out std_logic_vector(NBIT-1 downto 0); -- PC value, to fetch stage
		  DRAM_EN_OUT   : out std_logic; -- control signals to DRAM
		  DRAM_R_OUT    : out std_logic; -- control signals to DRAM
		  DRAM_W_OUT    : out std_logic; -- control signals to DRAM
		  DRAM_ADDR_OUT : out std_logic_vector(NBIT-1 downto 0); -- ALU output sent to DRAM
		  DRAM_DATA_OUT : out std_logic_vector(NBIT-1 downto 0); -- Data for store, to DRAM
		  DATA_OUT      : out std_logic_vector(NBIT-1 downto 0); -- Output of DRAM, to WB stage
		  ALU_RES_OUT   : out std_logic_vector(NBIT-1 downto 0); -- Data computed in ALU, to WB stage
		  OP_MEM        : out std_logic_vector(NBIT-1 downto 0); -- Operand sent back to EX stage for forwarding
		  ADD_WR_MEM    : out std_logic_vector(NBIT_ADD-1 downto 0); -- Write Address sent back to EX stage for forwarding
		  ADD_WR_OUT    : out std_logic_vector(NBIT_ADD-1 downto 0); -- Address for WB
		  LOAD_TYPE_OUT  : out std_logic_vector(1 downto 0); -- "00" LW, "01" LB, "10" LBU, "11" LHU
		  STORE_TYPE_OUT : out std_logic); -- '0' SW, '1' SB
end component;

component Writeback is
	port( WB_MUX_SEL : in std_logic; -- Control signal for WB mux
		  DATA_IN	 : in std_logic_vector(NBIT-1 downto 0); -- Data from DRAM
		  ALU_RES_IN : in std_logic_vector(NBIT-1 downto 0); -- Data from ALU
		  ADD_WR_IN  : in std_logic_vector(NBIT_ADD-1 downto 0); -- Address for WB
		  DATA_OUT   : out std_logic_vector(NBIT-1 downto 0); -- Data for WB and forwarding, sent to RF and FWD_Unit in the Execute stage
		  ADD_WR_OUT : out std_logic_vector(NBIT_ADD-1 downto 0)); -- Address for WB and forwarding, sent to RF and FWD_Unit in the Execute stage
end component;

component HazardDetection is
	port( RST         : in std_logic;
		  ADD_RS1     : in std_logic_vector(NBIT_ADD-1 downto 0); -- Source register 1 of the decoded instruction
		  ADD_RS2     : in std_logic_vector(NBIT_ADD-1 downto 0); -- Source register 2 of the decoded instruction
		  ADD_WR      : in std_logic_vector(NBIT_ADD-1 downto 0); -- Destination register of the previous instruction (coming into the Execute stage)
		  DRAM_R      : in std_logic; -- Memory read control signal generated by the CU, regarding the instruction currently in the Execute stage
		  INS_IN      : in std_logic_vector(NBIT-1 downto 0); -- Instruction coming out of the Fetch stage
		  PC_IN       : in std_logic_vector(NBIT-1 downto 0); -- PC of the instruction coming out of the Fetch stage
		  Bubble      : out std_logic; -- Bubble signal, raised to '1' to stall the pipeline
		  HDU_INS_OUT : out std_logic_vector(NBIT-1 downto 0); -- Current instruction
		  HDU_PC_OUT  : out std_logic_vector(NBIT-1 downto 0); -- PC of current instruction
		  HDU_NPC_OUT : out std_logic_vector(NBIT-1 downto 0)); -- NPC
end component;

-- Signal declarations
signal RF_WE_WB, ZERO_FLAG_EX, sig_Bubble, DRAM_R_MEM : std_logic;
signal PC_MEM_OUT, NPC_FETCH_OUT, INS_FETCH_OUT, PC_FETCH_OUT, NPC_ABS_EX, NPC_REL_EX : std_logic_vector(NBIT-1 downto 0);
signal PC_DECODE_OUT, A_DECODE_OUT, B_DECODE_OUT, IMM_DECODE_OUT : std_logic_vector(NBIT-1 downto 0);
signal OP_MEM, OP_WB, ALU_RES_EX, B_EX_OUT, DATA_MEM_OUT, ALU_RES_MEM : std_logic_vector(NBIT-1 downto 0);
signal ADD_WR_MEM, ADD_WR_WB, ADD_WR_DECODE_OUT, ADD_RS1_DECODE_OUT, ADD_RS2_DECODE_OUT : std_logic_vector(NBIT_ADD-1 downto 0);
signal ADD_WR_EX_OUT, ADD_WR_MEM_OUT, ADD_RS1_HDU, ADD_RS2_HDU : std_logic_vector(NBIT_ADD-1 downto 0);
signal sig_HDU_INS_OUT, sig_HDU_PC_OUT, sig_HDU_NPC_OUT : std_logic_vector(NBIT-1 downto 0);
signal PC_SEL_EX : std_logic_vector(1 downto 0);
signal LOAD_TYPE_DECODE_OUT, LOAD_TYPE_EX_OUT : std_logic_vector(1 downto 0);
signal STORE_TYPE_DECODE_OUT, STORE_TYPE_EX_OUT : std_logic;

begin


	FetchStage : Fetch port map(CLK => CLK,
								RST => RST,
							  --IR_LATCH_EN  : in std_logic;
							  --NPC_LATCH_EN : in std_logic;
							    ZERO_FLAG => ZERO_FLAG_EX,
								PC_EXT => PC_MEM_OUT,
								INS_IN => INS_IN,
								Bubble_in => sig_Bubble,
								HDU_INS_IN => sig_HDU_INS_OUT,
								HDU_PC_IN => sig_HDU_PC_OUT,
								HDU_NPC_IN => sig_HDU_NPC_OUT,
								PC_OUT => PC_FETCH_OUT,
								ADDR_OUT => IRAM_ADDR_OUT,
								NPC_OUT => NPC_FETCH_OUT,
								INS_OUT => INS_FETCH_OUT);
								
	INS_OUT <= INS_FETCH_OUT;
								
	DecodeStage : Decode port map(CLK => CLK, 
								  RST => RST,
								  REG_LATCH_EN => REG_LATCH_EN,
								  RD1 => RD1,
								  RD2 => RD2,
								  RF_WE => RF_WE_WB,
								  ZERO_FLAG => ZERO_FLAG_EX,
								  PC_IN => PC_FETCH_OUT,
								  INS_IN => INS_FETCH_OUT,
								  ADD_WR => ADD_WR_WB,
								  DATA_WR_IN => OP_WB,
								  PC_OUT => PC_DECODE_OUT,
								  A_OUT => A_DECODE_OUT,
								  B_OUT => B_DECODE_OUT,
								  IMM_OUT => IMM_DECODE_OUT,
								  ADD_RS1_HDU => ADD_RS1_HDU,
								  ADD_RS2_HDU => ADD_RS2_HDU,
								  ADD_WR_OUT => ADD_WR_DECODE_OUT,
								  ADD_RS1_OUT => ADD_RS1_DECODE_OUT,
								  ADD_RS2_OUT => ADD_RS2_DECODE_OUT,
								  LOAD_TYPE => LOAD_TYPE_DECODE_OUT,
								  STORE_TYPE => STORE_TYPE_DECODE_OUT);
								  
	ExecuteStage : Execute port map(  CLK => CLK, 
									  RST => RST,
									  MUX_A_SEL => MUX_A_SEL,
									  MUX_B_SEL => MUX_B_SEL,
									  ALU_OPC => ALU_OPC,
									  ALU_OUTREG_EN => ALU_OUTREG_EN,
									  JUMP_TYPE => JUMP_TYPE,
									  PC_IN => PC_DECODE_OUT,
									  A_IN => A_DECODE_OUT,
									  B_IN => B_DECODE_OUT,
									  IMM_IN => IMM_DECODE_OUT,
									  ADD_WR_IN => ADD_WR_DECODE_OUT,
									  ADD_RS1_IN => ADD_RS1_DECODE_OUT,
									  ADD_RS2_IN => ADD_RS2_DECODE_OUT,
									  ADD_WR_MEM => ADD_WR_MEM,
									  ADD_WR_WB => ADD_WR_WB,
									  RF_WE_MEM => RF_WE,
									  RF_WE_WB => RF_WE_WB,
									  OP_MEM => OP_MEM,
									  OP_WB	=> OP_WB,
									  LOAD_TYPE_IN => LOAD_TYPE_DECODE_OUT,
									  STORE_TYPE_IN => STORE_TYPE_DECODE_OUT,
									  PC_SEL => PC_SEL_EX,
									  ZERO_FLAG => ZERO_FLAG_EX,
									  NPC_ABS => NPC_ABS_EX,
									  NPC_REL => NPC_REL_EX,
									  ALU_RES => ALU_RES_EX,
									  B_OUT => B_EX_OUT,
									  ADD_WR_OUT => ADD_WR_EX_OUT,
									  LOAD_TYPE_OUT => LOAD_TYPE_EX_OUT,									  
									  STORE_TYPE_OUT => STORE_TYPE_EX_OUT);
		
	DRAM_R_ff : ff port map( D => DRAM_R_IN,
							CLK => CLK,
							EN => '1',
							RST => RST,
							Q => DRAM_R_MEM);
		
	MemoryStage : Memory port map(CLK => CLK,
								  RST => RST,
								  MEM_EN_IN => MEM_EN_IN,
								  DRAM_R_IN => DRAM_R_MEM,
								  DRAM_W_IN => DRAM_W_IN,
								  DRAM_EN_IN => DRAM_EN_IN,
								  PC_SEL => PC_SEL_EX,
								  NPC_IN => NPC_FETCH_OUT,
								  NPC_ABS => NPC_ABS_EX,
								  NPC_REL => NPC_REL_EX,
								  ALU_RES_IN => ALU_RES_EX,
								  B_IN => B_EX_OUT,
								  ADD_WR_IN => ADD_WR_EX_OUT,
								  DRAM_DATA_IN => DATA_IN,
								  LOAD_TYPE_IN => LOAD_TYPE_EX_OUT,
								  STORE_TYPE_IN => STORE_TYPE_EX_OUT,
								  PC_OUT => PC_MEM_OUT,
								  DRAM_EN_OUT => DRAM_EN_OUT,
								  DRAM_R_OUT => DRAM_R_OUT,
								  DRAM_W_OUT => DRAM_W_OUT,
								  DRAM_ADDR_OUT => DRAM_ADDR_OUT,
								  DRAM_DATA_OUT => DATA_OUT,
								  DATA_OUT => DATA_MEM_OUT,
								  ALU_RES_OUT => ALU_RES_MEM,
								  OP_MEM => OP_MEM,
								  ADD_WR_MEM => ADD_WR_MEM,
								  ADD_WR_OUT => ADD_WR_MEM_OUT,
								  LOAD_TYPE_OUT => LOAD_TYPE,
								  STORE_TYPE_OUT => STORE_TYPE);
		
	RF_WE_ff : ff port map( D => RF_WE,
							CLK => CLK,
							EN => '1',
							RST => RST,
							Q => RF_WE_WB);
							
	WritebackStage : Writeback port map(  WB_MUX_SEL => WB_MUX_SEL,
										  DATA_IN => DATA_MEM_OUT,
										  ALU_RES_IN => ALU_RES_MEM,
										  ADD_WR_IN => ADD_WR_MEM_OUT,
										  DATA_OUT => OP_WB,
										  ADD_WR_OUT => ADD_WR_WB);
										  
	HDU : HazardDetection port map (RST => RST,
					ADD_RS1 => ADD_RS1_HDU,
					ADD_RS2 => ADD_RS2_HDU,
					ADD_WR => ADD_WR_DECODE_OUT,
					DRAM_R => DRAM_R_IN,
					INS_IN => INS_FETCH_OUT,
					PC_IN => PC_FETCH_OUT,
					Bubble => sig_Bubble,
					HDU_INS_OUT => sig_HDU_INS_OUT,
					HDU_PC_OUT => sig_HDU_PC_OUT,
					HDU_NPC_OUT => sig_HDU_NPC_OUT);
					
	Bubble_out <= sig_Bubble; -- to CU

end struct;
