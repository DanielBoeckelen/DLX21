library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;

package instruction_set is

	-- DLX Basic Instruction Subset
	-- All instructions have a fixed 32-bit length
	
	----------- Instruction Types -------------------------------------------------------------------------------------------------------
	-- R-Type  : Register-register ALU operations; ALU operation defined in the 11-bit field "func"
	--   | OPCODE (6 bit) | RS1 (5 bit) | RS2 (5 bit) | RD (5 bit) | FUNC (11 bit) |
	--
	-- I-Type  : Load/Store and conditional branch instructions
	--   | OPCODE (6 bit) | RS1 (5 bit) | RD (5 bit)  |     IMMEDIATE (16 bit)     |
	--
	-- J-Type : Jump and jump link instructions
	--   | OPCODE (6 bit) |                  IMMEDIATE (26 bit)                    |
	-------------------------------------------------------------------------------------------------------------------------------------

	----------- Instruction Fields -----------

	-- FUNC (11 bit)
	constant Func_begin : integer := 10;
	constant Func_size  : integer := 11;
	constant Func_end   : integer := Func_begin - Func_size + 1;

	-- RD R-Type (5 bit)
	constant RDR_begin : integer := 15;
        constant RDR_size  : integer := 5;
	constant RDR_end   : integer := RDR_begin - RDR_size + 1;
	
	-- RD I-Type (5 bit)
	constant RDI_begin : integer := 20;
        constant RDI_size  : integer := 5;
	constant RDI_end   : integer := RDI_begin - RDI_size + 1;

	-- RS2 (5 bit)
	constant RS2_begin : integer := 20;
        constant RS2_size  : integer := 5;
	constant RS2_end   : integer := RS2_begin - RS2_size + 1;

	-- RS1 (5 bit)
	constant RS1_begin : integer := 25;
        constant RS1_size  : integer := 5;
	constant RS1_end   : integer := RS1_begin - RS1_size + 1;

	-- OPCODE (6 bit) --
	constant OPCODE_begin: integer := 31;
	constant OPCODE_size : integer := 6;
	constant OPCODE_end  : integer := OPCODE_begin - OPCODE_size + 1;
	
	-- I-Type immediate (16 bit) --
	constant I_IMM_begin: integer := 15;
	constant I_IMM_size : integer := 16;
	constant I_IMM_end  : integer := I_IMM_begin - I_IMM_size + 1;
	
	-- J-Type immediate (26 bit) --
	constant J_IMM_begin: integer := 25;
	constant J_IMM_size : integer := 26;
	constant J_IMM_end  : integer := J_IMM_begin - J_IMM_size + 1;

	-- Instruction OPCODEs

	-- NOP
	constant NOP_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(21, OPCODE_size)); --x"15"

	-- R-Type (ADD, AND, OR, SGE, SLE, SLL, SNE, SRL, SUB, XOR)
		constant RType_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(0, OPCODE_size)); --x"00"
		-- ADD
		constant ADD_Func : std_logic_vector(Func_size-1 downto 0) := std_logic_vector(to_unsigned(32, Func_size)); --x"20"
		-- AND
		constant AND_Func : std_logic_vector(Func_size-1 downto 0) := std_logic_vector(to_unsigned(36, Func_size)); --x"24"
		-- OR
		constant OR_Func : std_logic_vector(Func_size-1 downto 0) := std_logic_vector(to_unsigned(37, Func_size)); --x"25"
		-- SGE
		constant SGE_Func : std_logic_vector(Func_size-1 downto 0) := std_logic_vector(to_unsigned(45, Func_size)); --x"2d"
		-- SLE
		constant SLE_Func : std_logic_vector(Func_size-1 downto 0) := std_logic_vector(to_unsigned(44, Func_size)); --x"2c"
		-- SLL
		constant SLL_Func : std_logic_vector(Func_size-1 downto 0) := std_logic_vector(to_unsigned(4, Func_size)); --x"04"
		-- SNE
		constant SNE_Func : std_logic_vector(Func_size-1 downto 0) := std_logic_vector(to_unsigned(41, Func_size)); --x"29"
		-- SRL
		constant SRL_Func : std_logic_vector(Func_size-1 downto 0) := std_logic_vector(to_unsigned(6, Func_size)); --x"06"
		-- SUB
		constant SUB_Func : std_logic_vector(Func_size-1 downto 0) := std_logic_vector(to_unsigned(34, Func_size)); --x"22"
		-- XOR
		constant XOR_Func : std_logic_vector(Func_size-1 downto 0) := std_logic_vector(to_unsigned(38, Func_size)); --x"26"
		
		--------------advanced instrcutions of R type
		
		-- ADDU
		constant ADDU_Func : std_logic_vector(Func_size-1 downto 0) := std_logic_vector(to_unsigned(33, Func_size)); --x"21"
		-- SEQ
        constant SEQ_Func : std_logic_vector(Func_size-1 downto 0) := std_logic_vector(to_unsigned(40, Func_size)); --x"28"
        -- SGEU
		constant SGEU_Func : std_logic_vector(Func_size-1 downto 0) := std_logic_vector(to_unsigned(61, Func_size)); --x"3d"
		-- SGT
		constant SGT_Func : std_logic_vector(Func_size-1 downto 0) := std_logic_vector(to_unsigned(43, Func_size)); --x"2b"
		-- SGTU
		constant SGTU_Func : std_logic_vector(Func_size-1 downto 0) := std_logic_vector(to_unsigned(59, Func_size)); --x"3b"
		-- SLT
		constant SLT_Func : std_logic_vector(Func_size-1 downto 0) := std_logic_vector(to_unsigned(42, Func_size)); --x"2a"
		-- SLTU
		constant SLTU_Func : std_logic_vector(Func_size-1 downto 0) := std_logic_vector(to_unsigned(58, Func_size)); --x"3a"
		-- SRA
		constant SRA_Func : std_logic_vector(Func_size-1 downto 0) := std_logic_vector(to_unsigned(7, Func_size)); --x"07"
		-- SUBU
		constant SUBU_Func : std_logic_vector(Func_size-1 downto 0) := std_logic_vector(to_unsigned(35, Func_size)); --x"23"
		-- MULT
		constant MULT_Func : std_logic_vector(Func_size-1 downto 0) := std_logic_vector(to_unsigned(14, Func_size)); --x"0e"   --Attention : the func_code is copied as it's using fp register


	-- I-Type (LW, SW, ADDI, ANDI, BEQZ, BNEZ, ORI, SGEI, SLEI, SLLI, SNEI, SRLI, SUBI, XORI)

		-- LW
		constant LW_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(35, OPCODE_size)); --x"23"
		-- SW
		constant SW_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(43, OPCODE_size)); --x"2b"
		-- ADDI
		constant ADDI_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(8, OPCODE_size)); --x"08"
		-- ANDI
		constant ANDI_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(12, OPCODE_size)); --x"0c"
		-- BEQZ
		constant BEQZ_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(4, OPCODE_size)); --x"04"
		-- BNEZ
		constant BNEZ_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(5, OPCODE_size)); --x"05"
		-- ORI
		constant ORI_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(13, OPCODE_size)); --x"0d"
		-- SGEI
		constant SGEI_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(29, OPCODE_size)); --x"1d"
		-- SLEI
		constant SLEI_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(28, OPCODE_size)); --x"1c"
		-- SLLI
		constant SLLI_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(20, OPCODE_size)); --x"14"
		-- SNEI
		constant SNEI_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(25, OPCODE_size)); --x"19"
		-- SRLI
		constant SRLI_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(22, OPCODE_size)); --x"16"
		-- SUBI
		constant SUBI_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(10, OPCODE_size)); --x"0a"
		-- XORI
		constant XORI_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(14, OPCODE_size)); --x"0e"

		----------- advanced instrcutions of I type
		-- JR
        constant JR_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(18, OPCODE_size)); --x"12"
        -- JALR
        constant JALR_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(19, OPCODE_size)); --x"13"
        -- ADDUI
        constant ADDUI_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(9, OPCODE_size)); --x"09"
        -- LB
        constant LB_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(32, OPCODE_size)); --x"20"
        -- LBU
        constant LBU_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(36, OPCODE_size)); --x"24"
        -- LHI
        constant LHI_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(15, OPCODE_size)); --x"0f"
        -- LHU
        constant LHU_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(37, OPCODE_size)); --x"25"
        -- SB
        constant SB_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(40, OPCODE_size)); --x"28"
		-- SEQI
		constant SEQI_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(24, OPCODE_size)); --x"18"
		-- SGEUI
		constant SGEUI_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(61, OPCODE_size)); --x"3d"
		-- SGTI
		constant SGTI_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(27, OPCODE_size)); --x"1b"
		-- SGTUI
		constant SGTUI_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(59, OPCODE_size)); --x"3b"
		-- SLTI
		constant SLTI_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(26, OPCODE_size)); --x"1a"
		-- SLTUI
		constant SLTUI_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(58, OPCODE_size)); --x"3a"
		-- SRAI
		constant SRAI_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(23, OPCODE_size)); --x"17"
		-- SUBUI
		constant SUBUI_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(11, OPCODE_size)); --x"0b"

	-- J-Type (J, JAL)
		-- J
		constant J_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(2, OPCODE_size)); --x"02"
		-- JAL
		constant JAL_OP : std_logic_vector(OPCODE_size-1 downto 0) := std_logic_vector(to_unsigned(3, OPCODE_size)); --x"03"

end package;
