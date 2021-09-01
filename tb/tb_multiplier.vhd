library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use work.constants.all;

entity MULTIPLIER_tb is
end MULTIPLIER_tb;


architecture TEST of MULTIPLIER_tb is


  constant numBit : integer := NBIT/2;    

  --  input	 
  signal A_mp_i : std_logic_vector(numBit-1 downto 0) := (others => '0');
  signal B_mp_i : std_logic_vector(numBit-1 downto 0) := (others => '0');

  -- output
  signal result_mp_i : std_logic_vector(2*numBit-1 downto 0);


-- MUL component declaration
	component BOOTHMUL is
	generic( numBit: integer := NBIT/2);
	port( A,B: in std_logic_vector(numBit-1 downto 0);
		    P: out std_logic_vector(2*numBit-1 downto 0));
	end component;


begin


-- MUL instantiation
	myMUL: BOOTHMUL generic map(numBit => numBit)
		port map(A => A_mp_i, B => B_mp_i, P => result_mp_i);



-- PROCESS FOR TESTING TEST - COMPLETE CYCLE ---------
  test: process
  begin
    			-- cycle for operand A
    NumROW : for i in 0 to 2**(numBit/2)-1 loop  
				  -- cycle for operand B
	

		        NumCOL_pos : for i in 0 to 2**(numBit/2) loop     
	              B_mp_i <= B_mp_i + '1';       -- generate B in positive value
			--    B_mp_i <= B_mp_i - '1' ;	    -- generate B in negative value 
  		          wait for 10 ns;
	              end loop NumCOL_pos ;
	   
        
        A_mp_i <= A_mp_i + '1';            --generate A in positive value
    --  A_mp_i <= A_mp_i - '1';            --generate A in negative value
      --  A_mp_i <= A_mp_i + 2**(numBit/2);  --generate A in large positive value
	 	
    end loop NumROW ;
    wait;          
  end process test;


end TEST;
