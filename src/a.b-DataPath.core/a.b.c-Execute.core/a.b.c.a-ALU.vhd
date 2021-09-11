library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;
--use IEEE.std_logic_arith.all;
use work.constants.all;
use work.instruction_set.all;

entity ALU is
	generic(NBIT : integer);
	port( OP1     : in std_logic_vector(NBIT-1 downto 0); -- Coming from mux1, selecting NPC or A
	      OP2     : in std_logic_vector(NBIT-1 downto 0); -- Coming from mux2, selecting IMM or B
	      ALU_OPC : in aluOp; -- coming from Control Unit
	      ALU_RES : out std_logic_vector(NBIT-1 downto 0)); -- going to EX/MEM Pipeline reg
end ALU;

architecture struct of ALU is

-- Component Declarations
component comparator is
	generic(NBIT : integer);
	port( A     : in std_logic_vector(NBIT-1 downto 0);
	      B     : in std_logic_vector(NBIT-1 downto 0);
	      OPSel : in integer range 0 to 5;
	      RES   : out std_logic_vector(NBIT-1 downto 0));
end component;

component shifter is
	generic(NBIT : integer);
	port( A           : in std_logic_vector(NBIT-1 downto 0); -- Operand to shift
	      B           : in std_logic_vector(NBIT-1 downto 0); -- Shift amount
	      LOGIC_ARITH : in std_logic;	-- 1 = logic, 0 = arith
	      LEFT_RIGHT  : in std_logic;	-- 1 = left, 0 = right
	      RES         : out std_logic_vector(NBIT-1 downto 0)
	      );
end component;

component P4Adder is
	generic(NBIT : integer);
	port( A         : in std_logic_vector(NBIT-1 downto 0); -- operand A
	      B         : in std_logic_vector(NBIT-1 downto 0); -- operand B
	      Cin       : in std_logic;  -- C_0
	      S         : out std_logic_vector(NBIT-1 downto 0); -- sum
	      Cout      : out std_logic);  -- carry out of the P4 adder
end component;

component BOOTHMUL is
	generic( numBit: integer := NBIT/2);  
	port( A,B: in std_logic_vector(numBit-1 downto 0);
		  P: out std_logic_vector(2*numBit-1 downto 0));
end component;

component mux41 is
	generic(NBIT : integer);
	port( A : in std_logic_vector(NBIT-1 downto 0);
	      B : in std_logic_vector(NBIT-1 downto 0);
	      C : in std_logic_vector(NBIT-1 downto 0);
	      D : in std_logic_vector(NBIT-1 downto 0);
	      S : in std_logic_vector(1 downto 0);
	      Z : out std_logic_vector(NBIT-1 downto 0));
end component;

component mux21 is
	generic(NBIT : integer);
	port( A : in std_logic_vector(NBIT-1 downto 0);
	      B : in std_logic_vector(NBIT-1 downto 0);
	      S : in std_logic;
	      Z : out std_logic_vector(NBIT-1 downto 0));
end component;

-- Signal Declarations
signal OPSel : integer range 0 to 5;
signal COMP_RES, SHIFT_RES, LOGIC_RES, ADD_SUB_RES, MUL_RES, sig_ALU_RES : std_logic_vector(NBIT-1 downto 0);
signal LOGIC_ARITH, LEFT_RIGHT, ADD_SUB, Cout : std_logic;
signal A_ADD, B_ADD, A_SHF, B_SHF, A_CMP, B_CMP : std_logic_vector(NBIT-1 downto 0);
signal A_MUL, B_MUL : std_logic_vector((NBIT/2)-1 downto 0);

signal select_type_sig: std_logic_vector(1 downto 0);
--select_type_sig = 00 -> ADD_SUB_RES
--select_type_sig = 01 -> LOGIC_RES
--select_type_sig = 10 -> SHIFT_RES
--select_type_sig = 11 -> COMP_RES

signal sig_intraMux : std_logic_vector(NBIT-1 downto 0);

signal select_zero_sig: std_logic;
--select_zero_sig = 0 -> result
--select_zero_sig = 1 -> zeros

signal select_mul: std_logic;
--select_mul = 0 -> other results
--select_mul = 1 -> mul result

