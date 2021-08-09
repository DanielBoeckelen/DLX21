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
    
signal shf_state : shifter_OP := NOP;
--signal shf: integer := 0;
--signal msb: std_logic := '0';

begin
	SHIFT: process (A, B, LOGIC_ARITH, LEFT_RIGHT) is
	   
	  variable shf: integer := 0;
      variable msb : std_logic := '0';
	
	begin
	   
	   shf := conv_integer(B);
	   msb := A(NBIT-1);

	   if (shf /= 0) then   
		if (LEFT_RIGHT = '0') then -- Shift right
		
			if (LOGIC_ARITH = '0') then -- Arithmetic shift, SRA
				--RES <= to_StdLogicVector((to_bitvector(A)) sra (conv_integer(B)));

                           RES(NBIT-1-shf downto 0) <= A(NBIT-1 downto shf);
                           RES(NBIT-1 downto NBIT-shf) <= (others => msb);

                           shf_state <= Arith_Right; 
				
			else -- Logic shift, SRL
				--RES <= to_StdLogicVector((to_bitvector(A)) srl (conv_integer(B)));

                           RES(NBIT-1-shf downto 0) <= A(NBIT-1 downto shf);
                           RES(NBIT-1 downto NBIT-shf) <= (others => '0');

                           shf_state <= Logic_Right;
				
			end if;
							
		else -- Shift left
		
			 -- Logic shift, SLL
				--RES <= to_StdLogicVector((to_bitvector(A)) sll (conv_integer(B)));

                           RES(NBIT-1 downto shf) <= A(NBIT-1-shf downto 0);
                           RES(shf downto 0) <= (others => '0');

                           shf_state <= Logic_Arith_Left;
		end if;
	  else
		RES <= A;
	  end if;
	end process;
end bhv;
