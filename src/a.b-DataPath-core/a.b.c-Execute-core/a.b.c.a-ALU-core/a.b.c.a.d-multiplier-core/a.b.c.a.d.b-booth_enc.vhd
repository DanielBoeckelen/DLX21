library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity booth_encoder is
	generic( numBit: integer := NBIT/2);   
	port( B: in std_logic_vector(numBit-1 downto 0);
		  SEL_out: out std_logic_vector(numBit/2*3-1 downto 0));
end booth_encoder;

architecture structural of booth_encoder is

signal Btmp : std_logic_vector(numBit/2*3-1 downto 0);

begin


--------------------------------------------------------------------------------
--         Separating multiplicand B & Generating Select signal             --
--------------------------------------------------------------------------------


Btmp(0) <= '0';     -- Since the minus 1 bit should be taken into the sequence as zero,
Btmp(1) <= B(0);	-- it's better to specify the first 3 bits of sequence Btmp
Btmp(2) <= B(1);


encoder_separateB: for i in 1 to numBit/2-1 generate    -- Generating the rest of the bits of sequence Btmp
		Btmp(3*i)	<= B(2*i-1);
		Btmp(3*i+1)	<= B(2*i);
		Btmp(3*i+2)	<= B(2*i+1);
end generate encoder_separateB;


SEL_out <= Btmp;    -- Btmp is indeed the SEL signal to mux5to1

end structural;
