library verilog;
use verilog.vl_types.all;
entity shifter_NBIT32 is
    port(
        A               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        LOGIC_ARITH     : in     vl_logic;
        LEFT_RIGHT      : in     vl_logic;
        RES             : out    vl_logic_vector(31 downto 0);
        p1              : in     vl_logic
    );
end shifter_NBIT32;
