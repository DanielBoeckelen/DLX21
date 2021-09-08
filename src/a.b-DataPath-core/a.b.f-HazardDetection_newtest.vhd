library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.constants.all;
use work.instruction_set.all;

entity HazardDetection is
	port(     RST         : in std_logic;
		  ADD_RS1     : in std_logic_vector(NBIT_ADD-1 downto 0); -- Source register 1 of the decoded instruction
		  ADD_RS2     : in std_logic_vector(NBIT_ADD-1 downto 0); -- Source register 2 of the decoded instruction
		  ADD_WR      : in std_logic_vector(NBIT_ADD-1 downto 0); -- Destination register of the previous instruction (coming into the Execute stage)
		  DRAM_R      : in std_logic; -- Memory read control signal generated by the CU, regarding the instruction currently in the Execute stage
		  INS_IN      : in std_logic_vector(NBIT-1 downto 0); -- Instruction coming out of the Fetch stage
		  PC_IN       : in std_logic_vector(NBIT-1 downto 0); -- PC of the instruction coming out of the Fetch stage
		  Bubble      : out std_logic; -- Bubble signal, raised to '1' to stall the pipeline
		  HDU_INS_OUT : out std_logic_vector(NBIT-1 downto 0); -- Current instruction
		  HDU_PC_OUT  : out std_logic_vector(NBIT-1 downto 0); -- PC of current instruction
		  HDU_NPC_OUT : out std_logic_vector(NBIT-1 downto 0)); -- NPC
        
end HazardDetection;

architecture arch of HazardDetection is

  signal Bubble_det: std_logic := '0';
  signal count: integer := 0;

begin

	HDU_INS_OUT <= INS_IN;
	--HDU_PC_OUT <= PC_IN - 4; -- PC_IN;
	--HDU_NPC_OUT <= PC_IN; -- PC_IN + 4;
	HDU_PC_OUT <= PC_IN; -- PC_IN;
	HDU_NPC_OUT <= PC_IN + 4; -- PC_IN + 4;
	
	process(RST, ADD_RS1, ADD_RS2, ADD_WR, DRAM_R)

          variable test : std_logic := '0';
            
	begin
		Bubble <= '0';
                
		if(RST = '0') then
		   Bubble <= '0';
                   Bubble_det <= '0';
                        
		elsif(DRAM_R = '1' or Bubble_det = '1') then -- if previous instruction was a
                                                             -- load, stall 2 times
                  
			if(ADD_WR = ADD_RS1 or ADD_WR = ADD_RS2) then -- If one of the source register is the destination of the previous load, we need to stall and wait for the load to complete
				Bubble <= '1';		
			else
				Bubble <= '0';
			end if;
                        

                        if (test='0') then

                         Bubble_det <= not Bubble_det;

                         test := not test;

                        else

                          test := not test;

                        end if;

                        count <= count + 1;
                        

                        
		end if;
	end process;
end arch;
