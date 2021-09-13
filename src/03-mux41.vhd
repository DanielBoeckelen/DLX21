library IEEE;
use IEEE.std_logic_1164.all;
use work.constants.all;

entity mux41 is -- Generic N-bit 4-to-1 multiplexer
	generic(NBIT : integer);
	port( A : in std_logic_vector(NBIT-1 downto 0);
		  B : in std_logic_vector(NBIT-1 downto 0);
		  C : in std_logic_vector(NBIT-1 downto 0);
		  D : in std_logic_vector(NBIT-1 downto 0);
		  S : in std_logic_vector(1 downto 0);
		  Z : out std_logic_vector(NBIT-1 downto 0));
end mux41;

architecture bhv of mux41 is
begin
	process(A, B, C, D, S)
	begin
		case S is
			when "00" => Z <= A;
			when "01" => Z <= B;
			when "10" => Z <= C;
			when "11" => Z <= D;
			when others => Z <= (others => '0');
		end case;
	end process;
end bhv;
