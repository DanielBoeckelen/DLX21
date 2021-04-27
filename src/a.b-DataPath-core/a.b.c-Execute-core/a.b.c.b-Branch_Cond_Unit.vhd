library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Branch_Cond_Unit is
	generic(N : integer);
	port( A         : in std_logic_vector(N-1 downto 0);
		  ALU_OPC   : in aluOp; -- coming from Control Unit
		  JUMP_TYPE : in std_logic_vector(1 downto 0);
		  PC_SEL    : out std_logic_vector(1 downto 0);
		  ZERO      : out std_logic);
end Branch_Cond_Unit;

architecture bhv of Branch_Cond_Unit is

begin
	Proc: process(A, ALU_OPC, JUMP_TYPE)
	begin
		case(JUMP_TYPE) is 
			when "00" => PC_SEL <= "00"; -- Not a jump : NPC
				ZERO <= '0';
			
			when "01" => if(ALU_OPC = BEQZS) then -- BEQZ/BNEZ : if taken, PC + IMM16, else NPC
					if(A = std_logic_vector(to_unsigned(0, A'length))) then -- Branch Equal
						PC_SEL <= "01"; -- PC + IMM16
						ZERO <= '1';
					else
						PC_SEL <= "00";
						ZERO <= '0';
					end if;
				else if(ALU_OPC = BNEZS) then
					if(A /= std_logic_vector(to_unsigned(0, A'length))) then -- Branch Not Equal
						PC_SEL <= "01";
						ZERO <= '1';
					else
						PC_SEL <= "00";
						ZERO <= '0';
					end if;
				else
					PC_SEL <= "00"; -- Default case, should not be reachable
					ZERO <= '0';
				end if;
				
			when "10" => PC_SEL <= "01"; -- J or JAL: PC + IMM26
				ZERO <= '1';
			
			when "11" => PC_SEL <= "10"; -- Absolute jump : PC <= A; (JALR/JR)
				ZERO <= '1';
			
			when others => PC_SEL <= "00";
				ZERO <= '0';
		end case;
	end process;
end bhv;