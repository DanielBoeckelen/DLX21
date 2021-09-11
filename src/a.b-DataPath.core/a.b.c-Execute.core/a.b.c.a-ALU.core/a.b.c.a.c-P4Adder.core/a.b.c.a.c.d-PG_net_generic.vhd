library ieee; 
use ieee.std_logic_1164.all;

entity PG_net is
 		port (a,b: in std_logic;
 			  p,g: out std_logic);
end PG_net;

architecture bhv of PG_net is
begin
	p <= a xor b;
	g <= a and b;
end bhv; 
