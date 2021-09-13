library verilog;
use verilog.vl_types.all;
entity mux21_NBIT32_6 is
    port(
        A               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        S               : in     vl_logic;
        Z               : out    vl_logic_vector(31 downto 0);
        FE_OFN3_Bubble  : in     vl_logic
    );
end mux21_NBIT32_6;
