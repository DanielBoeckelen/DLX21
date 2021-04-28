library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.constants.all;
--------------------------------------------------------------------------------
--               This Testbench is used to test 32bit Adder                   --
--------------------------------------------------------------------------------
entity TB_P4ADDER is
end TB_P4ADDER;

architecture TEST of TB_P4ADDER is


constant NBIT: integer := NBIT;
signal A1, B1, S1: std_logic_vector(NBIT-1 downto 0);
signal Carry_gen1: std_logic_vector(NBLOCKS-1 downto 0);
signal Cin1, Cout1: std_logic;
	
	-- P4 component declaration
	component P4Adder is
		generic (
			NBIT :		integer := NBIT);
		port (
			A :		in	std_logic_vector(NBIT-1 downto 0);
			B :		in	std_logic_vector(NBIT-1 downto 0);
			Cin :	in	std_logic;
			S :		out	std_logic_vector(NBIT-1 downto 0);
			Cout :	out	std_logic;
			Carry_gen : out std_logic_vector((NBIT/NBIT_PER_BLOCK)-1 downto 0));
	end component;


	
begin
	-- P4 instantiation
	P4test: P4Adder
		generic map(NBIT => NBIT)
		port map(A => A1, B => B1, Cin => Cin1, S => S1, Cout => Cout1, Carry_gen => Carry_gen1);

	stim: process
		begin
			A1 <= x"0000_0000";
			B1 <= x"0000_0001";
			Cin1 <= '0';
			wait for 5 ns;
			A1 <= x"0000_0000";
			B1 <= x"0000_0001";
			Cin1 <= '1';
			wait for 5 ns;
			A1 <= x"0000_0008";
			B1 <= x"0000_0009";
			Cin1 <= '0';
			wait for 5 ns;
			A1 <= x"8300_0300";
			B1 <= x"800A_0050"
			Cin1 <= '1';
			wait for 2.5 ns;
			Cin1 <= '0';
			wait for 2.5 ns;
			A1 <= x"FFFF_FFFF";
			B1 <= x"0000_0001";
			Cin1 <= '0';
			wait for 5 ns;
			A1 <= x"FFFF_FFFF";
			B1 <= x"FFFF_FFFF";
			Cin1 <= '1';
			wait for 5 ns;
		end process;
	
end TEST;

configuration P4ADDERTEST of TB_P4ADDER is
  for TEST
  end for;
end P4ADDERTEST;
