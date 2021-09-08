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
			--REG_LATCH_EN : out std_logic; -- Enables the register file and the pipeline registers
            --RD1		     : out std_logic; -- Enables the read port 1 of the register file
			--RD2		     : out std_logic; -- Enables the read port 2 of the register file
             
            -- execute cu signals
            MUX_A_SEL     : out std_logic; -- Mux Selection for Operand A or NPC
			MUX_B_SEL     : out std_logic_vector(1 downto 0); -- Mux Selection Operand B, IMM or 4 (used in PC+4)
			ALU_OPC       : out aluOp; -- Operation type for ALU
			ALU_OUTREG_EN : out std_logic; -- Enable output register
            DRAM_R_IN     : out std_logic; -- DRAM read enable
            JUMP_TYPE     : out std_logic_vector(1 downto 0);
     
            -- memory cu signals
            MEM_EN_IN     : out std_logic; -- Register enable signal
			DRAM_W_IN     : out std_logic; -- DRAM write enable
            RF_WE    	  : out std_logic; -- RF write enable, sent at this stage for forwarding check
            --DRAM_EN_IN    : out std_logic; -- DRAM enable
			LOAD_TYPE_IN  : out std_logic_vector(1 downto 0); -- "00" LW, "01" LB, "10" LBU, "11" LHU
		    STORE_TYPE_IN : out std_logic; -- '0' SW, '1' SB

            -- writeback CU signals
        
			WB_MUX_SEL    : out std_logic; -- Control signal for WB mux
	      	  
			  
			-- INPUTS
			INS_IN : in std_logic_vector(NBIT-1 downto 0);
			Bubble : in std_logic;
			Clk    : in std_logic;
			Rst    : in std_logic);                  -- Active Low
end hardwired_cu;

architecture bhv of hardwired_cu is
  
---------------------------------------------------------------------
--NOTES on MUX_B_SEL, JUMP_TYPE, LOAD_TYPE, STORE_TYPE
---------------------------------------------------------------------

  --MUX_B_SEL
    --"00" for B
    --"01" for IMM
    --"10" for 4 (used in PC+4)
    --"11" unused

  --JUMP_TYPE
    --"00" when it's not a jump
    --"01" BEQZ/BNEZ
    --"10" J/JAL
    --"11" JR/JALR

  --LOAD_TYPE
	--"00" LW/not a load
	--"01" LB
	--"10" LBU
	--"11" LHU

  --STORE_TYPE
	--'0' SW/not a store
	--'1' SB

---------------------------------------------------------------------
  
    -- Control word look-up table, control bits in the order (D, EXE, MEM, WB) in which they are sent to the datapath.

	type mem_array is array (integer range 0 to MICROCODE_MEM_SIZE - 1) of std_logic_vector(CW_SIZE - 1 downto 0);

	signal CW_MEM : mem_array := (
          
          --(EX)      MUX_A_SEL, MUX_B_SEL(1), MUX_B_SEL(0), ALU_OUTREG_EN, DRAM_R_IN, JUMP_TYPE(1), JUMP_TYPE(0)
          --(MEM)     MEM_EN_IN, DRAM_W_IN, RF_WE, LOAD_TYPE_IN(1), LOAD_TYPE_IN(0), STORE_TYPE_IN
          --(WB)      WB_MUX_SEL

          --ALU_OUTREG_EN -> pipeline regs between ALU and MEM
          --MEM_EN_IN -> pipeline regs between MEM and WB mux
          
                                   "0000000" & "000000" & '0', -- NOP
								   "0001000" & "101000" & '0', -- R type CWs
                                   "0011000" & "101000" & '0', -- I type CWs
                                                                 
                                   "0011100" & "101000" & '1', -- LW RD, imm(RS1)
								   "0011100" & "101010" & '1', -- LB
                                   "0011100" & "101100" & '1', -- LBU
								   "0011100" & "101110" & '1', -- LHU
                                   "0011000" & "110000" & '0', -- SW imm(RS1)
 								   "0011000" & "110001" & '0', -- SB

                                  -- In BEQZ and BNEZ: ALU output reg is turned off because the adder
                                  -- of the EXE stage performs PC+imm26
                                  
                                   "1011001" & "000000" & '0', -- BEQZ
                                   "1011001" & "000000" & '0', -- BNEZ

                                  -- In JAL the ALU will perform PC+4 while in
                                  -- parallel the adder in EXE stage performs PC+imm26

                                   "1011010" & "000000" & '0', -- J label
                                   "1101010" & "101000" & '0', -- JAL label

                                   "1101011" & "000000" & '0', -- JR register
                                   "1101011" & "101000" & '0'  -- JALR register
                                 ); 
        
	signal IR_opcode : std_logic_vector(OPCODE_size-1 downto 0);  -- OpCode part of IR
  	signal IR_func : std_logic_vector(Func_size-1 downto 0);   -- Func part of IR when Rtype
  	signal CW   : std_logic_vector(CW_SIZE - 1 downto 0); -- full control word read from cw_mem

    -- Control words are shifted to the correct cycle
  	signal CW1 : std_logic_vector(CW_SIZE-1 downto 0) := (others => '0'); --1st,2nd,3rd
  	signal CW2 : std_logic_vector(CW_SIZE-1 - 7 downto 0) := (others => '0'); --2nd,3rd
    signal CW3 : std_logic_vector(CW_SIZE-1 - 13 downto 0) := (others => '0'); --3rd
        

    -- AluOp
      signal AluOP_E: aluop;
        
