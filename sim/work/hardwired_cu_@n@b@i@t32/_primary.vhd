library verilog;
use verilog.vl_types.all;
entity hardwired_cu_NBIT32 is
    port(
        MUX_A_SEL       : out    vl_logic;
        MUX_B_SEL       : out    vl_logic_vector(1 downto 0);
        ALU_OPC         : out    vl_logic_vector(4 downto 0);
        ALU_OUTREG_EN   : out    vl_logic;
        DRAM_R_IN       : out    vl_logic;
        JUMP_TYPE       : out    vl_logic_vector(1 downto 0);
        MEM_EN_IN       : out    vl_logic;
        DRAM_W_IN       : out    vl_logic;
        RF_WE           : out    vl_logic;
        LOAD_TYPE_IN    : out    vl_logic_vector(1 downto 0);
        STORE_TYPE_IN   : out    vl_logic;
        WB_MUX_SEL      : out    vl_logic;
        INS_IN          : in     vl_logic_vector(31 downto 0);
        Bubble          : in     vl_logic;
        Clk             : in     vl_logic;
        Rst             : in     vl_logic
    );
end hardwired_cu_NBIT32;
