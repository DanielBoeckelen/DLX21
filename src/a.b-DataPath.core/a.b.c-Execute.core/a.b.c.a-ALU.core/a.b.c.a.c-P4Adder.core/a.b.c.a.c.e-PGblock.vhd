library ieee; 
use ieee.std_logic_1164.all;

entity PGblock is
	port (Pik, Gik, Pk_1j, Gk_1j: in std_logic;
		  Pij, Gij: out std_logic);
end PGblock;

architecture bhv of PGblock is
begin
	Pij <= Pik and Pk_1j;
	Gij <= Gik or (Pik and Gk_1j);

end bhv;
