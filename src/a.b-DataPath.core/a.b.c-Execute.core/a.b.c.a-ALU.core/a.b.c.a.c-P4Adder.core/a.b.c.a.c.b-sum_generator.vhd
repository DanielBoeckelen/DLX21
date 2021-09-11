library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.constants.all;

entity SUM_GENERATOR is 
	generic( NBIT_PER_BLOCK : integer;
				 NBLOCKS : integer);
		port( A  : in std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
			  B  : in std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
			  Ci : in std_logic_vector(NBLOCKS-1 downto 0);
			  S  : out std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0));
end SUM_GENERATOR;

architecture structural of SUM_GENERATOR is



	component carry_select_basic is
		generic(N: integer := NBIT_PER_BLOCK);
		port(A,B: in std_logic_vector(N-1 downto 0);
			 C_i: in std_logic;
			 S: out std_logic_vector(N-1 downto 0));
	end component;

--------------------------------------------------------------------------------
--               Connecting Multiple Carry Select Block in series              --
--------------------------------------------------------------------------------
	begin
	
		SUMGEN1: for I in 1 to NBLOCKS generate
    	CSBI : carry_select_basic
		generic map(N => NBIT_PER_BLOCK)  
	 	Port Map (A => A((NBIT_PER_BLOCK*I-1) downto (NBIT_PER_BLOCK*(I-1))), 
	 			  B => B((NBIT_PER_BLOCK*I-1) downto (NBIT_PER_BLOCK*(I-1))), 
	 			  C_i => Ci(I-1), 
	 			  S => S((NBIT_PER_BLOCK*I-1) downto (NBIT_PER_BLOCK*(I-1)))); 
  		end generate;

end structural;
