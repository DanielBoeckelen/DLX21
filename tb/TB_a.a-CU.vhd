library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use work.constants.all;
use work.instruction_set.all;

entity tb_CU is
end entity;

architecture test of tb_CU is

component hardwired_cu is
  generic(NBIT : integer);
	port (
              -- decode cu signals
              REG_LATCH_EN      : out std_logic; -- Enables the register file and the pipeline registers
              RD1		: out std_logic; -- Enables the read port 1 of the register file
	      RD2		: out std_logic; -- Enables the read port 2 of the register file
             
              -- execute cu signals
              MUX_A_SEL     : out std_logic; -- Mux Selection for Operand A or NPC
	      MUX_B_SEL     : out std_logic; -- Mux Selection for Operand B or IMM
	      ALU_OPC       : out aluOp; -- Operation type for ALU
	      ALU_OUTREG_EN : out std_logic; -- Enable output register
              DRAM_R_IN    : out std_logic; -- DRAM read enable
     
              -- memory cu signals
              MEM_EN_IN     : out std_logic; -- Register enable signal
	      DRAM_W_IN     : out std_logic; -- DRAM write enable
              RF_WE    	    : out std_logic; -- RF write enable, sent at this stage for forwarding check
              DRAM_EN_IN   : out std_logic; -- DRAM enable

              -- writeback CU signals
        
	      WB_MUX_SEL    : out std_logic; -- Control signal for WB mux
	      	  

              -- INPUTS
              OPCODE : in  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
              FUNC   : in  std_logic_vector(FUNC_SIZE - 1 downto 0);              
              Clk : in std_logic;
              Rst : in std_logic -- Active Low
              );                  
end component;

  constant tb_period : time := 20ns;
  constant tb_clk : time := 10ns;

              -- decode cu signals
  signal REG_LATCH_EN   : std_logic; -- Enables the register file and the pipeline registers
  signal RD1		: std_logic; -- Enables the read port 1 of the register file
  signal RD2		: std_logic; -- Enables the read port 2 of the register file
             
              -- execute cu signals
  signal MUX_A_SEL     : std_logic; -- Mux Selection for Operand A or NPC
  signal MUX_B_SEL     : std_logic; -- Mux Selection for Operand B or IMM
  signal ALU_OPC       : aluOp; -- Operation type for ALU
  signal ALU_OUTREG_EN : std_logic; -- Enable output register
  signal DRAM_R_IN    : std_logic; -- sent to DRAM
     
              -- memory cu signals
  signal MEM_EN_IN     : std_logic; -- Register enable signal
  signal DRAM_W_IN     : std_logic; -- DRAM write enable
  signal RF_WE         : std_logic; -- RF write enable, sent at this stage for forwarding check
  signal DRAM_EN_IN    : std_logic; -- DRAM enable

              -- writeback CU signals
        
  signal WB_MUX_SEL    : std_logic; -- Control signal for WB mux

              -- INPUTS
  signal OPCODE : std_logic_vector(OP_CODE_SIZE - 1 downto 0);
  signal FUNC   : std_logic_vector(FUNC_SIZE - 1 downto 0);              
  signal Clk : std_logic;
  signal Rst : std_logic;                  -- Active Low


begin

  DUT : hardwired_cu
    generic map (NBIT => 32)
    port map(

             -- decode cu signals
              REG_LATCH_EN => REG_LATCH_EN,
              RD1 => RD1,
	      RD2 => RD2,
             
              -- execute cu signals
              MUX_A_SEL => MUX_A_SEL,
	      MUX_B_SEL => MUX_B_SEL,
	      ALU_OPC => ALU_OPC,      
	      ALU_OUTREG_EN => ALU_OUTREG_EN, 
              DRAM_R_IN => DRAM_R_IN,  
     
              -- memory cu signals
              MEM_EN_IN => MEM_EN_IN,
	      DRAM_W_IN => DRAM_W_IN,
              RF_WE => RF_WE,
              DRAM_EN_IN => DRAM_EN_IN,

              -- writeback CU signals
        
	      WB_MUX_SEL => WB_MUX_SEL,

              -- INPUTS
              OPCODE => OPCODE,
              func => func,       
              Clk => Clk,
              Rst => Rst
      
              );

 CLK_process : process

    begin

      Clk <= '0';

      wait for tb_clk;

      Clk <= '1';

      wait for tb_clk;
      
  end process;

  
  stimuli : process

                procedure apply_stimuli (

                        constant OPCODE_val : in std_logic_vector(OP_CODE_SIZE - 1 downto 0);
                        constant FUNC_val   : in std_logic_vector(FUNC_SIZE - 1 downto 0);              
                        constant Rst_val    : in std_logic;

                        signal OPCODE : out std_logic_vector(OP_CODE_SIZE - 1 downto 0);
                        signal FUNC   : out std_logic_vector(FUNC_SIZE - 1 downto 0);              
                        signal Rst : out std_logic 

                        ) is
                begin
                       OPCODE <= OPCODE_val;
                       FUNC <= FUNC_val;
                       Rst <= Rst_val;
                       
                        wait for tb_period;
                       
                end apply_stimuli;
  begin

   --apply_stimuli(input values, signals);

    apply_stimuli(RType_OP,ADD_Func,'1',OPCODE, FUNC, Rst);
    apply_stimuli(RType_OP,AND_Func,'1',OPCODE, FUNC, Rst);
    
    
    apply_stimuli(XORI_OP,(others => '0'),'1',OPCODE, FUNC, Rst);
    apply_stimuli(ANDI_OP,(others => '0'),'1',OPCODE, FUNC, Rst);
    apply_stimuli(BEQZ_OP,(others => '0'),'1',OPCODE, FUNC, Rst);
    
  
  end process;

end test;
