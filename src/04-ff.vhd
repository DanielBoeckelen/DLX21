library IEEE;
use IEEE.std_logic_1164.all;

entity ff is
	port( D   : in std_logic;
		  CLK : in std_logic;
		  EN  : in std_logic;
		  RST : in std_logic;
		  Q   : out std_logic);
end ff;

architecture bhv of ff is
begin
	process(CLK, EN, RST)
	begin
		if(RST = '0') then
			Q <= '0';
		elsif(CLK = '1' and CLK'event) then
			if(EN = '1') then
				Q <= D;
			end if;
		end if;
	end process;
end bhv;
