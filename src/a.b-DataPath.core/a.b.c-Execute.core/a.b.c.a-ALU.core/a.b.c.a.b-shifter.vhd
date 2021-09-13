library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.constants.all;

entity shifter is
	generic(NBIT : integer);
	port( A           : in std_logic_vector(NBIT-1 downto 0); -- Operand to shift
	      B           : in std_logic_vector(NBIT-1 downto 0); -- Shift amount
	      LOGIC_ARITH : in std_logic;	-- 1 = logic, 0 = arith
	      LEFT_RIGHT  : in std_logic;	-- 1 = left, 0 = right
	      RES         : out std_logic_vector(NBIT-1 downto 0)
   );
end shifter;

architecture bhv of shifter is

begin
	SHIFT: process (A, B, LOGIC_ARITH, LEFT_RIGHT) is	
	begin
	   
	   if (to_integer(unsigned(B)) /= 0) then   
		if (LEFT_RIGHT = '0') then -- Shift right	
			if (LOGIC_ARITH = '0') then -- Arithmetic shift, SRA
                          RES <= std_logic_vector(shift_right(signed(A), to_integer(unsigned(B))));				
			else -- Logic shift, SRL
                           RES <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B))));	
			end if;
							
		else -- Shift left		
			 -- Logic shift, SLL 
                          RES <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B))));
		end if;
	  else
		RES <= A; -- If shift amount is zero, value remains unchanged
	  end if;
	end process;
end bhv;
