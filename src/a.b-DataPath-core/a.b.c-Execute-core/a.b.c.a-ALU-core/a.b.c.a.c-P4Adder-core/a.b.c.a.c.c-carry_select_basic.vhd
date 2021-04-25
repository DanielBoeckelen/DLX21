library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.constants.all;

entity carry_select_basic is
	generic(N: integer);
	port( A, B : in std_logic_vector(N-1 downto 0);
		  C_i  : in std_logic;
		  S    : out std_logic_vector(N-1 downto 0));
end carry_select_basic;


--------------------------------------------------------------------------------
--                  Implement Single Carry Select Block                       --
--------------------------------------------------------------------------------
architecture struct of carry_select_basic is
	component RCA is
		generic (N  :	Integer := NBIT_PER_BLOCK);
		Port (	A:	In	std_logic_vector(N-1 downto 0);
				B:	In	std_logic_vector(N-1 downto 0);
				Ci:	In	std_logic;
				S:	Out	std_logic_vector(N-1 downto 0);
				Co:	Out	std_logic);
	end component;

	signal Y1, Y2: std_logic_vector(N-1 downto 0);

	begin
		
		RCA0: RCA
		generic map(N => NBIT_PER_BLOCK)
		port map(A => A, B => B, Ci => '0', S => Y1, Co => open);  --condition with select signal is 0
		
		RCA1: RCA
		generic map(N => NBIT_PER_BLOCK)
		port map(A => A, B => B, Ci => '1', S => Y2, Co => open);  --condition with select signal is 1

		S <= Y2 when C_i = '1' else Y1;  -- the selected output is part of the final sum

end struct;

configuration CFG_CSB of carry_select_basic is
for struct
	for all: RCA
		use configuration WORK.CFG_RCA_STRUCTURAL;
	end for;
end for;
end CFG_CSB;
