library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.constants.all;

entity DRAM is
	port( CLK      : in std_logic;
		  EN       : in std_logic;
		  RST      : in std_logic;
		  ADDR_IN  : in std_logic_vector(NBIT-1 downto 0);
		  DATA_IN  : in std_logic_vector(NBIT-1 downto 0);
		  DRAM_W   : in std_logic;
		  DRAM_R   : in std_logic;
		  DATA_OUT : out std_logic_vector(NBIT-1 downto 0));
end DRAM;

architecture bhv of DRAM is

-- Memory array definition
type datamem is array (0 to MEM_size-1) of std_logic_vector(NBIT-1 downto 0);
signal DRAMmem : datamem;

begin

	process(RST, CLK, EN)
	file mem_fp: text;
	variable data_line : line;
	variable index : integer;
	variable tmp : std_logic_vector(NBIT-1 downto 0);
	begin 
		if (RST = '0') then
			DATA_OUT <= (others => '0');
			file_open(mem_fp, path_DRAM, READ_MODE);
			index := 0;
			while (not endfile(mem_fp)) loop
				readline(mem_fp, data_line);
				hread(data_line, tmp);
				DRAMmem(index) <= tmp;       
				index := index + 1;
			end loop;
			file_close(mem_fp);
		elsif falling_edge(CLK) then
			if(EN = '1') then
				if(DRAM_R = '1') then -- Load
					DATA_OUT <= DRAMmem(to_integer(unsigned(ADDR_IN)));
				elsif(DRAM_W = '1') then -- Store
					DRAMmem(to_integer(unsigned(DATA_ADDR))) <= DATA_IN;
				end if;
			end if;
		end if;
	end process;
end bhv;