library verilog;
use verilog.vl_types.all;
entity mux21_NBIT32_2 is
    port(
        A               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        S               : in     vl_logic;
        Z               : out    vl_logic_vector(31 downto 0);
        p1              : in     vl_logic;
        FE_OFN4_FE_DBTN2_n1: in     vl_logic
    );
end mux21_NBIT32_2;
