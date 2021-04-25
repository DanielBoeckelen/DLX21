library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.constants.all;
use work.instruction_set.all;

entity hardwired_cu is
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
			Bubble : in std_logic;
			Clk : in std_logic;
			Rst : in std_logic);                  -- Active Low
end hardwired_cu;

architecture bhv of hardwired_cu is

    -- Control word look-up table, control bits in the order (D, EXE, MEM, WB) in which they are sent to the datapath.

	type mem_array is array (integer range 0 to MICROCODE_MEM_SIZE - 1) of std_logic_vector(CW_SIZE - 1 downto 0);

	signal CW_MEM : mem_array := (
          --TO BE MODIFIED
          
          --REG_LATCH_EN, RD1, RD2
          --MUX_A_SEL, MUX_B_SEL, ALU_OUTREG_EN, DRAM_R_IN
          --MEM_EN_IN, DRAM_W_IN, RF_WE, DRAM_EN_IN
          -- WB_MUX_SEL

          --ALU_OUTREG_IN -> ALU and MEM
          --MEM_EN_IN -> MEM and WB mux
          
                                  "110" & "1110" & "1010" & '1', -- NOP
				  "111" & "1010" & "1010" & '1', -- R type CWs
                                  "110" & "1110" & "1010" & '1', -- I type CWs
                                                                 

                                  "110" & "1111" & "1011" & '0', -- LW RD, imm(RS1)
                                  "111" & "1110" & "1111" & '0', -- SW imm(RS1),RD
                                  
                                  "110" & "0110" & "0000" & '0', -- BEQZ
                                  "110" & "0110" & "0000" & '0', -- BNEZ
                                  

                                  "100" & "0110" & "0000" & '0', -- J target

                                  --to be modified
                                  "101" & "1111" & "1100" & '0' -- JAL target
                                 ); 
        
	signal IR_opcode : std_logic_vector(OP_CODE_SIZE -1 downto 0);  -- OpCode part of IR
  	signal IR_func : std_logic_vector(FUNC_SIZE-1 downto 0);   -- Func part of IR when Rtype
  	signal CW   : std_logic_vector(CW_SIZE - 1 downto 0); -- full control word read from cw_mem

    -- Control words are shifted to the correct cycle
  	signal CW1 : std_logic_vector(CW_SIZE-1 downto 0) := (others => '0'); --1st,2nd,3rd,4th,5th
  	signal CW2 : std_logic_vector(CW_SIZE-1 - 3 downto 0) := (others => '0'); --2nd,3rd,4th,5th
        signal CW3 : std_logic_vector(CW_SIZE-1 - 7 downto 0) := (others => '0'); --3rd,4th,5th
        signal CW4 : std_logic_vector(CW_SIZE-1 - 11 downto 0) := (others => '0'); --4th,5th
        

    --AluOp
      signal AluOP_D: aluop;
      signal AluOP_E: aluop;
      
        
