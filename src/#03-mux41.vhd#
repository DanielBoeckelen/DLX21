library IEEE;
use IEEE.std_logic_1164.all;

entity mux41 is
	generic(N : integer);
	port( A : in std_logic_vector(N-1 downto 0);
		  B : in std_logic_vector(N-1 downto 0);
		  C : in std_logic_vector(N-1 downto 0);
		  D : in std_logic_vector(N-1 downto 0);
		  S : in std_logic_vector(1 downto 0);
		  Z : out std_logic_vector(N-1 downto 0));
end mux41;

architecture bhv of mux41 is
begin
	process(A, B, C, D, S)
	begin
		case S is
			when "00" => Z <= A;
			when "11" => Z <= B;
			when "01" => Z <= C;
			when "10" => Z <= D;
			when others => Z <= (others => '0');
		end case;
	end process;
end bhv;
