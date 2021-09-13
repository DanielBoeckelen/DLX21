library verilog;
use verilog.vl_types.all;
entity comparator_NBIT32 is
    port(
        A               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        OPSel           : in     vl_logic_vector(2 downto 0);
        RES             : out    vl_logic_vector(31 downto 0);
        p1              : in     vl_logic
    );
end comparator_NBIT32;
