library ieee; 
use ieee.std_logic_1164.all;

entity Gblock is
	port (Pik, Gik, Gk_1j: in std_logic;
		  Gij: out std_logic);
end Gblock;

architecture bhv of Gblock is
begin

	Gij <= Gik or (Pik and Gk_1j);

end bhv;
