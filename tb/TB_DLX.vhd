library IEEE;

use IEEE.std_logic_1164.all;
use WORK.all;

entity tb_dlx is
end tb_dlx;

architecture TEST of tb_dlx is


    constant SIZE_IR      : integer := 32;       -- Instruction Register Size
    constant SIZE_PC      : integer := 32;       -- Program Counter Size
    constant SIZE_ALU_OPC : integer := 6;        -- ALU Op Code Word Size in case explicit coding is used
    signal Clock: std_logic := '0';
    signal Reset: std_logic := '1';

    component DLX
       generic (
       IR_SIZE      : integer := 32;       -- Instruction Register Size
       PC_SIZE      : integer := 32       -- Program Counter Size
       );  	   -- ALU_OPC_SIZE is explicit ALU Op Code Word Size
       port (
       Clk : in std_logic;
       Rst : in std_logic);                -- Active Low
    end component;
begin


        -- instance of DLX
	U1: DLX
        Generic Map (SIZE_IR, SIZE_PC) -- SIZE_ALU_OPC)   
	Port Map (Clock, Reset);
	

        PCLOCK : process(Clock)
	begin
		Clock <= not(Clock) after 0.5 ns;	
	end process;
	
	Reset <= '0', '1' after 6 ns, '0' after 11 ns, '1' after 14 ns; --15 ns was the original, and it was coincident with the clock rising edge;
	-- this caused the first instruction to be ignored. Should be looked into it at some point. The issue makes sense, but the DLX should work
	-- independently of when the reset is driven
       

end TEST;

-------------------------------

configuration CFG_TB of tb_dlx  is
	for TEST
	end for;
end CFG_TB;

