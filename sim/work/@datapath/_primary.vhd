library verilog;
use verilog.vl_types.all;
entity Datapath is
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        INS_IN          : in     vl_logic_vector(31 downto 0);
        DATA_IN         : in     vl_logic_vector(31 downto 0);
        MUX_A_SEL       : in     vl_logic;
        MUX_B_SEL       : in     vl_logic_vector(1 downto 0);
        ALU_OPC         : in     vl_logic_vector(4 downto 0);
        ALU_OUTREG_EN   : in     vl_logic;
        JUMP_TYPE       : in     vl_logic_vector(1 downto 0);
        DRAM_R_IN       : in     vl_logic;
        MEM_EN_IN       : in     vl_logic;
        DRAM_W_IN       : in     vl_logic;
        RF_WE           : in     vl_logic;
        LOAD_TYPE_IN    : in     vl_logic_vector(1 downto 0);
        STORE_TYPE_IN   : in     vl_logic;
        WB_MUX_SEL      : in     vl_logic;
        INS_OUT         : out    vl_logic_vector(31 downto 0);
        IRAM_ADDR_OUT   : out    vl_logic_vector(31 downto 0);
        DRAM_ADDR_OUT   : out    vl_logic_vector(31 downto 0);
        DATA_OUT        : out    vl_logic_vector(31 downto 0);
        DRAM_R_OUT      : out    vl_logic;
        DRAM_W_OUT      : out    vl_logic;
        Bubble_out      : out    vl_logic;
        LOAD_TYPE_OUT   : out    vl_logic_vector(1 downto 0);
        STORE_TYPE_OUT  : out    vl_logic;
        FE_OFN79_Rst    : in     vl_logic;
        FE_OFN57_Rst    : in     vl_logic;
        FE_OFN34_Rst    : in     vl_logic;
        FE_OFN25_Rst    : in     vl_logic;
        FE_OFN20_Rst    : in     vl_logic;
        FE_OFN13_Rst    : in     vl_logic;
        FE_OFN8_Rst     : in     vl_logic;
        FE_OFN5_Rst     : in     vl_logic
    );
end Datapath;
