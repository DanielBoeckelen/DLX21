library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.constants.all;

entity comparator is
	generic(NBIT : integer);
	port( A     : in std_logic_vector(NBIT-1 downto 0);
		  B     : in std_logic_vector(NBIT-1 downto 0);
		  OPSel : in integer range 0 to 5;
		  RES   : out std_logic_vector(NBIT-1 downto 0));
end comparator;

architecture bhv of comparator is

  signal comp_state : comparator_OP := NOP;
  
begin
	Comp_Proc: process(A, B, OPSel)
	begin
		case(OPSel) is 
			when 0 => if(A = B) then -- Set on Equal
					--RES <= (others => '1');
					RES <= std_logic_vector(to_unsigned(1, RES'length));
                                        comp_state <= E;
				else
					RES <= (others => '0');
                                        comp_state <= E;
				end if;
			when 1 => if(A /= B) then -- Set on Not Equal
					--RES <= (others => '1');
					RES <= std_logic_vector(to_unsigned(1, RES'length));
                                        comp_state <= NE;
				else
					RES <= (others => '0');
                                        comp_state <= NE;
				end if;
			when 2 => if(A > B) then -- Set on Greater than
					--RES <= (others => '1');
					RES <= std_logic_vector(to_unsigned(1, RES'length));
                                        comp_state <= G;
				else
					RES <= (others => '0');
                                        comp_state <= G;
				end if;
			when 3 => if(A >= B) then -- Set on Greater Equal than
					--RES <= (others => '1');
					RES <= std_logic_vector(to_unsigned(1, RES'length));
                                        comp_state <= GE;
				else
					RES <= (others => '0');
                                        comp_state <= GE;
				end if;
			when 4 => if(A < B) then -- Set on Lower than
					--RES <= (others => '1');
					RES <= std_logic_vector(to_unsigned(1, RES'length));
                                        comp_state <= L;
				else
					RES <= (others => '0');
                                        comp_state <= L;
				end if;
			when 5 => if(A <= B) then -- Set on Lower Equal than
					--RES <= (others => '1');
					RES <= std_logic_vector(to_unsigned(1, RES'length));
                                        comp_state <= LE;
				else
					RES <= (others => '0');
                                        comp_state <= LE;
				end if;
			when others => RES <= (others => '0');
                                       comp_state <= NOP;
          
		end case;	
	end process;	 

end bhv;
