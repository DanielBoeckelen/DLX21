library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.constants.all;
use work.instruction_set.all;

-- Instruction memory for DLX
-- Memory filled by a process which reads from a file
-- file name depends on program being tested
entity IRAM is
  generic (
    RAM_DEPTH : integer := MEM_size;
    I_SIZE : integer := NBIT);
  port (
    Rst  : in  std_logic;
    Addr : in  std_logic_vector(I_SIZE - 1 downto 0); -- Program counter, from datapath
    Iout : out std_logic_vector(I_SIZE - 1 downto 0)
    );
end IRAM;

architecture IRam_Bhe of IRAM is
  
  type RAMtype is array (0 to RAM_DEPTH - 1) of integer; -- Array where the instructions are loaded from the file

  signal IRAM_mem : RAMtype := (others => 0);

begin

  Iout <= conv_std_logic_vector(IRAM_mem(conv_integer(unsigned(Addr))/4), I_SIZE); -- PC is incremented by 4, but IRAM addresses are subsequent (hence the division of Addr by 4)

  -- purpose: This process is in charge of filling the Instruction RAM with the firmware
  -- type   : combinational
  -- inputs : Rst, Addr
  -- outputs: IRAM_mem
  
  FILL_MEM_P: process (Rst, Addr)
    file mem_fp: text;
    variable file_line : line;
    variable index : integer := 0;
    variable tmp_data_u : std_logic_vector(I_SIZE-1 downto 0);
  begin  -- process FILL_MEM_P
    if (Rst = '0') then

---------------------------------------------------------------------
--*******************************************************************

       --file_open(mem_fp, "../mem/basic_test.asm.mem", READ_MODE); 			--basic_test.asm.mem
       
       --file_open(mem_fp, "../mem/Branch.asm.mem", READ_MODE); 				--Branch.asm.mem

       --file_open(mem_fp, "../mem/Branch2.asm.mem", READ_MODE); 				--Branch2.asm.mem

       --file_open(mem_fp, "../mem/dlx_div.asm.mem", READ_MODE);				--dlx_div.asm.mem
       
       --file_open(mem_fp, "../mem/first_test.asm.mem", READ_MODE);				--first_test.asm.mem

       --file_open(mem_fp, "../mem/jr.asm.mem", READ_MODE);						--jr.asm.mem

       --file_open(mem_fp, "../mem/LoadStore.asm.mem", READ_MODE);				--LoadStore.asm.mem
       
       --file_open(mem_fp, "../mem/Mult0.asm.mem", READ_MODE);					--Mult0.asm.mem

       --file_open(mem_fp, "../mem/Mult1.asm.mem", READ_MODE);					--Mult1.asm.mem

       --file_open(mem_fp, "../mem/Mult3.asm.mem", READ_MODE);					--Mult3.asm.mem
       
       --file_open(mem_fp, "../mem/my_Jump.asm.mem", READ_MODE);				--my_Jump.asm.mem

       --file_open(mem_fp, "../mem/test_memory_no_hazard.asm.mem", READ_MODE);	--test_memory_no_hazard.asm.mem
       
       --file_open(mem_fp, "../mem/test_pro_ins.asm.mem", READ_MODE);			--test_pro_ins.asm.mem

       file_open(mem_fp, "../mem/vector_mult.asm.mem", READ_MODE);			--vector_mult.asm.mem
      
--*******************************************************************
---------------------------------------------------------------------
  
      index := 0;
      while (not endfile(mem_fp)) loop
        readline(mem_fp,file_line);
        hread(file_line,tmp_data_u);
        IRAM_mem(index) <= conv_integer(unsigned(tmp_data_u));       
        index := index + 1;
      end loop;
      file_close(mem_fp);
    end if;
  end process FILL_MEM_P;
end IRam_Bhe;
