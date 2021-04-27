library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;
use work.constants.all;
use work.instruction_set.all;

entity ALU is
    generic (NBIT : integer);
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
signal COMP_RES, SHIFT_RES, LOGIC_RES, ADD_SUB_RES, B : std_logic_vector(NBIT-1 downto 0);
signal LOGIC_ARITH, LEFT_RIGHT, ADD_SUB, Cout : std_logic;

signal select_type_sig: std_logic_vector(1 downto 0);
--select_type_sig = 00 -> ADD_SUB_RES
--select_type_sig = 01 -> LOGIC_RES
--select_type_sig = 10 -> SHIFT_RES
--select_type_sig = 11 -> COMP_RES

signal sig_intraMux : std_logic_vector(NBIT-1 downto 0);

signal select_zero_sig: std_logic;
--select_zero_sig = 0 -> result
--select_zero_sig = 1 -> zeros


begin

	ALU_Proc: process(OP1, OP2, ALU_OPC)	
	begin
		case(ALU_OPC) is
			when ADDS =>
                                ADD_SUB <= '0';
				B <= OP2;
                                select_type_sig <= "00"; --add_sub_res
                                select_zero_sig <= '0';
                
			when SUBS =>
                                ADD_SUB <= '1'; -- SUB is treated as a two's complement sum: A + B' + 1
				B <= not(OP2);
                                select_type_sig <= "00"; --add_sub_res
                                select_zero_sig <= '0';
                
			when ANDS =>
                                LOGIC_RES <= OP1 and OP2;
                                select_type_sig <= "01"; --logic_res
                                select_zero_sig <= '0';
                
			when ORS  =>
                                LOGIC_RES <= OP1 or OP2;
                                select_type_sig <= "01"; --logic_res
                                select_zero_sig <= '0';
                
			when XORS =>
                                LOGIC_RES <= OP1 xor OP2;
                                select_type_sig <= "01"; --logic_res
                                select_zero_sig <= '0';
                
			when SLLS =>
                                LOGIC_ARITH <= '1';
				LEFT_RIGHT <= '1';
                                select_type_sig <= "10"; --shift_res
                                select_zero_sig <= '0';
                
			when SRLS =>
                                LOGIC_ARITH <= '1';
				LEFT_RIGHT <= '0';
                                select_type_sig <= "10"; --shift_res
                               
			when BEQZS =>
                                --ADD_SUB <= '0';
				--B <= OP2;
                                select_type_sig <= "00"; --add_sub_res
                                select_zero_sig <= '1';
                
			when BNEZS =>
                                --ADD_SUB <= '0';
				--B <= OP2;
                                select_type_sig <= "00"; --add_sub_res
                                select_zero_sig <= '1';
                
			when SGES =>
                                OPSel <= 3;
                                select_type_sig <= "11"; --comp_res
                                select_zero_sig <= '0';
                
			when SLES  =>
                                OPSel <= 5;
                                select_type_sig <= "11"; --comp_res
                                select_zero_sig <= '0';
                
			when NEQS =>
                                OPSel <= 1;
                                select_type_sig <= "11"; --comp_res
                                select_zero_sig <= '0';
                
			when NOP =>
                                select_type_sig <= "00"
                                select_zero_sig <= '1';
                
			when others =>
                                select_type_sig <= "00"
                                select_zero_sig <= '1';     
		end case;
	end process ALU_Proc;

	
	-- Units
	Comp: comparator generic map(NBIT => NBIT)
		port map(A => OP1, B => OP2, OPSel => OPSel, RES => COMP_RES);
		
	Shift: shifter generic map(NBIT => NBIT)
		port map(A => OP1, B => OP2, LOGIC_ARITH => LOGIC_ARITH, LEFT_RIGHT => LEFT_RIGHT, RES => SHIFT_RES);
	
	Add_Sub_unit : P4Adder generic map(NBIT => NBIT)
		port map(A => OP1, B => B, Cin => ADD_SUB, S => ADD_SUB_RES, Cout => Cout);

        Res_mux : mux41 generic map (NBIT => NBIT)
                port map(A => ADD_SUB_RES, B => LOGIC_RES, C => SHIFT_RES, D => COMP_RES, S => select_type_sig, Z => sig_intraMux);

        Zeros_mux : mux21 generic map (NBIT => NBIT)
                port map(A => sig_intraMux, B => (others => '0'), S => select_zero_sig, Z => ALU_RES);
	
end struct;
