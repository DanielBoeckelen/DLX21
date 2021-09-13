-- Once the type is derived, the RS1, RS2, RD and IMM fields are extracted
library IEEE;
use IEEE.std_logic_1164.all;
use work.constants.all;
use work.instruction_set.all;

entity instruction_decomposition is
	port( INST_IN    : in std_logic_vector(NBIT-1 downto 0); -- Instruction from IR
		  Rtype      : in std_logic;
		  Itype      : in std_logic;
		  Jtype      : in std_logic;
		  ADD_RS1    : out std_logic_vector(NBIT_ADD-1 downto 0); -- sent to regfile
		  ADD_RS2    : out std_logic_vector(NBIT_ADD-1 downto 0); -- sent to regfile
		  ADD_WR     : out std_logic_vector(NBIT_ADD-1 downto 0); -- sent to intermediate reg in ID stage, to be used in writeback
		  IMM        : out std_logic_vector(NBIT-1 downto 0); -- sent to intermediate reg in ID stage
		  RD1		 : out std_logic; -- Enables the read port 1 of the register file
		  RD2		 : out std_logic); -- Enables the read port 2 of the register file
end instruction_decomposition;

architecture bhv of instruction_decomposition is

begin
	
	inst_decomp : process(INST_IN, Rtype, Itype, Jtype)
	begin

		ADD_RS1 <= (others => '0'); -- Avoids inferred latches
		ADD_RS2 <= (others => '0');
		ADD_WR <= (others => '0');
		IMM <= (others => '0');
		RD1 <= '0';
		RD2 <= '0';  

		if (Rtype = '1') then
			ADD_RS1 <= INST_IN(RS1_begin downto RS1_end);
			ADD_RS2 <= INST_IN(RS2_begin downto RS2_end);
			ADD_WR <= INST_IN(RDR_begin downto RDR_end);
			RD1 <= '1';
			RD2 <= '1'; 
			
		elsif (Itype = '1') then
			ADD_RS1 <= INST_IN(RS1_begin downto RS1_end);
			if(INST_IN(OPCODE_begin downto OPCODE_end) = SW_OP OR INST_IN(OPCODE_begin downto OPCODE_end) = SB_OP) then
				ADD_RS2 <= INST_IN(RDI_begin downto RDI_end); -- If SW, this allows to use RD as a source register, performing M[imm16 + R[regA]] <= R[regB], and it will also be used for forwarding.
				RD1 <= '1';
				RD2 <= '1';
			else
				RD1 <= '1';
				RD2 <= '0';
			end if;

			if(INST_IN(OPCODE_begin downto OPCODE_end) = JALR_OP) then -- If JALR, R31 is needed as destination register
				ADD_WR <= (others => '1');
			else
				ADD_WR <= INST_IN(RDI_begin downto RDI_end); -- Normal I-Type instruction
			end if;

			IMM <= (NBIT-1 downto I_IMM_size => INST_IN(I_IMM_begin)) & INST_IN(I_IMM_begin downto I_IMM_end);

		elsif (Jtype = '1') then
			RD1 <= '0';
			RD2 <= '0'; 
			IMM <= (NBIT-1 downto J_IMM_size => INST_IN(J_IMM_begin)) & INST_IN(J_IMM_begin downto J_IMM_end);
			ADD_WR <= (others => '1'); -- If J, this will be ignored by disabling the following registers through the CW; if JAL, must store return address in R31
		end if;
	end process inst_decomp;
end bhv;
