library verilog;
use verilog.vl_types.all;
entity regn_N32_8 is
    port(
        DIN             : in     vl_logic_vector(31 downto 0);
        CLK             : in     vl_logic;
        EN              : in     vl_logic;
        RST             : in     vl_logic;
        DOUT            : out    vl_logic_vector(31 downto 0)
    );
end regn_N32_8;
