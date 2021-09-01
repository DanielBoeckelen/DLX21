library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use work.constants.all;

entity rca_bhv is 
	generic (numBit  :	Integer := NBIT/2);
	Port (	A:	In	std_logic_vector(numBit-1 downto 0);
		B:	In	std_logic_vector(numBit-1 downto 0);
		Ci:	In	std_logic;
		S:	Out	std_logic_vector(numBit-1 downto 0);
		Co:	Out	std_logic);
end rca_bhv; 

architecture BEHAVIORAL of rca_bhv is					--behavioral description of RCA
signal A1: std_logic_vector(numBit downto 0); --A1, B1, S1 are used to extend the operands and the result to N+1 bits
signal B1: std_logic_vector(numBit downto 0); --to allow for the presence of the output carry
signal S1: std_logic_vector(numBit downto 0);

begin

	process(A,B)
	begin
		if (A(numBit-1) = '0') then
			A1 <= '0' & A; -- Operands are extended by using the append operand &
		else
			A1 <= '1' & A;
		end if;
		if (B(numBit-1) = '0') then
			B1 <= '0' & B;
		else
			B1 <= '1' & B;
		end if;
	end process;
	S1 <= (A1 + B1 + Ci);
	S <= S1(numBit-1 downto 0);
	Co <= S1(numBit); -- The output carry is the MSB of S1
    
end BEHAVIORAL;
