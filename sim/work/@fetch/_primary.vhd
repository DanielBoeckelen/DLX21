library verilog;
use verilog.vl_types.all;
entity Fetch is
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        ZERO_FLAG       : in     vl_logic;
        PC_EXT          : in     vl_logic_vector(31 downto 0);
        INS_IN          : in     vl_logic_vector(31 downto 0);
        Bubble_in       : in     vl_logic;
        HDU_INS_IN      : in     vl_logic_vector(31 downto 0);
        HDU_PC_IN       : in     vl_logic_vector(31 downto 0);
        HDU_NPC_IN      : in     vl_logic_vector(31 downto 0);
        PC_OUT          : out    vl_logic_vector(31 downto 0);
        ADDR_OUT        : out    vl_logic_vector(31 downto 0);
        NPC_OUT         : out    vl_logic_vector(31 downto 0);
        INS_OUT         : out    vl_logic_vector(31 downto 0);
        FE_OFN0_Bubble  : in     vl_logic;
        FE_OFN81_Rst    : in     vl_logic;
        FE_OFN77_Rst    : in     vl_logic;
        FE_OFN61_Rst    : in     vl_logic
    );
end Fetch;