begin

	-- Internal signals for OPCODE and FUNC inputs
	IR_opcode <= OPCODE;
  	IR_func <= FUNC;

	-- Control signals assignments
	-- Decode
	
	REG_LATCH_EN <= CW1(11);
        RD1 <= CW1(10);	
	RD2 <= CW1(9);

          
	-- Execute
	
        MUX_A_SEL <= CW2(8);    
	MUX_B_SEL <= CW2(7);      
       
	ALU_OUTREG_EN <= CW2(6);  
	DRAM_R_IN <= CW2(5);    

	-- Memory
	 MEM_EN_IN <= CW3(4);     
	 DRAM_W_IN <= CW3(3);            
         RF_WE <= CW3(2);
         DRAM_EN_IN <= CW3(1); 

        --Write Back
        WB_MUX_SEL <= CW4(0);
    

	-- Pipelining process
	CU_PROC: process(Clk, Rst)
	begin
		if(Rst = '0') then -- Asynchronous reset
			CW1 <= (others => '0');
                        CW2 <= (others => '0');
                        CW3 <= (others => '0');
                        CW4 <= (others => '0');
                       
		elsif(Clk = '1' and Clk'event) then -- Assigning to the correct stage of the pipeline
			if(Bubble = '1') then 
				CW1 <= (others => '0');
			else
				CW1 <= CW;
				CW2 <= CW1(CW_SIZE-1 - 3 downto 0);
				CW3 <= CW2(CW_SIZE-1 - 7 downto 0);
				CW4 <= CW3(CW_SIZE-1 - 11 downto 0);

				AluOP_E <= AluOP_D;
				ALU_OPC <= AluOP_E; 
			end if;
		end if;
	end process CU_PROC;

	-- Generation of the output control signals based on the values in the control word look-up table
   	CW_GEN : process (IR_opcode, IR_func)
   	begin
		case IR_opcode is
			when RType_OP => -- analyze each RTYPE function
				case IR_func is
					when ADD_Func => CW <= CW_MEM(1);
                                        when AND_Func => CW <= CW_MEM(1);
					when OR_Func  => CW <= CW_MEM(1);
                                        when SGE_Func => CW <= CW_MEM(1);
                                        when SLE_Func => CW <= CW_MEM(1);
                                        when SLL_Func => CW <= CW_MEM(1);
                                        when SNE_Func => CW <= CW_MEM(1);
                                        when SRL_Func => CW <= CW_MEM(1);
                                        when SUB_Func => CW <= CW_MEM(1);
                                        when XOR_Func => CW <= CW_MEM(1);      
 					when others => CW <= CW_MEM(0); -- NOP
				end case;
			when LW_OP   => CW <= CW_MEM(3);
			when SW_OP   => CW <= CW_MEM(4);
			when ADDI_OP => CW <= CW_MEM(2);
			when ANDI_OP => CW <= CW_MEM(2);
			when BEQZ_OP => CW <= CW_MEM(5);
			when BNEZ_OP => CW <= CW_MEM(6);
			when ORI_OP  => CW <= CW_MEM(2);
			when SGEI_OP => CW <= CW_MEM(2);
			when SLEI_OP => CW <= CW_MEM(2);
			when SLLI_OP => CW <= CW_MEM(2);
			when SNEI_OP => CW <= CW_MEM(2);
			when SRLI_OP => CW <= CW_MEM(2);
			when SUBI_OP => CW <= CW_MEM(2);
			when XORI_OP => CW <= CW_MEM(2);
                        when J_OP => CW <= CW_MEM(7);
                        when JAL_OP => CW <= CW_MEM(8);
			when others => CW <= CW_MEM(0); -- NOP
	 	end case;
	end process CW_GEN;

        -- Generation of the ALU control signals
   	ALUOPC_GEN : process (IR_opcode, IR_func)
   	begin
		case IR_opcode is
			when RType_OP => -- analyze each RTYPE function
				case IR_func is
                                        when ADD_Func => AluOP_D <= ADDS;
                                        when AND_Func => AluOP_D <= ANDS;
					when OR_Func  => AluOP_D <= ORS;
					when SGE_Func => AluOP_D <= SGES;
					when SLE_Func => AluOP_D <= SLES;
					when SLL_Func => AluOP_D <= SLLS;
					when SNE_Func => AluOP_D <= NEQS;
					when SRL_Func => AluOP_D <= SRLS;
					when SUB_Func => AluOP_D <= SUBS;
					when XOR_Func => AluOP_D <= XORS;      
 					when others   => AluOP_D <= NOP; -- NOP
				end case;
			when LW_OP   => AluOP_D <= ADDS;
			when SW_OP   => AluOP_D <= ADDS;
			when ADDI_OP => AluOP_D <= ADDS;
			when ANDI_OP => AluOP_D <= ANDS;
			when BEQZ_OP => AluOP_D <= BEQZS;
			when BNEZ_OP => AluOP_D <= BNEZS;
			when ORI_OP  => AluOP_D <= ORS;
			when SGEI_OP => AluOP_D <= SGES;
			when SLEI_OP => AluOP_D <= SLES;
			when SLLI_OP => AluOP_D <= SLLS;
			when SNEI_OP => AluOP_D <= NEQS;
			when SRLI_OP => AluOP_D <= SRLS;
			when SUBI_OP => AluOP_D <= SUBS;
			when XORI_OP => AluOP_D<= XORS;
			when J_OP    => AluOP_D <= ADDS;
			when JAL_OP  => AluOP_D <= ADDS;
			when others  => AluOP_D <= NOP; -- NOP
	 	end case;
	end process ALUOPC_GEN;
end bhv;