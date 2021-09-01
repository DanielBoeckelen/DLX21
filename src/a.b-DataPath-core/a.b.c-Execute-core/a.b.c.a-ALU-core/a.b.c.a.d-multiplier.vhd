library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use work.constants.all;

entity BOOTHMUL is
	generic( numBit: integer := NBIT/2);  
	port( A,B: in std_logic_vector(numBit-1 downto 0);
		  P: out std_logic_vector(2*numBit-1 downto 0));
end BOOTHMUL;

architecture mixed of BOOTHMUL is

	component booth_encoder is
		generic( numBit: integer := NBIT/2);
		port( B: in std_logic_vector(numBit-1 downto 0);
			  SEL_out: out std_logic_vector(3*(numBit/2)-1 downto 0));
	end component;

	component mux5to1 is
		generic( numBit: integer := NBIT/2);
		port( IN1, IN2, IN3, IN4, IN5: in std_logic_vector(numBit-1 downto 0);
			  SEL_in: in std_logic_vector(2 downto 0);
			  Z: out std_logic_vector(numBit-1 downto 0));
	end component;

	component rca_bhv is 
		generic (numBit  :	Integer := NBIT/2);
		Port (	A:	In	std_logic_vector(numBit-1 downto 0);
				B:	In	std_logic_vector(numBit-1 downto 0);
				Ci:	In	std_logic;
				S:	Out	std_logic_vector(numBit-1 downto 0);
				Co:	Out	std_logic);
	end component;

type muxVector is array (numBit/2-1 downto 0) of std_logic_vector(2*numBit-1 downto 0); -- Generating outputs of muxes and rcas as arrays for more clarity in the implementation
type sumVector is array (numBit/2-2 downto 0) of std_logic_vector(2*numBit-1 downto 0);

signal A_extend: std_logic_vector(2*numBit-1 downto 0) := (others => '0');
signal A_minus: std_logic_vector(2*numBit-1 downto 0) := (others => '0');
signal encoder_out: std_logic_vector(3*(numBit/2)-1 downto 0);
signal INtmp2, INtmp3, INtmp4, INtmp5: muxVector;
signal sum_op: muxVector;
signal rca_out: sumVector;

begin


--------------------------------------------------------------------------------
--                          Implementing Booth Encoder                        --
--------------------------------------------------------------------------------	
	encode: booth_encoder
		generic map(numBit => numBit)           
		port map(B => B, SEL_out => encoder_out);



--------------------------------------------------------------------------------
--                            Implementing MUX51                              --
--------------------------------------------------------------------------------

A_extend(2*numBit-1 downto numBit) <= (others => A(numBit-1));  -- extending multiplicand A to 2*N bits while using the sign bit of A  
A_extend(numBit-1 downto 0) <= A;								
A_minus <= not(A_extend) + '1';      -- generate -A in two's complement
	

mux_loop: for i in 0 to numBit/2-1 generate  -- loop to implement MUX51: the idea is to select a specific range of bits from A_extend and A_minus
	begin									 -- corresponding to the correct shifted version

		muxcase1: if i = 0 generate   -- generate inputs to the initial MUX5to1
			INtmp2(i) <= A_extend(2*numBit-1 downto 0); -- +A
			INtmp3(i) <= A_minus(2*numBit-1 downto 0); --  -A      
			INtmp4(i) <= A_extend(2*numBit-2 downto 0) & '0';-- +2A
			INtmp5(i) <= A_minus(2*numBit-2 downto 0) & '0'; -- -2A

			mux0: mux5to1 generic map(numBit => 2*numBit)   -- implementing the initial MUX5to1
				port map(IN1 => (others => '0'), 
						 IN2 => INtmp2(i), 
						 IN3 => INtmp3(i), 
						 IN4 => INtmp4(i), 
						 IN5 => INtmp5(i), 
						 SEL_in => encoder_out(3*i+2 downto 3*i), 
						 Z => sum_op(i));
		end generate muxcase1;

		muxcase2: if i > 0 generate  --generate imputs to the rest MUX5to1
			INtmp2(i)(2*numBit-1 downto 2*i) <= A_extend(2*numBit-1-2*i downto 0);		-- +4A, +16A, +64A, etc. 
			INtmp2(i)(2*i-1 downto 0) <= (others => '0');  
			INtmp3(i)(2*numBit-1 downto 2*i) <= A_minus(2*numBit-1-2*i downto 0);		-- -4A, -16A, -64A, etc. 
			INtmp3(i)(2*i-1 downto 0) <= (others => '0');  
			INtmp4(i)(2*numBit-1 downto 2*i+1) <= A_extend(2*numBit-2-2*i downto 0);	-- +8A, +32A, +128A, etc.
			INtmp4(i)(2*i downto 0) <= (others => '0');
			INtmp5(i)(2*numBit-1 downto 2*i+1) <= A_minus(2*numBit-2-2*i downto 0);		-- -8A, -32A, -128A, etc.
			INtmp5(i)(2*i downto 0) <= (others => '0');

			mux_i: mux5to1 generic map(numBit => 2*numBit)  -- implement the rest of MUX5to1
				port map(IN1 => (others => '0'), 
					IN2 => INtmp2(i), 
					IN3 => INtmp3(i), 
					IN4 => INtmp4(i), 
					IN5 => INtmp5(i), 
					SEL_in => encoder_out(3*i+2 downto 3*i), 
					Z => sum_op(i));
		end generate muxcase2;
end generate mux_loop;


--------------------------------------------------------------------------------
--                            Implementing RCA                                --
--------------------------------------------------------------------------------


sum_loop: for j in 0 to numBit/2-2 generate  -- loop to implement RCA

		sumcase1: if j = 0 generate   -- implement the initial RCA, which has as inputs the first two mux outputs
			rca0: rca_bhv generic map(numBit => 2*numBit)
				port map( A => sum_op(0), 
						  B => sum_op(1), 
						  Ci => '0', 
						  S => rca_out(j), 
						  Co => open);
		end generate sumcase1;


		sumcase_i: if j > 0 generate  -- implement the other RCAs
			rca_i: rca_bhv generic map(numBit => 2*numBit)
				port map( A => rca_out(j-1),  --value from the previous stage of RCA 
						  B => sum_op(j+1),   --output from MUX5to1
						  Ci => '0', 
						  S => rca_out(j), 
						  Co => open);
		end generate sumcase_i;
end generate sum_loop;

P <= rca_out(numBit/2-2);		-- final Product of A and B		

end mixed;
