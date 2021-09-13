library verilog;
use verilog.vl_types.all;
entity register_file_NBIT_ADD5_NBIT_DATA32 is
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        ENABLE          : in     vl_logic;
        RD1             : in     vl_logic;
        RD2             : in     vl_logic;
        WR              : in     vl_logic;
        ADD_WR          : in     vl_logic_vector(4 downto 0);
        ADD_RS1         : in     vl_logic_vector(4 downto 0);
        ADD_RS2         : in     vl_logic_vector(4 downto 0);
        DATAIN          : in     vl_logic_vector(31 downto 0);
        OUT1            : out    vl_logic_vector(31 downto 0);
        OUT2            : out    vl_logic_vector(31 downto 0);
        FE_OFN72_Rst    : in     vl_logic;
        FE_OFN65_Rst    : in     vl_logic;
        FE_OFN54_Rst    : in     vl_logic;
        FE_OFN46_Rst    : in     vl_logic;
        FE_OFN44_Rst    : in     vl_logic;
        FE_OFN40_Rst    : in     vl_logic;
        FE_OFN36_Rst    : in     vl_logic;
        FE_OFN33_Rst    : in     vl_logic;
        FE_OFN31_Rst    : in     vl_logic;
        FE_OFN29_Rst    : in     vl_logic;
        FE_OFN27_Rst    : in     vl_logic;
        FE_OFN24_Rst    : in     vl_logic;
        FE_OFN22_Rst    : in     vl_logic;
        FE_OFN17_Rst    : in     vl_logic;
        FE_OFN15_Rst    : in     vl_logic;
        FE_OFN12_Rst    : in     vl_logic;
        FE_OFN10_Rst    : in     vl_logic;
        FE_OFN7_Rst     : in     vl_logic
    );
end register_file_NBIT_ADD5_NBIT_DATA32;
