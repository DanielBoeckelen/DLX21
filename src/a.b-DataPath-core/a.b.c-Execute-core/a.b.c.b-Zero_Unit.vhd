library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ZeroUnit is
	generic(N : integer);
	port( A       : in std_logic_vector(N-1 downto 0);
		  ALU_OPC : in aluOp; -- coming from Control Unit
		  ZERO    : out std_logic);
end ZeroUnit;

architecture bhv of ZeroUnit is

begin
	Proc: process(A, ALU_OPC)
	begin
		case(ALU_OPC) is 
			when BEQZS => if(A = std_logic_vector(to_unsigned(0, A'length))) then -- Branch Equal
					ZERO <= '1';
				else
					ZERO <= '0';
				end if;
			when BNEZS => if(A /= std_logic_vector(to_unsigned(0, A'length))) then -- Branch Not Equal
					ZERO <= '1';
				else
					ZERO <= '0';
				end if;
			when others => ZERO <= '0';
		end case;
	end process;
end bhv;