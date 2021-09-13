library verilog;
use verilog.vl_types.all;
entity HazardDetection is
    port(
        RST             : in     vl_logic;
        ADD_RS1         : in     vl_logic_vector(4 downto 0);
        ADD_RS2         : in     vl_logic_vector(4 downto 0);
        ADD_WR          : in     vl_logic_vector(4 downto 0);
        DRAM_R          : in     vl_logic;
        INS_IN          : in     vl_logic_vector(31 downto 0);
        PC_IN           : in     vl_logic_vector(31 downto 0);
        Bubble          : out    vl_logic;
        HDU_INS_OUT     : out    vl_logic_vector(31 downto 0);
        HDU_PC_OUT      : out    vl_logic_vector(31 downto 0);
        HDU_NPC_OUT     : out    vl_logic_vector(31 downto 0)
    );
end HazardDetection;
