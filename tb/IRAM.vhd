library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.constants.all;

entity IRAM is
	port( CLK      : in std_logic;
		  RST 	   : in std_logic;
		  ADDR_IN  : in std_logic_vector(NBIT-1 downto 0); -- Instruction address from fetch stage
		  INS_OUT  : out std_logic_vector(NBIT-1 downto 0));	-- Instruction sent to fetch stage
end IRAM;

architecture bhv of IRAM is

-- Instruction memory array
type insmem is array (0 to MEM_size-1) of std_logic_vector(NBIT-1 downto 0);
signal IRAMmem : insmem;
	
begin
	process(RST, CLK, ADDR_IN)
	file mem_fp: text;
	variable text_line : line;
	variable index : integer;
	variable tmp : std_logic_vector(NBIT-1 downto 0);
	begin
		if(RST = '0') then
			INS_OUT <= (others => '0');
			file_open(mem_fp, path_IRAM, READ_MODE);
			index := 0;
			while (not endfile(mem_fp)) loop
				readline(mem_fp, text_line);
				hread(text_line, tmp);
				IRAMmem(index) <= tmp;       
				index := index + 1;
			end loop;
			file_close(mem_fp);
			for i in index to MEM_size-1 loop
				IRAMmem(i) <= (others => '0'); 
			end loop;
		elsif falling_edge(CLK) then
			INS_out <= IRAMmem(to_integer(unsigned(ADDR_IN)));
		end if;
	end process;
end bhv;