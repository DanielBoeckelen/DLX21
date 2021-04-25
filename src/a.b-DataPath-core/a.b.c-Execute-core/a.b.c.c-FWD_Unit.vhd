library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use work.constants.all;

entity FWD_Unit is
	port ( RST 	      : in std_logic;
		   ADD_RS1    : in std_logic_vector(NBIT_ADD-1 downto 0); -- From ID stage, for forwarding
		   ADD_RS2    : in std_logic_vector(NBIT_ADD-1 downto 0); -- From ID stage, for forwarding
		   ADD_WR_MEM : in std_logic_vector(NBIT_ADD-1 downto 0); -- MEM stage write address, for forwarding
		   ADD_WR_WB  : in std_logic_vector(NBIT_ADD-1 downto 0); -- WB stage write address, for forwarding
		   RF_WE_MEM  : in std_logic; -- RF Write signal for instruction currently in MEM stage
		   RF_WE_WB   : in std_logic; -- RF Write signal for instruction currently in WB stage
		   FWDA 	  : out std_logic_vector(1 downto 0); -- 00 OP1 from RF, 10 OP1 forwarded from EXMEM, 01 OP1 from MEMWB
		   FWDB 	  : out std_logic_vector(1 downto 0));  -- 00 OP2 from RF, 10 OP2 forwarded from EXMEM, 01 OP2 from MEMWB
end FWD_Unit;

architecture bhv of FWD_Unit is
begin
	process(RST, ADD_RS1, ADD_RS2, ADD_WR_MEM, ADD_WR_WB, RF_WE_MEM, RF_WE_WB)
	begin
		FWDA <= "11";
		FWDB <= "11";

		if (RST = '0') then
		FWDA <= (others => '0');
		FWDB <= (others => '0');
		else
			if(ADD_RS1 = ADD_WR_MEM) then
				if(RF_WE_MEM = '1' and ADD_WR_MEM /=  "00000") then
					FWDA <= "10";
				end if;
			elsif((ADD_RS1 = ADD_WR_WB) AND (ADD_WR_MEM /= ADD_RS1 OR RF_WE_MEM = '0')) then
				if(RF_WE_WB = '1' and ADD_WR_WB /=  "00000") then
					FWDA <= "01";
				end if;
			else
				FWDA <= "00";
			end if;

			if(ADD_RS2 = ADD_WR_MEM) then
				if(RF_WE_MEM = '1' and ADD_WR_MEM /=  "00000") then
					FWDB <= "10";
				end if;
			elsif((ADD_RS2 = ADD_WR_WB) AND (ADD_WR_MEM /= ADD_RS2 OR RF_WE_MEM = '0')) then
				if(RF_WE_WB = '1' and ADD_WR_WB /=  "00000") then
					FWDB <= "01";
				end if;
			else
				FWDB <= "00";
			end if;
		end if;
	end process;
end bhv;