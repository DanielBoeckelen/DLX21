library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
--use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.constants.all;
use work.instruction_set.all;

-- Instruction memory for DLX
-- Memory filled by a process which reads from a file
-- file name is "test.asm.mem"
entity IRAM is
  generic (
    RAM_DEPTH : integer := MEM_size;
    I_SIZE : integer := NBIT);
  port (
    Rst  : in  std_logic;
    Addr : in  std_logic_vector(I_SIZE - 1 downto 0);
    Iout : out std_logic_vector(I_SIZE - 1 downto 0)
    );
end IRAM;

architecture IRam_Bhe of IRAM is

-----------------------------------------------FROM DESCRIPTION------------------------------------------------------  

  --type RAMtype is array (0 to RAM_DEPTH - 1) of std_logic_vector(I_SIZE-1 downto 0);

  --signal IRAM_mem : RAMtype; -- := (
  --x"00A30F81",
  --x"00000000",
  --x"00000000",
  --x"0CD10030",
 -- x"00000000",
  --x"00000000",
  --x"00000000",
  --x"0E83AAA0",
  --x"00000000",
  --x"00000000",
  --x"00000000",
  --x"F3F3F3F3"
--);

--begin  -- IRam_Bhe

  --Iout <= IRAM_mem(conv_integer(unsigned(Addr)));

  --RESET_MEM_P: process(Rst)
    --begin

     --if (Rst = '0') then
       --IRAM_mem <= (others => (others => '0'));
      --end if;
      
  --end process;

  --------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------FROM FILE--------------------------------------------------------------------

  
  type RAMtype is array (0 to RAM_DEPTH - 1) of integer;-- std_logic_vector(NBIT-1 downto 0);

  signal IRAM_mem : RAMtype := (others => 0);

begin  -- IRam_Bhe

  Iout <= conv_std_logic_vector(IRAM_mem(conv_integer(unsigned(Addr))/4), I_SIZE);
  -- purpose: This process is in charge of filling the Instruction RAM with the firmware
  -- type   : combinational
  -- inputs : Rst
  -- outputs: IRAM_mem
  
  FILL_MEM_P: process (Rst, Addr)
    file mem_fp: text;
    variable file_line : line;
    variable index : integer := 0;
    variable tmp_data_u : std_logic_vector(I_SIZE-1 downto 0);
  begin  -- process FILL_MEM_P
    if (Rst = '0') then
      --Iout <= (others => '0');
      file_open(mem_fp, "../mem/my_Jump.asm.mem", READ_MODE);
      index := 0;
      while (not endfile(mem_fp)) loop
        readline(mem_fp,file_line);
        hread(file_line,tmp_data_u);
        IRAM_mem(index) <= conv_integer(unsigned(tmp_data_u));       
        index := index + 1;
      end loop;
      file_close(mem_fp);
      --for i in index to MEM_size-1 loop
	  --IRAM_mem(i) <=  0;
      --end loop;
    --else
	--Iout <= conv_std_logic_vector(IRAM_mem(conv_integer(unsigned(Addr))), I_SIZE);
    end if;
  end process FILL_MEM_P;

end IRam_Bhe;
