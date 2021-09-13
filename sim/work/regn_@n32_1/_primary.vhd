library verilog;
use verilog.vl_types.all;
entity regn_N32_1 is
    port(
        DIN             : in     vl_logic_vector(31 downto 0);
        CLK             : in     vl_logic;
        EN              : in     vl_logic;
        RST             : in     vl_logic;
        DOUT            : out    vl_logic_vector(31 downto 0);
        FE_OFN67_Rst    : in     vl_logic;
        FE_OFN52_Rst    : in     vl_logic;
        FE_OFN48_Rst    : in     vl_logic;
        FE_OFN42_Rst    : in     vl_logic;
        FE_OFN38_Rst    : in     vl_logic;
        FE_OFN19_Rst    : in     vl_logic
    );
end regn_N32_1;
