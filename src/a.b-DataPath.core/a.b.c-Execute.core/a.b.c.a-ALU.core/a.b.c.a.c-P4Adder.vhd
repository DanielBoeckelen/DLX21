library ieee; 
use ieee.std_logic_1164.all;
use work.constants.all;

entity P4Adder is
	generic(NBIT : integer);
	port( A         : in std_logic_vector(NBIT-1 downto 0); -- operand A
		  B         : in std_logic_vector(NBIT-1 downto 0); -- operand B
		  Cin       : in std_logic;  -- C_0
		  S         : out std_logic_vector(NBIT-1 downto 0); -- sum
		  Cout      : out std_logic);  -- carry out of the P4 adder
end P4Adder;

architecture struct of P4Adder is

	component carry_generator is
		generic(NBIT : integer;
				NBIT_PER_BLOCK : integer);
		port ( A   : in std_logic_vector(NBIT downto 1);
			   B   : in std_logic_vector(NBIT downto 1);
			   Cin : in std_logic;
			   Co  : out std_logic_vector((NBIT/NBIT_PER_BLOCK)-1 downto 0));
	end component;

	component SUM_GENERATOR is 
		generic( NBIT_PER_BLOCK : integer;
				 NBLOCKS : integer);
		port( A  : in std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
			  B  : in std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
			  Ci : in std_logic_vector(NBLOCKS-1 downto 0);
			  S  : out std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0));
	end component;

signal Ctmp: std_logic_vector(NBLOCKS-1 downto 0);
signal Csum: std_logic_vector(NBLOCKS-1 downto 0);

begin

	Csum <= Ctmp(NBLOCKS-2 downto 0) & Cin; -- MSB of carry generation is the carry out of P4 Adder 
											-- Cin is c_0 as specified in Figure 2.1 & Figure 2.2 in Lab2 instruction
	Carrygen0: carry_generator
		generic map(NBIT => NBIT, NBIT_PER_BLOCK => NBIT_PER_BLOCK)
		port map(A => A, B => B, Cin => Cin, Co => Ctmp);

	Sumgen0: SUM_GENERATOR
		generic map(NBIT_PER_BLOCK => NBIT_PER_BLOCK, NBLOCKS => NBLOCKS)
		port map(A => A, B => B, Ci => Csum, S => S);

	Cout <= Ctmp(NBLOCKS-1);  -- Carry out of the P4 Adder

end struct;
