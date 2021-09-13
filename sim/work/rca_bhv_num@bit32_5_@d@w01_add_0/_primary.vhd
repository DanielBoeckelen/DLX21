library verilog;
use verilog.vl_types.all;
entity rca_bhv_numBit32_5_DW01_add_0 is
    port(
        A               : in     vl_logic_vector(32 downto 0);
        B               : in     vl_logic_vector(32 downto 0);
        CI              : in     vl_logic;
        SUM             : out    vl_logic_vector(32 downto 0);
        CO              : out    vl_logic
    );
end rca_bhv_numBit32_5_DW01_add_0;
