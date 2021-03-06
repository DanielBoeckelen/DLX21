-- From the instruction coming from the IF stage, its type is derived (R , I , J)
library IEEE;
use IEEE.std_logic_1164.all;
use work.constants.all;
use work.instruction_set.all;

entity instruction_type is
	port( INST_IN : in std_logic_vector(NBIT-1 downto 0); -- Instruction from IR
		  Rtype   : out std_logic;
		  Itype   : out std_logic;
		  Jtype   : out std_logic);
end instruction_type;

architecture bhv of instruction_type is 

-- Signal declarations
signal opcode : std_logic_vector(OPCODE_size-1 downto 0);
begin
	opcode <= INST_IN(OPCODE_begin downto OPCODE_end); -- Extract the opcode from the instruction

	inst_type : process(opcode)
	begin
		Rtype <= '0';
		Itype <= '0';
		Jtype <= '0';

		case opcode is
			when RType_OP  =>  Rtype <= '1';
			
			when LW_OP  =>    Itype <= '1';
			when SW_OP  =>    Itype <= '1';
			when ADDI_OP  =>  Itype <= '1';
			when ANDI_OP  =>  Itype <= '1';
			when BEQZ_OP  =>  Itype <= '1';
			when BNEZ_OP  =>  Itype <= '1';
			when ORI_OP  =>   Itype <= '1';
			when SGEI_OP  =>  Itype <= '1';
			when SLEI_OP  =>  Itype <= '1';
			when SLLI_OP  =>  Itype <= '1';
			when SNEI_OP  =>  Itype <= '1';
			when SRLI_OP  =>  Itype <= '1';
			when SUBI_OP  =>  Itype <= '1';
			when XORI_OP  =>  Itype <= '1';
			when JR_OP => Itype <= '1';
			when JALR_OP => Itype <= '1';
			when ADDUI_OP => Itype <= '1';
			when LB_OP => Itype <= '1';
			when LBU_OP => Itype <= '1';
			when LHI_OP => Itype <= '1';
			when LHU_OP => Itype <= '1';
			when SB_OP => Itype <= '1';
			when SEQI_OP => Itype <= '1';
			when SGEUI_OP => Itype <= '1';
			when SGTI_OP => Itype <= '1';
			when SGTUI_OP => Itype <= '1';
			when SLTI_OP => Itype <= '1';
			when SLTUI_OP => Itype <= '1';
			when SRAI_OP => Itype <= '1';
			when SUBUI_OP => Itype <= '1';

			when J_OP => Jtype <= '1';
			when JAL_OP =>  Jtype <= '1';

			when others =>  Rtype <= '0';
					Itype <= '0';
					Jtype <= '0';
		end case;
	end process inst_type;				
end bhv;
