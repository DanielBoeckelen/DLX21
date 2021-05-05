library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.constants.all;

-- Data memory for DLX
-- Memory filled by a process which reads from a file
-- file name is "data.mem"
entity DRAM is
  generic (
    RAM_DEPTH : integer := MEM_size;
    I_SIZE : integer := NBIT);
  port (
    Rst  : in  std_logic;
    Addr : in  std_logic_vector(NBIT - 1 downto 0);
    Dout : out std_logic_vector(NBIT - 1 downto 0)
    );

end IRAM;

architecture IRam_Bhe of IRAM is


----------------------------------------FROM DESCRIPTION---------------------------------------


  type RAMtype is array (0 to RAM_DEPTH - 1) of std_logic_vector(NBIT-1 downto 0);

  signal DRAM_mem : RAMtype := (
  x"00000007",
  x"F0030001",
  x"000000A3",
  x"0CD10030",
  x"00000009",
  x"000000D0",
  x"0000000C",
  x"0E83AAA0",
  x"00000045",
  x"00003000",
  x"00000000",
  x"F3F3F3F3"
);

begin  -- DRam_Bhe

  Dout <= DRAM_mem(conv_integer(unsigned(Addr)));

  RESET_MEM_P: process(Rst)
    begin

      if (Rst = '0') then
       DRAM_mem <= (others => (others => '0'));
      end if;
      
  end process;

-------------------------------------------WRITE RESULTS TO A FILE-------------------------------------------

  --type RAMtype is array (0 to RAM_DEPTH - 1) of integer;-- std_logic_vector(NBIT-1 downto 0);

  --signal DRAM_mem : RAMtype;
  -- file file_RESULTS : text;
  --file_open(file_RESULTS, "DRAM_results.txt", write_mode);

--begin  -- DRam_Bhe

  --Dout <= conv_std_logic_vector(DRAM_mem(conv_integer(unsigned(Addr))),NBIT);
 
 --write_on_file_P : process(Addr)

   -- variable v_OLINE : line;
    
  -- begin

    --  write(v_OLINE, Dout, right, NBIT);
    --  writeline(file_RESULTS, v_OLINE);

 --end process write_on_file_P;

   --file_close(file_RESULTS);
      
--end DRam_Bhe;
