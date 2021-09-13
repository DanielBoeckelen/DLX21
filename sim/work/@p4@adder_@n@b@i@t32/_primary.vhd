library verilog;
use verilog.vl_types.all;
entity P4Adder_NBIT32 is
    port(
        A               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        Cin             : in     vl_logic;
        S               : out    vl_logic_vector(31 downto 0);
        Cout            : out    vl_logic;
        n199            : in     vl_logic;
        ADD_SUB         : in     vl_logic
    );
end P4Adder_NBIT32;
