library verilog;
use verilog.vl_types.all;
entity mux41_NBIT32_2 is
    port(
        A               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        C               : in     vl_logic_vector(31 downto 0);
        D               : in     vl_logic_vector(31 downto 0);
        S               : in     vl_logic_vector(1 downto 0);
        Z               : out    vl_logic_vector(31 downto 0)
    );
end mux41_NBIT32_2;
