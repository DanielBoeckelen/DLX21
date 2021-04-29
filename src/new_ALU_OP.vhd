library IEEE;
use IEEE.std_logic_1164.all;

package ALU_OPs is
	constant ALU_OPC_SIZE : integer := 4; -- Size of the ALU Opcode



JR   USING  NOP   --Confirmed
LHI  USING SLLS   --TO BE VERIFIED

Using ADDS:   ADD LW SW ADDI J JAL BEQZ BNEZ "LB LBU LHU  SB  JALR  " 	totally 8+5 instructions  
Using ADDUS:  "ADDU ADDUI"       								totally 2 instructions 
Using SUBS:   SUB SUBI	   									totally 2 instructions      
Using SUBUS: 	 "SUBU SUBUI"								totally 2 instructions      

Using ANDS:   AND ANDI			       			totally 2 instructions
Using ORS:    OR ORI				   			totally 2 instructions
Using XORS:   XOR XORI                 			totally 2 instructions

Using SGES:   SGE SGEI  		                totally 2 instrcutions
Using SGEUS:  "SGEU SGEUI"     					totally 2 instrcutions  
Using SLES:   SLE SLEI			       			totally 2 instructions 
Using SLLS:   SLL SLLI       		   			totally 2 instructions
Using SRLS:   SRL SRLI   			   			totally 2 instructions
Using NEQS:   SNE SNEI     			   			totally 2 instructions	
Using BEQZS:  BEQZS "SEQ SEQI"                  totally 1+2 instruction  
Using BNEZS:  BNEZS                             totally 1 instruction
Using SGTS:   "SGT SGTI "             			totally 2 instructions 
Using SGTUS:   "SGTU SGTUI"             		totally 2 instructions 
Using SLTS:   "SLT SLTI " 						totally 2 instructions	
Using SLTUS:   "SLTU SLTUI" 					totally 2 instructions	
Using SRAS:   "SRA SRAI"             			totally 2 instrcutions
Using MULTS:  "MULT"							totally 1 instruction 
TOTALLY 26 + 26 instructions

--------------------------------------------------------------------------------
--                        Advanced Instrcutions                               --
--------------------------------------------------------------------------------

addu DONE 
addui DONE
jalr DONE
jr DONE
lb DONE 
lbu DONE
lhi DONE
lhu DONE
sb DONE
seq DONE
seqi DONE
sgeu DONE
sgeui DONE
sgt    MODIFICATION OF ALU   DONE 
sgti   MODIFICATION OF ALU   DONE
sgtu   MODIFICATION OF ALU   DONE
sgtui  MODIFICATION OF ALU   DONE
slt    MODIFICATION OF ALU   DONE
slti   MODIFICATION OF ALU   DONE
sltu   MODIFICATION OF ALU   DONE
sltui  MODIFICATION OF ALU   DONE
sra     DONE
srai    DONE
subu    DONE
subui    DONE
mult  ***  DONE




	--constant FUNCT_ADDS  : std_logic_vector(ALU_OPC_SIZE-1 downto 0) := "0000";
	--constant FUNCT_SUBS  : std_logic_vector(ALU_OPC_SIZE-1 downto 0) := "0001";
	
	--constant FUNCT_ANDS  : std_logic_vector(ALU_OPC_SIZE-1 downto 0) := "0010";
	--constant FUNCT_ORS   : std_logic_vector(ALU_OPC_SIZE-1 downto 0) := "0011";
	--constant FUNCT_XORS  : std_logic_vector(ALU_OPC_SIZE-1 downto 0) := "0100";
	
	--constant FUNCT_SLLS  : std_logic_vector(ALU_OPC_SIZE-1 downto 0) := "0101";
	--constant FUNCT_SRLS  : std_logic_vector(ALU_OPC_SIZE-1 downto 0) := "0110";

	--constant FUNCT_SGES  : std_logic_vector(ALU_OPC_SIZE-1 downto 0) := "0111"; 
	--constant FUNCT_SLES  : std_logic_vector(ALU_OPC_SIZE-1 downto 0) := "1000";

	--constant FUNCT_NEQS  : std_logic_vector(ALU_OPC_SIZE-1 downto 0) := "1001";

end package;
