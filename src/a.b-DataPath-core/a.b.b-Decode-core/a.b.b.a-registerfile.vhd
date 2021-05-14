library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use work.constants.all;

entity register_file is
 generic( NBIT_ADD: integer;
		  NBIT_DATA: integer);
 port ( CLK: 		IN std_logic;
        RST: 	IN std_logic;
	 	ENABLE: 	IN std_logic;
	 	RD1: 		IN std_logic;
	 	RD2: 		IN std_logic;
	 	WR: 		IN std_logic;
	 	ADD_WR: 	IN std_logic_vector(NBIT_ADD-1 downto 0);
	 	ADD_RS1: 	IN std_logic_vector(NBIT_ADD-1 downto 0);
	 	ADD_RS2: 	IN std_logic_vector(NBIT_ADD-1 downto 0);
	 	DATAIN: 	IN std_logic_vector(NBIT_DATA-1 downto 0);
        OUT1: 		OUT std_logic_vector(NBIT_DATA-1 downto 0);
	 	OUT2: 		OUT std_logic_vector(NBIT_DATA-1 downto 0));
end register_file;

architecture bhv of register_file is

        
        subtype REG_ADDR is natural range 0 to (2**NBIT_ADD - 1); -- using natural type
	type REG_ARRAY is array(REG_ADDR) of std_logic_vector(NBIT_DATA-1 downto 0); 
	signal REGISTERS : REG_ARRAY;

        --signal state_RF: RF_OP := NOP;

	
begin 
 
	proc: process(CLK, RST)
	begin
		if(RST = '0') then -- Asynchronous, active low
			REGISTERS <= (others => (others => '0')); -- The whole array is reset to zero
		elsif(CLK = '1' and CLK'event) then
			if(ENABLE = '1') then -- Enable active high, read and write can be simultaneous
				if(WR = '1') then -- write to register
					REGISTERS(to_integer(unsigned(ADD_WR))) <= DATAIN;
				end if;

				if(RD1 = '1') then -- read from register, port 1
					if (WR = '1') and (ADD_WR = ADD_RS1) then
						OUT1 <= DATAIN; --if the data to be written is needed as a source for the current instruction,
								-- it is directly provided to the output of the register file
					else
						OUT1 <= REGISTERS(to_integer(unsigned(ADD_RS1)));
					end if;
				end if;

				if(RD2 = '1') then -- read from register, port 2
					if (WR = '1') and (ADD_WR = ADD_RS2) then
						OUT2 <= DATAIN;--if the data to be written is needed as a source for the current instruction,
								-- it is directly provided to the output of the register file
					else
						OUT2 <= REGISTERS(to_integer(unsigned(ADD_RS2)));
					end if;
				end if;
			end if;
		end if;
	end process proc;

end bhv;
