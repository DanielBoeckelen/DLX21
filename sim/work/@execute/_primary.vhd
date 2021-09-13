library verilog;
use verilog.vl_types.all;
entity Execute is
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        MUX_A_SEL       : in     vl_logic;
        MUX_B_SEL       : in     vl_logic_vector(1 downto 0);
        ALU_OPC         : in     vl_logic_vector(4 downto 0);
        ALU_OUTREG_EN   : in     vl_logic;
        JUMP_TYPE       : in     vl_logic_vector(1 downto 0);
        PC_IN           : in     vl_logic_vector(31 downto 0);
        A_IN            : in     vl_logic_vector(31 downto 0);
        B_IN            : in     vl_logic_vector(31 downto 0);
        IMM_IN          : in     vl_logic_vector(31 downto 0);
        ADD_WR_IN       : in     vl_logic_vector(4 downto 0);
        ADD_RS1_IN      : in     vl_logic_vector(4 downto 0);
        ADD_RS2_IN      : in     vl_logic_vector(4 downto 0);
        ADD_WR_MEM      : in     vl_logic_vector(4 downto 0);
        ADD_WR_WB       : in     vl_logic_vector(4 downto 0);
        RF_WE_MEM       : in     vl_logic;
        RF_WE_WB        : in     vl_logic;
        OP_MEM          : in     vl_logic_vector(31 downto 0);
        OP_WB           : in     vl_logic_vector(31 downto 0);
        PC_SEL          : out    vl_logic_vector(1 downto 0);
        ZERO_FLAG       : out    vl_logic;
        NPC_ABS         : out    vl_logic_vector(31 downto 0);
        NPC_REL         : out    vl_logic_vector(31 downto 0);
        ALU_RES         : out    vl_logic_vector(31 downto 0);
        B_OUT           : out    vl_logic_vector(31 downto 0);
        ADD_WR_OUT      : out    vl_logic_vector(4 downto 0);
        FE_OFN80_Rst    : in     vl_logic;
        FE_OFN74_Rst    : in     vl_logic;
        FE_OFN68_Rst    : in     vl_logic;
        FE_OFN58_Rst    : in     vl_logic;
        FE_OFN49_Rst    : in     vl_logic
    );
end Execute;
