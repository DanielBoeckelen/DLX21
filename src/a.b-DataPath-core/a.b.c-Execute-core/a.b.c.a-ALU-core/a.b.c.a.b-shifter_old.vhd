library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
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
	   
	   if (conv_integer(B) /= 0) then   
		if (LEFT_RIGHT = '0') then -- Shift right
		
			if (LOGIC_ARITH = '0') then -- Arithmetic shift, SRA

                           RES(NBIT-1-conv_integer(B) downto 0) <= A(NBIT-1 downto conv_integer(B));
                           RES(NBIT-1 downto NBIT-conv_integer(B)) <= (others => A(NBIT-1));
				
			else -- Logic shift, SRL

                           RES(NBIT-1-conv_integer(B) downto 0) <= A(NBIT-1 downto conv_integer(B));
                           RES(NBIT-1 downto NBIT-conv_integer(B)) <= (others => '0');
				
			end if;
							
		else -- Shift left
		
			 -- Logic shift, SLL
    
                           RES(NBIT-1 downto conv_integer(B)) <= A(NBIT-1-conv_integer(B) downto 0);
                           RES(conv_integer(B) downto 0) <= (others => '0');

		end if;
	  else
		RES <= A;
	  end if;
	end process;
end bhv;
