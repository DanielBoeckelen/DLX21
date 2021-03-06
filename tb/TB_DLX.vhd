library IEEE;

use IEEE.std_logic_1164.all;
use WORK.all;

entity tb_dlx is
end tb_dlx;

architecture TEST of tb_dlx is


    constant SIZE_IR      : integer := 32;       -- Instruction Register Size
    constant SIZE_PC      : integer := 32;       -- Program Counter Size
    signal Clock: std_logic := '0';
    signal Reset: std_logic := '1';

    component DLX
       generic (
       IR_SIZE      : integer := 32;       -- Instruction Register Size
       PC_SIZE      : integer := 32       -- Program Counter Size
       );
       port (
       Clk : in std_logic;
       Rst : in std_logic);                -- Active Low
    end component;
begin


        -- instance of DLX
	U1: DLX
        Generic Map (SIZE_IR, SIZE_PC) 
	Port Map (Clock, Reset);
	

        PCLOCK : process(Clock)
	begin
		Clock <= not(Clock) after 0.5 ns;	
	end process;

    Reset <= '0', '1' after 6 ns;

end TEST;

-------------------------------

configuration CFG_TB of tb_dlx  is
	for TEST
	end for;
end CFG_TB;

