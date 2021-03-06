library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.constants.all;

-- Data memory for DLX
entity DRAM is
  generic (
    RAM_DEPTH : integer := MEM_size;
    D_SIZE : integer := NBIT);
  port (
    Clk        : in std_logic;
    Rst        : in std_logic;
    ADDR_IN    : in std_logic_vector(D_SIZE-1 downto 0);
	DATA_IN    : in std_logic_vector(D_SIZE-1 downto 0);
	LOAD_TYPE  : in std_logic_vector(1 downto 0); -- "00" LW, "01" LB, "10" LBU, "11" LHU
	STORE_TYPE : in std_logic; -- '0' SW, '1' SB
	DRAM_W     : in std_logic; -- Write enable
	DRAM_R     : in std_logic; -- Read enable
	DATA_OUT   : out std_logic_vector(D_SIZE-1 downto 0)
    );
end DRAM;

architecture DRam_Bhe of DRAM is


  type RAMtype is array (0 to RAM_DEPTH - 1) of std_logic_vector(D_SIZE-1 downto 0);
  signal DRAMmem : RAMtype;

  begin

    RW_DRAM: process(Clk, Rst, ADDR_IN, DATA_IN, LOAD_TYPE, STORE_TYPE, DRAM_W, DRAM_R)
	begin 

		if (Rst = '0') then
			DRAMmem <= (others => (others => '0'));
			-- FOR Branch.asm: assign a value to index 0 and 4
			DRAMmem(0) <= x"0000000B";
			DRAMmem(4) <= x"00000001";
			-- FOR Mult1.asm
			DRAMmem(106) <= x"0000000A";
			--
			-- FOR LoadStore.asm: let's assign a value to indexes 8 and 12
			DRAMmem(8) <= x"0000000A";
			DRAMmem(12) <= x"F00A11A0";
			--
			DATA_OUT <= (others => '0');			
		elsif(Clk = '1' and Clk'event) then
			if(to_integer(unsigned(ADDR_IN)) >= 0) then -- Avoids errors generated when the datapath computes and sends negative values in cycles which are not loads/stores
				if(DRAM_R = '1') then -- Load (Read) enable
					case (LOAD_TYPE) is
						when "00" => -- LW
							DATA_OUT <= DRAMmem(to_integer(unsigned(ADDR_IN)));
						when "01" => -- LB: bits 31 downto 8 are equal to the byte's sign, contained in bit 7 of the memory row; then, load byte
							DATA_OUT <= (NBIT-1 downto 8 => DRAMmem(to_integer(unsigned(ADDR_IN)))(7)) & DRAMmem(to_integer(unsigned(ADDR_IN)))(7 downto 0);
						when "10" => -- LBU: bits 31 downto 8 are equal to 0; then, load byte
							DATA_OUT <= x"000000" & DRAMmem(to_integer(unsigned(ADDR_IN)))(7 downto 0);
						when "11" => -- LHU: bits 31 downto 16 are equal to 0; then, load halfword
							DATA_OUT <= x"0000" & DRAMmem(to_integer(unsigned(ADDR_IN)))(15 downto 0);
						when others => NULL;
					end case;
				elsif(DRAM_W = '1') then -- Store (Write) enable
					if(STORE_TYPE = '0') then -- SW
						DRAMmem(to_integer(unsigned(ADDR_IN))) <= DATA_IN;
					else -- SB: Load only a byte into the lower byte of the memory row
						DRAMmem(to_integer(unsigned(ADDR_IN)))(7 downto 0) <= DATA_IN(7 downto 0);
					end if;
				end if;
			end if;
		end if;
	end process RW_DRAM;   
end DRam_Bhe;