begin

	ALU_Proc: process(OP1, OP2, ALU_OPC)	
	begin
		case(ALU_OPC) is
			when ADDS =>
                                ADD_SUB <= '0';
								A_ADD <= OP1;
								B_ADD <= OP2;
                                select_type_sig <= "00"; --add_sub_res
                                select_zero_sig <= '0';

								A_CMP <= (others => '0'); -- to avoid inferred latches
								B_CMP <= (others => '0');
								A_SHF <= (others => '0');
								B_SHF <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								LOGIC_RES <= (others => '0');
								LOGIC_ARITH <= '0';
								LEFT_RIGHT <= '0';
								OPSel <= 0;
								select_mul <= '0';
								
								

			when ADDUS =>
                                ADD_SUB <= '0';
							    A_ADD <= std_logic_vector(unsigned(OP1));
								B_ADD <= std_logic_vector(unsigned(OP2));
		                        select_type_sig <= "00"; --add_sub_res
		                        select_zero_sig <= '0';

								A_CMP <= (others => '0'); -- to avoid inferred latches
								B_CMP <= (others => '0');
								A_SHF <= (others => '0');
								B_SHF <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								LOGIC_RES <= (others => '0');
								LOGIC_ARITH <= '0';
								LEFT_RIGHT <= '0';
								OPSel <= 0;
								select_mul <= '0';
                
			when SUBS =>
                                ADD_SUB <= '1'; -- SUB is treated as a two's complement sum: A + B' + 1
								A_ADD <= OP1;
								B_ADD <= not(OP2);
                                select_type_sig <= "00"; --add_sub_res
                                select_zero_sig <= '0';

								A_CMP <= (others => '0'); -- to avoid inferred latches
								B_CMP <= (others => '0');
								A_SHF <= (others => '0');
								B_SHF <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								LOGIC_RES <= (others => '0');
								LOGIC_ARITH <= '0';
								LEFT_RIGHT <= '0';
								OPSel <= 0;
								select_mul <= '0';

			when SUBUS =>
                                ADD_SUB <= '1'; -- SUB is treated as a two's complement sum: A + B' + 1
								A_ADD <= std_logic_vector(unsigned(OP1));
								B_ADD <= not(std_logic_vector(unsigned(OP2)));
                                select_type_sig <= "00"; --add_sub_res
                                select_zero_sig <= '0';

								A_CMP <= (others => '0'); -- to avoid inferred latches
								B_CMP <= (others => '0');
								A_SHF <= (others => '0');
								B_SHF <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								LOGIC_RES <= (others => '0');
								LOGIC_ARITH <= '0';
								LEFT_RIGHT <= '0';
								OPSel <= 0;
								select_mul <= '0';
                
			when ANDS =>
                                LOGIC_RES <= OP1 and OP2;
                                select_type_sig <= "01"; --logic_res
                                select_zero_sig <= '0';

								A_CMP <= (others => '0'); -- to avoid inferred latches
								B_CMP <= (others => '0');
								A_SHF <= (others => '0');
								B_SHF <= (others => '0');
								A_ADD <= (others => '0');
								B_ADD <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								LOGIC_ARITH <= '0';
								LEFT_RIGHT <= '0';
								OPSel <= 0;
								ADD_SUB <= '0';
								select_mul <= '0';
                
			when ORS  =>
                                LOGIC_RES <= OP1 or OP2;
                                select_type_sig <= "01"; --logic_res
                                select_zero_sig <= '0';

								A_CMP <= (others => '0'); -- to avoid inferred latches
								B_CMP <= (others => '0');
								A_SHF <= (others => '0');
								B_SHF <= (others => '0');
								A_ADD <= (others => '0');
								B_ADD <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								LOGIC_ARITH <= '0';
								LEFT_RIGHT <= '0';
								OPSel <= 0;
								ADD_SUB <= '0';
								select_mul <= '0';
                
			when XORS =>
                                LOGIC_RES <= OP1 xor OP2;
                                select_type_sig <= "01"; --logic_res
                                select_zero_sig <= '0';

								A_CMP <= (others => '0'); -- to avoid inferred latches
								B_CMP <= (others => '0');
								A_SHF <= (others => '0');
								B_SHF <= (others => '0');
								A_ADD <= (others => '0');
								B_ADD <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								LOGIC_ARITH <= '0';
								LEFT_RIGHT <= '0';
								OPSel <= 0;
								ADD_SUB <= '0';
								select_mul <= '0';
                
			when SLLS =>
                                LOGIC_ARITH <= '1';
								LEFT_RIGHT <= '1';
								A_SHF <= OP1;
								B_SHF <= OP2;
                                select_type_sig <= "10"; --shift_res
                                select_zero_sig <= '0';

								A_CMP <= (others => '0'); -- to avoid inferred latches
								B_CMP <= (others => '0');
								A_ADD <= (others => '0');
								B_ADD <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								OPSel <= 0;
								ADD_SUB <= '0';
								LOGIC_RES <= (others => '0');
								select_mul <= '0';

			when LHIS =>
								LOGIC_ARITH <= '1';
								LEFT_RIGHT <= '1';
								A_SHF <= OP2;
								B_SHF <= x"00000010"; -- 16
                                select_type_sig <= "10"; --shift_res
                                select_zero_sig <= '0';

								A_CMP <= (others => '0'); -- to avoid inferred latches
								B_CMP <= (others => '0');
								A_ADD <= (others => '0');
								B_ADD <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								OPSel <= 0;
								ADD_SUB <= '0';
								LOGIC_RES <= (others => '0');
								select_mul <= '0';
                
			when SRLS =>
                                LOGIC_ARITH <= '1';
								LEFT_RIGHT <= '0';
								A_SHF <= OP1;
								B_SHF <= OP2;
                                select_type_sig <= "10"; --shift_res
								select_zero_sig <= '0';

								A_CMP <= (others => '0'); -- to avoid inferred latches
								B_CMP <= (others => '0');
								A_ADD <= (others => '0');
								B_ADD <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								OPSel <= 0;
								ADD_SUB <= '0';
								LOGIC_RES <= (others => '0');
								select_mul <= '0';
								

			when SRAS => 
                                LOGIC_ARITH <= '0';
								LEFT_RIGHT <= '0';
								A_SHF <= OP1;
								B_SHF <= OP2;
                                select_type_sig <= "10"; --shift_res
								select_zero_sig <= '0';

								A_CMP <= (others => '0'); -- to avoid inferred latches
								B_CMP <= (others => '0');
								A_ADD <= (others => '0');
								B_ADD <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								OPSel <= 0;
								ADD_SUB <= '0';
								LOGIC_RES <= (others => '0');
								select_mul <= '0';

                               
			when BEQZS =>
                                --ADD_SUB <= '0';
								--B <= OP2;
                                select_type_sig <= "00"; --add_sub_res
                                select_zero_sig <= '1';

								A_CMP <= (others => '0'); -- to avoid inferred latches
								B_CMP <= (others => '0');
								A_SHF <= (others => '0');
								B_SHF <= (others => '0');
								A_ADD <= (others => '0');
								B_ADD <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								LOGIC_ARITH <= '0';
								LEFT_RIGHT <= '0';
								OPSel <= 0;
								ADD_SUB <= '0';
								LOGIC_RES <= (others => '0');
								select_mul <= '0';
                
			when BNEZS =>
                                --ADD_SUB <= '0';
								--B <= OP2;
                                select_type_sig <= "00"; --add_sub_res
                                select_zero_sig <= '1';

								A_CMP <= (others => '0'); -- to avoid inferred latches
								B_CMP <= (others => '0');
								A_SHF <= (others => '0');
								B_SHF <= (others => '0');
								A_ADD <= (others => '0');
								B_ADD <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								LOGIC_ARITH <= '0';
								LEFT_RIGHT <= '0';
								OPSel <= 0;
								ADD_SUB <= '0';
								LOGIC_RES <= (others => '0');
								select_mul <= '0';
                
			when SGES =>
                                OPSel <= 3;
								A_CMP <= OP1;
								B_CMP <= OP2;
                                select_type_sig <= "11"; --comp_res
                                select_zero_sig <= '0';  

								A_SHF <= (others => '0'); -- to avoid inferred latches
								B_SHF <= (others => '0');
								A_ADD <= (others => '0');
								B_ADD <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								LOGIC_ARITH <= '0';
								LEFT_RIGHT <= '0';
								ADD_SUB <= '0';
								LOGIC_RES <= (others => '0');
								select_mul <= '0';
			
			when SGEUS =>
                                OPSel <= 3;
								A_CMP <= std_logic_vector(unsigned(OP1));
								B_CMP <= std_logic_vector(unsigned(OP2));
                                select_type_sig <= "11"; --comp_res
                                select_zero_sig <= '0';

								A_SHF <= (others => '0'); -- to avoid inferred latches
								B_SHF <= (others => '0');
								A_ADD <= (others => '0');
								B_ADD <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								LOGIC_ARITH <= '0';
								LEFT_RIGHT <= '0';
								ADD_SUB <= '0';
								LOGIC_RES <= (others => '0');
								select_mul <= '0';

			when SGTS =>
                                OPSel <= 2;
								A_CMP <= OP1;
								B_CMP <= OP2;
                                select_type_sig <= "11"; --comp_res
                                select_zero_sig <= '0';  

								A_SHF <= (others => '0'); -- to avoid inferred latches
								B_SHF <= (others => '0');
								A_ADD <= (others => '0');
								B_ADD <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								LOGIC_ARITH <= '0';
								LEFT_RIGHT <= '0';
								ADD_SUB <= '0';
								LOGIC_RES <= (others => '0');
								select_mul <= '0';

			when SGTUS =>
                                OPSel <= 2;
								A_CMP <= std_logic_vector(unsigned(OP1));
								B_CMP <= std_logic_vector(unsigned(OP2));
                                select_type_sig <= "11"; --comp_res
                                select_zero_sig <= '0';  

								A_SHF <= (others => '0'); -- to avoid inferred latches
								B_SHF <= (others => '0');
								A_ADD <= (others => '0');
								B_ADD <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								LOGIC_ARITH <= '0';
								LEFT_RIGHT <= '0';
								ADD_SUB <= '0';
								LOGIC_RES <= (others => '0');
								select_mul <= '0';

			when SLTS =>
			                    OPSel <= 4;
			                    A_CMP <= OP1;
								B_CMP <= OP2;
                                select_type_sig <= "11"; --comp_res
                                select_zero_sig <= '0';  

								A_SHF <= (others => '0'); -- to avoid inferred latches
								B_SHF <= (others => '0');
								A_ADD <= (others => '0');
								B_ADD <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								LOGIC_ARITH <= '0';
								LEFT_RIGHT <= '0';
								ADD_SUB <= '0';
								LOGIC_RES <= (others => '0');
								select_mul <= '0';    
			when SLTUS =>
			                    OPSel <= 4;
			                    A_CMP <= std_logic_vector(unsigned(OP1));
								B_CMP <= std_logic_vector(unsigned(OP2));
                                select_type_sig <= "11"; --comp_res
                                select_zero_sig <= '0';  

								A_SHF <= (others => '0'); -- to avoid inferred latches
								B_SHF <= (others => '0');
								A_ADD <= (others => '0');
								B_ADD <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								LOGIC_ARITH <= '0';
								LEFT_RIGHT <= '0';
								ADD_SUB <= '0';
								LOGIC_RES <= (others => '0');
								select_mul <= '0';    

			when SLES  =>
                                OPSel <= 5;
								A_CMP <= OP1;
								B_CMP <= OP2;
                                select_type_sig <= "11"; --comp_res
                                select_zero_sig <= '0';

								A_SHF <= (others => '0'); -- to avoid inferred latches
								B_SHF <= (others => '0');
								A_ADD <= (others => '0');
								B_ADD <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								LOGIC_ARITH <= '0';
								LEFT_RIGHT <= '0';
								ADD_SUB <= '0';
								LOGIC_RES <= (others => '0');
								select_mul <= '0';

			when SEQS =>
								OPSel <= 0;
								A_CMP <= OP1;
								B_CMP <= OP2;
                                select_type_sig <= "11"; --comp_res
                                select_zero_sig <= '0';

								A_SHF <= (others => '0'); -- to avoid inferred latches
								B_SHF <= (others => '0');
								A_ADD <= (others => '0');
								B_ADD <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								LOGIC_ARITH <= '0';
								LEFT_RIGHT <= '0';
								ADD_SUB <= '0';
								LOGIC_RES <= (others => '0');
								select_mul <= '0';
                
			when NEQS =>
                                OPSel <= 1;
								A_CMP <= OP1;
								B_CMP <= OP2;
                                select_type_sig <= "11"; --comp_res
                                select_zero_sig <= '0';

								A_SHF <= (others => '0'); -- to avoid inferred latches
								B_SHF <= (others => '0');
								A_ADD <= (others => '0');
								B_ADD <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								LOGIC_ARITH <= '0';
								LEFT_RIGHT <= '0';
								ADD_SUB <= '0';
								LOGIC_RES <= (others => '0');
								select_mul <= '0';

			when MULTS =>
								A_MUL <= OP1(NBIT/2-1 downto 0);
								B_MUL <= OP2(NBIT/2-1 downto 0);
								select_mul <= '1';
								select_zero_sig <= '0';

								A_SHF <= (others => '0'); -- to avoid inferred latches
								B_SHF <= (others => '0');
								A_ADD <= (others => '0');
								B_ADD <= (others => '0');
								A_CMP <= (others => '0');
								B_CMP <= (others => '0');
								LOGIC_ARITH <= '0';
								LEFT_RIGHT <= '0';
								ADD_SUB <= '0';
								LOGIC_RES <= (others => '0');
							  	OPSel <= 0;
								select_type_sig <= "00";

			when NOP =>
                                select_type_sig <= "00";
                                select_zero_sig <= '1';

								A_CMP <= (others => '0'); -- to avoid inferred latches
								B_CMP <= (others => '0');
								A_SHF <= (others => '0');
								B_SHF <= (others => '0');
								A_ADD <= (others => '0');
								B_ADD <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								LOGIC_ARITH <= '0';
								LEFT_RIGHT <= '0';
								OPSel <= 0;
								ADD_SUB <= '0';
								LOGIC_RES <= (others => '0');
								select_mul <= '0';
                
			when others =>
								
                                select_type_sig <= "00";
                                select_zero_sig <= '1';     
								A_CMP <= (others => '0'); -- to avoid inferred latches
								B_CMP <= (others => '0');
								A_SHF <= (others => '0');
								B_SHF <= (others => '0');
								A_ADD <= (others => '0');
								B_ADD <= (others => '0');
								A_MUL <= (others => '0');
								B_MUL <= (others => '0');
								LOGIC_ARITH <= '0';
								LEFT_RIGHT <= '0';
								OPSel <= 0;
								ADD_SUB <= '0';
								LOGIC_RES <= (others => '0');
								select_mul <= '0';

		end case;
	end process ALU_Proc;

	
	-- Units
	Comp: comparator generic map(NBIT => NBIT)
		port map(A => A_CMP, B => B_CMP, OPSel => OPSel, RES => COMP_RES);
		
	Shift: shifter generic map(NBIT => NBIT)
		port map(A => A_SHF, B => B_SHF, LOGIC_ARITH => LOGIC_ARITH, LEFT_RIGHT => LEFT_RIGHT, RES => SHIFT_RES);
	
	Add_Sub_unit : P4Adder generic map(NBIT => NBIT)
		port map(A => A_ADD, B => B_ADD, Cin => ADD_SUB, S => ADD_SUB_RES, Cout => Cout);
	
	Booth_mul : BOOTHMUL generic map(NBIT/2)
		port map(A => A_MUL, B => B_MUL, P => MUL_RES);

    Res_mux : mux41 generic map (NBIT => NBIT)
            port map(A => ADD_SUB_RES, B => LOGIC_RES, C => SHIFT_RES, D => COMP_RES, S => select_type_sig, Z => sig_intraMux);

	Mul_mux : mux21 generic map (NBIT => NBIT)
			port map(A => sig_intraMux, B => MUL_RES, S => select_mul, Z => sig_ALU_RES);

    Zeros_mux : mux21 generic map (NBIT => NBIT)
            port map(A => sig_ALU_RES, B => (others => '0'), S => select_zero_sig, Z => ALU_RES);
	
end struct;
