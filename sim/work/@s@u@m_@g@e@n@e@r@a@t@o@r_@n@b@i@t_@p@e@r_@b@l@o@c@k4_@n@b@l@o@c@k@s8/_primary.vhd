library verilog;
use verilog.vl_types.all;
entity SUM_GENERATOR_NBIT_PER_BLOCK4_NBLOCKS8 is
    port(
        A               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        Ci              : in     vl_logic_vector(7 downto 0);
        S               : out    vl_logic_vector(31 downto 0);
        n199            : in     vl_logic;
        ADD_SUB         : in     vl_logic
    );
end SUM_GENERATOR_NBIT_PER_BLOCK4_NBLOCKS8;
