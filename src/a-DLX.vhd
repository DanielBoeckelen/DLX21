library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;
use work.instruction_set.all;

entity DLX is
  generic (
    IR_SIZE      : integer := NBIT;       -- Instruction Register Size
    PC_SIZE      : integer := NBIT       -- Program Counter Size
    );
  port (
    Clk : in std_logic;
    Rst : in std_logic);                -- Active Low
end DLX;

architecture dlx_rtl of DLX is

 --------------------------------------------------------------------
 -- Components Declaration
 --------------------------------------------------------------------
  
  --Instruction Ram
  component IRAM is
  generic (
    RAM_DEPTH : integer := MEM_size;
    I_SIZE : integer := NBIT);
  port (
    Rst  : in  std_logic;
    Addr : in  std_logic_vector(I_SIZE - 1 downto 0); -- Program counter, from datapath
    Iout : out std_logic_vector(I_SIZE - 1 downto 0)
    );
  end component;

  component DRAM is
  generic (
    RAM_DEPTH : integer := MEM_size;
    D_SIZE : integer := NBIT);
  port (
    Clk        : in std_logic;
    Rst        : in std_logic;
    ADDR_IN    : in std_logic_vector(D_SIZE-1 downto 0);
	DATA_IN    : in std_logic_vector(D_SIZE-1 downto 0);
	LOAD_TYPE  : in std_logic_vector(1 downto 0); -- "00" LW, "01" LB, "10" LBU, "11" LHU
	STORE_TYPE : in std_logic; -- '0' SW, '1' SB
	DRAM_W     : in std_logic; -- Write enable
	DRAM_R     : in std_logic; -- Read enable
	DATA_OUT   : out std_logic_vector(D_SIZE-1 downto 0)
    );
  end component;

  component Datapath is
	port( CLK     : in std_logic; 
		  RST	  : in std_logic; -- Reset signal, active low
		  INS_IN  : in std_logic_vector(NBIT-1 downto 0); -- from instruction memory
		  DATA_IN : in std_logic_vector(NBIT-1 downto 0); -- from data memory
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
		  LOAD_TYPE_IN  : in std_logic_vector(1 downto 0); -- "00" LW, "01" LB, "10" LBU, "11" LHU
		  STORE_TYPE_IN : in std_logic; -- '0' SW, '1' SB
		  -- Writeback CU signals
		  WB_MUX_SEL : in std_logic; -- Control signal for WB mux
		  --
		  INS_OUT       : out std_logic_vector(NBIT-1 downto 0); -- Instruction sent to CU
		  IRAM_ADDR_OUT : out std_logic_vector(NBIT-1 downto 0); -- from Fetch stage to IRAM
		  DRAM_ADDR_OUT : out std_logic_vector(NBIT-1 downto 0); -- from MEM stage to DRAM
		  DATA_OUT      : out std_logic_vector(NBIT-1 downto 0); -- from MEM stage to DRAM
		  DRAM_R_OUT    : out std_logic; -- sent to DRAM
		  DRAM_W_OUT    : out std_logic; -- sent to DRAM
		  Bubble_out    : out std_logic; -- Bubble signal for pipeline stall, sent to CU to generate a NOP
	      LOAD_TYPE_OUT  : out std_logic_vector(1 downto 0); -- "00" LW, "01" LB, "10" LBU, "11" LHU
		  STORE_TYPE_OUT : out std_logic); -- '0' SW, '1' SB
  end component;
  
  -- Control Unit
  component hardwired_cu is
    generic(NBIT : integer);
	port (             
            -- Execute cu signals
            MUX_A_SEL     : out std_logic; -- Mux Selection for Operand A or NPC
			MUX_B_SEL     : out std_logic_vector(1 downto 0); -- Mux Selection Operand B, IMM or 4 (used in PC+4)
			ALU_OPC       : out aluOp; -- Operation type for ALU
			ALU_OUTREG_EN : out std_logic; -- Enable output register
            DRAM_R_IN     : out std_logic; -- DRAM read enable
            JUMP_TYPE     : out std_logic_vector(1 downto 0); -- "00" if not a jump, "01" if BEQZ/BNEZ, "10" if J/JAL, "11" if JALR/JR
     
            -- Memory cu signals
            MEM_EN_IN     : out std_logic; -- Register enable signal
			DRAM_W_IN     : out std_logic; -- DRAM write enable
            RF_WE    	  : out std_logic; -- RF write enable, sent at this stage for forwarding check
			LOAD_TYPE_IN  : out std_logic_vector(1 downto 0); -- "00" LW, "01" LB, "10" LBU, "11" LHU
		    STORE_TYPE_IN : out std_logic; -- '0' SW, '1' SB

            -- Writeback CU signals     
			WB_MUX_SEL    : out std_logic; -- Control signal for WB mux
		  
			-- Inputs
			INS_IN : in std_logic_vector(NBIT-1 downto 0);
			Bubble : in std_logic;
			Clk    : in std_logic;
			Rst    : in std_logic);                  -- Active Low
  end component;


  ----------------------------------------------------------------
  -- Signals Declaration
  ----------------------------------------------------------------
  
  signal REG_LATCH_EN, RD1, RD2, MUX_A_SEL, ALU_OUTREG_EN, DRAM_R_IN, MEM_EN_IN, DRAM_W_IN, RF_WE, WB_MUX_SEL, Bubble, DRAM_R_OUT, DRAM_W_OUT : std_logic;
  signal MUX_B_SEL, JUMP_TYPE, LOAD_TYPE_IN, LOAD_TYPE_OUT : std_logic_vector(1 downto 0);
  signal STORE_TYPE_IN, STORE_TYPE_OUT : std_logic;
  signal ALU_OPC : aluOp;
  signal INST, IRAM_ADDR_OUT, INS_IN, DRAM_ADDR_OUT, DATA_IN, DATA_OUT : std_logic_vector(NBIT-1 downto 0);


  begin  -- DLX
	
	-- Datapath instantiation
	DP: Datapath port map(CLK => Clk,
						  RST => Rst,
						  INS_IN => INS_IN,
						  DATA_IN => DATA_IN,
						  MUX_A_SEL => MUX_A_SEL,
						  MUX_B_SEL => MUX_B_SEL,
						  ALU_OPC => ALU_OPC,
						  ALU_OUTREG_EN => ALU_OUTREG_EN,
						  JUMP_TYPE => JUMP_TYPE,
						  DRAM_R_IN => DRAM_R_IN,
						  MEM_EN_IN => MEM_EN_IN,
						  DRAM_W_IN => DRAM_W_IN,
						  RF_WE => RF_WE,
						  LOAD_TYPE_IN => LOAD_TYPE_IN,
					      STORE_TYPE_IN => STORE_TYPE_IN,
						  WB_MUX_SEL => WB_MUX_SEL,
						  INS_OUT => INST,
						  IRAM_ADDR_OUT => IRAM_ADDR_OUT,
						  DRAM_ADDR_OUT => DRAM_ADDR_OUT,
						  DATA_OUT => DATA_OUT,
						  DRAM_R_OUT => DRAM_R_OUT,
						  DRAM_W_OUT => DRAM_W_OUT,
						  Bubble_out => Bubble,
						  LOAD_TYPE_OUT => LOAD_TYPE_OUT,
						  STORE_TYPE_OUT => STORE_TYPE_OUT);

	-- Control Unit instantiation
    CU: hardwired_cu generic map(NBIT => NBIT)
		port map(	MUX_A_SEL => MUX_A_SEL,
					MUX_B_SEL => MUX_B_SEL,
					ALU_OPC => ALU_OPC,
					ALU_OUTREG_EN => ALU_OUTREG_EN,
					DRAM_R_IN => DRAM_R_IN,
					JUMP_TYPE => JUMP_TYPE,
					MEM_EN_IN => MEM_EN_IN,
					DRAM_W_IN => DRAM_W_IN,
					RF_WE => RF_WE,
					LOAD_TYPE_IN => LOAD_TYPE_IN,
					STORE_TYPE_IN => STORE_TYPE_IN,
					WB_MUX_SEL => WB_MUX_SEL,
					INS_IN => INST,
					Bubble => Bubble,
					Clk => Clk,
					Rst => Rst);

    -- Instruction Ram Instantiation
    IRAM_I: IRAM generic map(RAM_DEPTH => MEM_size, I_SIZE => NBIT) 
		port map (
			Rst  => Rst,
			Addr => IRAM_ADDR_OUT,
			Iout => INS_IN);
		  
	-- Data Ram Instantiation
	DRAM_I: DRAM generic map(RAM_DEPTH => MEM_size, D_SIZE => NBIT)
		port map (
			Clk => Clk,
			Rst => Rst,
			ADDR_IN => DRAM_ADDR_OUT,
			DATA_IN => DATA_OUT,
			LOAD_TYPE => LOAD_TYPE_OUT,
			STORE_TYPE => STORE_TYPE_OUT,
			DRAM_W => DRAM_W_OUT,
			DRAM_R => DRAM_R_OUT,
			DATA_OUT => DATA_IN);
	
end dlx_rtl;
