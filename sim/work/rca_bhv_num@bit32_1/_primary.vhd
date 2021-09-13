library verilog;
use verilog.vl_types.all;
entity rca_bhv_numBit32_1 is
    port(
        A               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        Ci              : in     vl_logic;
        S               : out    vl_logic_vector(31 downto 0);
        Co              : out    vl_logic
    );
end rca_bhv_numBit32_1;
