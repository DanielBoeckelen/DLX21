library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use work.constants.all;

entity register_file is
 generic( NBIT_ADD: integer;
		  NBIT_DATA: integer);
 port ( CLK: 		IN std_logic;
        RESET: 	        IN std_logic;
        ENABLE: 	IN std_logic;
        WR: 		IN std_logic;
        ADD_WR: 	IN std_logic_vector(NBIT_ADD-1 downto 0);
        ADD_RD1: 	IN std_logic_vector(NBIT_ADD-1 downto 0);
        ADD_RD2: 	IN std_logic_vector(NBIT_ADD-1 downto 0);
        DATAIN: 	IN std_logic_vector(NBIT_DATA-1 downto 0);
        OUT1: 		OUT std_logic_vector(NBIT_DATA-1 downto 0);
        OUT2: 		OUT std_logic_vector(NBIT_DATA-1 downto 0));
end register_file;

architecture A of register_file is

        
        subtype REG_ADDR is natural range 0 to (2**NBIT_ADD - 1); -- using natural type
	type REG_ARRAY is array(REG_ADDR) of std_logic_vector(NBIT_DATA-1 downto 0); 
	signal REGISTERS : REG_ARRAY;

        signal state_RF: RF_OP := NOP;

	
begin 

  --sequential part
	proc: process(CLK)
	begin
		if(CLK = '1' and CLK'event) then
			if(RESET = '0') then -- Synchronous reset, active low
				REGISTERS <= (others => (others => '0')); -- The whole array is reset to zero
                                state_RF <= resetting;
			else
				if(ENABLE = '1') then -- Enable active high, read and write can be simultaneous

					if(WR = '1') then -- write to register
						REGISTERS(to_integer(unsigned(ADD_WR))) <= DATAIN;
                                                state_RF <= writing;                            
                else
                   state_RF <= reading;
                
					end if;
                          
				end if; --enable
                                
			end if; --reset                  
		end if;
	end process proc;

  --combinational part
        OUT1 <= REGISTERS(to_integer(unsigned(ADD_RD1)));
        OUT2 <= REGISTERS(to_integer(unsigned(ADD_RD2)));

end A;

----


configuration CFG_RF_BEH of register_file is
  for A
  end for;
end configuration;
