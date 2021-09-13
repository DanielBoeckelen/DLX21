library verilog;
use verilog.vl_types.all;
entity FWD_Unit is
    port(
        RST             : in     vl_logic;
        ADD_RS1         : in     vl_logic_vector(4 downto 0);
        ADD_RS2         : in     vl_logic_vector(4 downto 0);
        ADD_WR_MEM      : in     vl_logic_vector(4 downto 0);
        ADD_WR_WB       : in     vl_logic_vector(4 downto 0);
        RF_WE_MEM       : in     vl_logic;
        RF_WE_WB        : in     vl_logic;
        FWDA            : out    vl_logic_vector(1 downto 0);
        FWDB            : out    vl_logic_vector(1 downto 0)
    );
end FWD_Unit;
