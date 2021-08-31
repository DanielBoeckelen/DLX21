library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.constants.all;

-- Data memory for DLX
-- Memory filled by a process which reads from a file
-- file name is "data.mem"
entity DRAM is
  generic (
    RAM_DEPTH : integer := MEM_size;
    D_SIZE : integer := NBIT);
  port (
    En       : in std_logic;
    Rst      : in std_logic;
    ADDR_IN  : in std_logic_vector(D_SIZE-1 downto 0);
	DATA_IN  : in std_logic_vector(D_SIZE-1 downto 0);
	DRAM_W   : in std_logic;
	DRAM_R   : in std_logic;
	DATA_OUT : out std_logic_vector(D_SIZE-1 downto 0)
    );
end DRAM;

architecture DRam_Bhe of DRAM is


----------------------------------------FROM DESCRIPTION---------------------------------------


  --type RAMtype is array (0 to RAM_DEPTH - 1) of std_logic_vector(NBIT-1 downto 0);

  --signal DRAM_mem : RAMtype := (
  --x"00000007",
  --x"F0030001",
  --x"000000A3",
  --x"0CD10030",
  --x"00000009",
  --x"000000D0",
  --x"0000000C",
  --x"0E83AAA0",
  --x"00000045",
  --x"00003000",
  --x"00000000",
  --x"F3F3F3F3"
--);

--begin  -- DRam_Bhe

  --Dout <= DRAM_mem(conv_integer(unsigned(Addr)));

  --RESET_MEM_P: process(Rst)
    --begin

      --if (Rst = '0') then
      -- DRAM_mem <= (others => (others => '0'));
      --end if;
      
  --end process;

-------------------------------------------WRITE RESULTS TO A FILE-------------------------------------------

  type RAMtype is array (0 to RAM_DEPTH - 1) of std_logic_vector(D_SIZE-1 downto 0);
  signal DRAMmem : RAMtype;

  begin  -- DRam_Bhe
  
    RW_DRAM: process(En, Rst, DRAM_W, DRAM_R)
    file mem_fp: text;
	variable data_line : line;
	variable index : integer;
	variable tmp : std_logic_vector(D_SIZE-1 downto 0);
	begin 
		if (Rst = '0') then
			DATA_OUT <= (others => '0');
			file_open(mem_fp, "../mem/data.mem", READ_MODE);
			index := 0;
			while (not endfile(mem_fp)) loop
				readline(mem_fp, data_line);
				hread(data_line, tmp);
				DRAMmem(index) <= tmp;       
				index := index + 1;
			end loop;
			file_close(mem_fp);
		elsif(En = '1') then
			if(DRAM_R = '1') then -- Load
				DATA_OUT <= DRAMmem(to_integer(unsigned(ADDR_IN)));
			elsif(DRAM_W = '1') then -- Store
				DRAMmem(to_integer(unsigned(ADDR_IN))) <= DATA_IN;
			end if;
		end if;
	end process RW_DRAM;
      
end DRam_Bhe;
