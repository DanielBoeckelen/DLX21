library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity mux5to1 is
	generic( numBit: integer := NBIT/2);
	port( IN1, IN2, IN3, IN4, IN5: in std_logic_vector(numBit-1 downto 0);
		  SEL_in: in std_logic_vector(2 downto 0);
		  Z: out std_logic_vector(numBit-1 downto 0));
end mux5to1;

architecture bhv of mux5to1 is
begin


 
	process(SEL_in,IN1, IN2, IN3, IN4, IN5) is -- Selection based on the table of Booth's algorithm
	begin
      	if (SEL_in = "000") then
           Z <= IN1;
	    elsif (SEL_in = "001") then
          Z <= IN2;
		elsif (SEL_in = "010") then
           Z <= IN2;
		elsif (SEL_in = "011") then
          Z <= IN4;
		elsif (SEL_in = "100") then
          Z <= IN5;
		elsif (SEL_in = "101") then
         Z <= IN3;
		elsif (SEL_in = "110") then
          Z <= IN3;
		elsif (SEL_in = "111") then
         Z <= IN1;
         else  Z <= (others=>'Z');
		end if;

 end process;
end bhv;
