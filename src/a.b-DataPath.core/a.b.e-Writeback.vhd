-- WB Stage top-level entity
library IEEE;
use IEEE.std_logic_1164.all;
use work.constants.all;
use work.instruction_set.all;

entity Writeback is
	port( WB_MUX_SEL : in std_logic; -- Control signal for WB mux
		  DATA_IN	 : in std_logic_vector(NBIT-1 downto 0); -- Data from DRAM
		  ALU_RES_IN : in std_logic_vector(NBIT-1 downto 0); -- Data from ALU
		  ADD_WR_IN  : in std_logic_vector(NBIT_ADD-1 downto 0); -- Address for WB
		  DATA_OUT   : out std_logic_vector(NBIT-1 downto 0); -- Data for WB and forwarding, sent to RF and FWD_Unit in the Execute stage
		  ADD_WR_OUT : out std_logic_vector(NBIT_ADD-1 downto 0)); -- Address for WB and forwarding, sent to RF and FWD_Unit in the Execute stage
end Writeback;

architecture struct of Writeback is

-- Component declarations
component mux21 is
	generic(NBIT : integer);
	port( A : in std_logic_vector(NBIT-1 downto 0);
		  B : in std_logic_vector(NBIT-1 downto 0);
		  S : in std_logic;
		  Z : out std_logic_vector(NBIT-1 downto 0));
end component;

begin

	WBmux : mux21 generic map(NBIT => NBIT)
		--port map(A => DATA_IN, B => ALU_RES_IN, S => WB_MUX_SEL, Z => DATA_OUT);
		port map(A => ALU_RES_IN, B => DATA_IN, S => WB_MUX_SEL, Z => DATA_OUT);
		
	ADD_WR_OUT <= ADD_WR_IN;

end struct;
