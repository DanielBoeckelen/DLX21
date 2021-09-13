library verilog;
use verilog.vl_types.all;
entity PGblock_22 is
    port(
        Pik             : in     vl_logic;
        Gik             : in     vl_logic;
        Pk_1j           : in     vl_logic;
        Gk_1j           : in     vl_logic;
        Pij             : out    vl_logic;
        Gij             : out    vl_logic
    );
end PGblock_22;
