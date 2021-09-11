library ieee; 
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use work.func_external.all;   -- implementing self-designed function to realize log2 operation
use work.constants.all;

entity carry_generator is
	generic( NBIT : integer;
			 NBIT_PER_BLOCK : integer);
		port ( A   : in std_logic_vector(NBIT downto 1);
			   B   : in std_logic_vector(NBIT downto 1);
			   Cin : in std_logic;
			   Co  : out std_logic_vector((NBIT/NBIT_PER_BLOCK)-1 downto 0));
end carry_generator;

architecture struct of carry_generator is

	component PGblock is
	port (Pik, Gik, Pk_1j, Gk_1j: in std_logic;
		  Pij, Gij: out std_logic);
	end component;

	component Gblock is
	port (Pik, Gik, Gk_1j: in std_logic;
		  Gij: out std_logic);
	end component;

	component PG_net is
	port (a, b: in std_logic;
		  p, g: out std_logic);
	end component;

constant Nlevels: integer := log2(NBIT);  	-- define the number of rows. 
											-- Row number begins from 1, the 1st row is the 1st row below PG network

type signalVector is array (NBIT downto 1) of std_logic_vector(NBIT downto 1);

signal P, G: signalVector;

begin


--------------------------------------------------------------------------------
--         Explanation for the coordiates of matrix P and G                   --
--------------------------------------------------------------------------------
-- To make the algorithm works for not only 32 bit but also higher bits
-- the coordinates of P matrix and G matrix are based on the index which are specified in lecture notes.
--  for ex: P_(4:3) ===> P(4)(3)
--			P_(8:7) ===> P(8)(7)

-- The only modification is that the every index zero in G matrix are forced to be 1 
-- for ex: G_(2:0) = G_(2:2) + P_(2)(2) * G_(1)(0), the value of G_(2:0) is now forced to store in G(2)(1).
-- So  G_(4:0) is stored in G(4)(1)
--     G_(8:0) is stored in G(8)(1)
--     G_(12:0) is stored in G(12)(1)

-- Also to simply the algorithm, the output from PG networks are also stored in P & G matrix
-- but with a different coordinates.
-- for ex: p(3) is stored in P(3)(3) 
--		   g(3) is stored in G(3)(3) 
-- p(3) g(3) is the output from the 3rd block counting from right in PG network 



--------------------------------------------------------------------------------
--          implementing PG nets & top right corner blcok                     --
--------------------------------------------------------------------------------
Rows_PG_net: for column in 2 to NBIT generate
				PGnetblock: PG_net port map (
						a => A(column),
						b => B(column),
						p => P(column)(column),
						g => G(column)(column));
end generate Rows_PG_net;

P(1)(1) <=  A(1) xor B(1); 									-- the block on top right corner of the whole architecture is different from PG net
G(1)(1) <=  (A(1) and B(1)) or ((A(1) xor B(1)) and Cin);   -- its outputs are specified here to make the code easier.


--------------------------------------------------------------------------------
--                             implementing Gblock                            --
--------------------------------------------------------------------------------

Rows_G:   for row in 1 to Nlevels generate                      --row 1 to row 3 are following one algorithm
	rows_g_1: if row <= 3 generate 
		L1: for column in 1 to NBIT generate
			L2: if (column = 2**row) generate
				 GB_low: Gblock port map (                         
				 	Pik => P(column)(column+1-2**(row-1)), 
				 	Gik => G(column)(column+1-2**(row-1)), 
				 	Gk_1j => G(column-2**(row-1))(1),    
				 	Gij => G(column)(1));
			end generate L2;
		end generate L1;
    end generate rows_g_1;

    rows_g_2: if row >= 4 generate								--from row 4 till the last row are following another algorithm
		L1: for column in 1 to NBIT generate
			L2: if (column = 2**row) generate          
				L3: for expG in 0 to 2**(row-3)-1 generate           
 				GB_high: Gblock port map (
					Pik => P(column-expG * 4)(2**(row-1)+1),   
					Gik => G(column-expG * 4)(2**(row-1)+1), 
					Gk_1j => G(2**(row-1))(1), 
					Gij => G(column-expG * 4)(1));
				end generate L3;
			end generate L2;
		end generate L1;
	end generate rows_g_2;
end generate Rows_G;

--------------------------------------------------------------------------------
--                             implementing PGblock                            --
--------------------------------------------------------------------------------
Rows_PG: for row in 1 to Nlevels generate
    rows_pg_1: if row <= 3 generate					 --row 1 to row 3 are following one algorithm		
 		L1: for column in 1 to NBIT generate
			L2: if (column mod (2**row) = 0 and column /= 2**row) generate
 				PGB_low: PGblock port map (
 					Pik => P(column)(column+1-2**(row-1)), 
 					Gik => G(column)(column+1-2**(row-1)), 
 					Pk_1j => P(column-2**(row-1))(column+1-2**row), 
 					Gk_1j => G(column-2**(row-1))(column+1-2**row), 
 					Pij => P(column)(column+1-2**row), 
 					Gij => G(column)(column+1-2**row));
 			end generate L2;
 		end generate L1;
	end generate rows_pg_1;


	rows_pg_2: if row >= 4 generate                 --from row 4 till the last row are following another algorithm
		 L1: for column in 1 to NBIT generate     
			L2: for expPG in 0 to 2**(row-3)-1 generate     
				L3: if (column mod (2**row) = 0 and column /= 2**row) generate
					PGB_high: PGblock port map (           
						Pik => P(column-4 * expPG)(column+1-2**(row-1)), 
						Gik => G(column-4 * expPG)(column+1-2**(row-1)), 
						Pk_1j => P(column-2**(row-1))(column+1-2**row), 
						Gk_1j => G(column-2**(row-1))(column+1-2**row), 
						Pij => P(column-4 * expPG)(column+1-2**row), 
						Gij => G(column-4 * expPG)(column+1-2**row));
				end generate L3;
			end generate L2;
    	 end generate L1;
	end generate rows_pg_2;
end generate Rows_PG;

rows_result: for column in 0 to (NBIT/NBIT_PER_BLOCK)-1 generate    --generate a loop to connect every component in G matrix which the 2nd index is 1
             		Co(column) <= G((column+1)*NBIT_PER_BLOCK)(1);  --and output them as the output of carry generator
end generate rows_result;
  

end struct;