begin

	-- Internal signals for OPCODE and FUNC
	IR_opcode <= INS_IN(OPCODE_begin downto OPCODE_end);
  	IR_func <= INS_IN (Func_begin downto Func_end);

	-- Control signal assignments

        
	-- Execute
    MUX_A_SEL <= CW1(13);    
	MUX_B_SEL(1) <= CW1(12);
    MUX_B_SEL(0) <= CW1(11);
       
	ALU_OUTREG_EN <= CW1(10);  
	DRAM_R_IN <= CW1(9);

    JUMP_TYPE(1) <= CW1(8);
    JUMP_TYPE(0) <= CW1(7);

	-- Memory
	MEM_EN_IN <= CW2(6);     
	DRAM_W_IN <= CW2(5);            
	RF_WE <= CW2(4);
	LOAD_TYPE_IN(1) <= CW2(3);
	LOAD_TYPE_IN(0) <= CW2(2);
	STORE_TYPE_IN <= CW2(1);

    -- Write Back
    WB_MUX_SEL <= CW3(0);
    

	-- Pipelining process
	CU_PROC: process(Clk, Rst)
	begin
		if(Rst = '0') then -- Asynchronous reset
			CW1 <= (others => '0');
            CW2 <= (others => '0');
            CW3 <= (others => '0');
        
			ALU_OPC <= NOP;
                       
		elsif(Clk = '1' and Clk'event) then -- Assigning to the correct stage of the pipeline
			
				CW1 <= CW;
				CW2 <= CW1(CW_SIZE-1 - 7 downto 0);
				CW3 <= CW2(CW_SIZE-1 - 13 downto 0);
			
				ALU_OPC <= AluOP_E;
		
		end if;
	end process CU_PROC;

	-- Generation of the output control signals based on the values in the control word look-up table
   	CW_GEN : process (IR_opcode, IR_func, Bubble)
   	begin
	
	if(Bubble = '1') then
		CW <= (others => '0');
	else
		case(IR_opcode) is
			when RType_OP => -- analyze each RTYPE function
				case (IR_func) is
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
					when ADDU_Func => CW <= CW_MEM(1);  
					when SEQ_Func => CW <= CW_MEM(1);
					when SGEU_Func => CW <= CW_MEM(1);
					when SGT_Func => CW <= CW_MEM(1);
					when SGTU_Func => CW <= CW_MEM(1);
					when SLT_Func => CW <= CW_MEM(1);
					when SLTU_Func => CW <= CW_MEM(1);
					when SRA_Func => CW <= CW_MEM(1);
					when SUBU_Func => CW <= CW_MEM(1);
					when MULT_Func => CW <= CW_MEM(1);    
 					when others => CW <= CW_MEM(0); -- NOP
				end case;
			when NOP_OP  => CW <= CW_MEM(0);
			when LW_OP   => CW <= CW_MEM(3);
			when SW_OP   => CW <= CW_MEM(7);
			when ADDI_OP => CW <= CW_MEM(2);
			when ANDI_OP => CW <= CW_MEM(2);
			when BEQZ_OP => CW <= CW_MEM(9);
			when BNEZ_OP => CW <= CW_MEM(10);
			when ORI_OP  => CW <= CW_MEM(2);
			when SGEI_OP => CW <= CW_MEM(2);
			when SLEI_OP => CW <= CW_MEM(2);
			when SLLI_OP => CW <= CW_MEM(2);
			when SNEI_OP => CW <= CW_MEM(2);
			when SRLI_OP => CW <= CW_MEM(2);
			when SUBI_OP => CW <= CW_MEM(2);
			when XORI_OP => CW <= CW_MEM(2);
			when ADDUI_OP => CW <= CW_MEM(2);
			when LB_OP => CW <= CW_MEM(4);
			when LBU_OP => CW <= CW_MEM(5);
			when LHI_OP => CW <= CW_MEM(2);
			when LHU_OP => CW <= CW_MEM(6);
			when SB_OP => CW <= CW_MEM(8);
			when SEQI_OP => CW <= CW_MEM(2);
			when SGEUI_OP => CW <= CW_MEM(2);
			when SGTI_OP => CW <= CW_MEM(2);
			when SGTUI_OP => CW <= CW_MEM(2);
			when SLTI_OP => CW <= CW_MEM(2);
			when SLTUI_OP => CW <= CW_MEM(2);
			when SRAI_OP => CW <= CW_MEM(2);
			when SUBUI_OP => CW <= CW_MEM(2);
            when J_OP => CW <= CW_MEM(11);
            when JAL_OP => CW <= CW_MEM(12);
            when JR_OP   => CW <= CW_MEM(13);
            when JALR_OP => CW <= CW_MEM(14);
			when others => CW <= CW_MEM(0); -- NOP
	 	end case;
	 end if;
	end process CW_GEN;

    -- Generation of the ALU control signals
   	ALUOPC_GEN : process (IR_opcode, IR_func, Bubble)
   	begin
	if(Bubble = '1') then
		AluOP_E <= NOP;
	else
		case (IR_opcode) is
			when RType_OP => -- analyze each RTYPE function
				case (IR_func) is
                    when ADD_Func => AluOP_E <= ADDS;
                    when AND_Func => AluOP_E <= ANDS;
					when OR_Func  => AluOP_E <= ORS;
					when SGE_Func => AluOP_E <= SGES;
					when SLE_Func => AluOP_E <= SLES;
					when SLL_Func => AluOP_E <= SLLS;
					when SNE_Func => AluOP_E <= NEQS;
					when SRL_Func => AluOP_E <= SRLS;
					when SUB_Func => AluOP_E <= SUBS;
					when XOR_Func => AluOP_E <= XORS;
					when ADDU_Func => AluOP_E <= ADDUS;  
					when SEQ_Func => AluOP_E <= SEQS;
					when SGEU_Func => AluOP_E <= SGEUS;
					when SGT_Func => AluOP_E <= SGTS;
					when SGTU_Func => AluOP_E <= SGTUS;
					when SLT_Func => AluOP_E <= SLTS;
					when SLTU_Func => AluOP_E <= SLTUS;
					when SRA_Func => AluOP_E <= SRAS;
					when SUBU_Func => AluOP_E <= SUBUS;
					when MULT_Func => AluOP_E <= MULTS;          
 					when others   => AluOP_E <= NOP; -- NOP
				end case;
			when NOP_OP  => AluOP_E <= NOP;
			when LW_OP   => AluOP_E <= ADDS;
			when SW_OP   => AluOP_E <= ADDS;
			when ADDI_OP => AluOP_E <= ADDS;
			when ANDI_OP => AluOP_E <= ANDS;
			when BEQZ_OP => AluOP_E <= BEQZS;
			when BNEZ_OP => AluOP_E <= BNEZS;
			when ORI_OP  => AluOP_E <= ORS;
			when SGEI_OP => AluOP_E <= SGES;
			when SLEI_OP => AluOP_E <= SLES;
			when SLLI_OP => AluOP_E <= SLLS;
			when SNEI_OP => AluOP_E <= NEQS;
			when SRLI_OP => AluOP_E <= SRLS;
			when SUBI_OP => AluOP_E <= SUBS;
			when XORI_OP => AluOP_E <= XORS;
			when ADDUI_OP => AluOP_E <= ADDUS;
			when LB_OP => AluOP_E <= ADDS;
			when LBU_OP => AluOP_E <= ADDS;
			when LHI_OP => AluOP_E <= LHIS;
			when LHU_OP => AluOP_E <= ADDS;
			when SB_OP => AluOP_E <= ADDS;
			when SEQI_OP => AluOP_E <= SEQS;
			when SGEUI_OP => AluOP_E <= SGEUS;
			when SGTI_OP => AluOP_E <= SGTS;
			when SGTUI_OP => AluOP_E <= SGTUS;
			when SLTI_OP => AluOP_E <= SLTS;
			when SLTUI_OP => AluOP_E <= SLTUS;
			when SRAI_OP => AluOP_E <= SRAS;
			when SUBUI_OP => AluOP_E <= SUBUS; 
			when J_OP    => AluOP_E <= NOP;
			when JAL_OP  => AluOP_E <= ADDS;
            when JR_OP   => AluOP_E <= NOP;
            when JALR_OP => AluOP_E <= ADDS;
			when others  => AluOP_E <= NOP; -- NOP
	 	end case;
	end if;
	end process ALUOPC_GEN;
end bhv;
