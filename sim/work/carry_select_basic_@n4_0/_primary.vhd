library verilog;
use verilog.vl_types.all;
entity carry_select_basic_N4_0 is
    port(
        A               : in     vl_logic_vector(3 downto 0);
        B               : in     vl_logic_vector(3 downto 0);
        C_i             : in     vl_logic;
        S               : out    vl_logic_vector(3 downto 0);
        n199            : in     vl_logic;
        ADD_SUB         : in     vl_logic
    );
end carry_select_basic_N4_0;
