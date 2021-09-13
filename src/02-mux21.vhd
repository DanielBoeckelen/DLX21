library IEEE;
use IEEE.std_logic_1164.all;
use work.constants.all;

entity mux21 is -- Generic N-bit 2-to-1 multiplexer
	generic(NBIT : integer);
	port( A : in std_logic_vector(NBIT-1 downto 0);
		  B : in std_logic_vector(NBIT-1 downto 0);
		  S : in std_logic;
		  Z : out std_logic_vector(NBIT-1 downto 0));
end mux21;

architecture bhv of mux21 is
begin
	process(A, B, S)
	begin
		case S is
			when '0' => Z <= A;
			when '1' => Z <= B;
			when others => Z <= (others => '0');
		end case;
	end process;
end bhv;
