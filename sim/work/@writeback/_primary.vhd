library verilog;
use verilog.vl_types.all;
entity Writeback is
    port(
        WB_MUX_SEL      : in     vl_logic;
        DATA_IN         : in     vl_logic_vector(31 downto 0);
        ALU_RES_IN      : in     vl_logic_vector(31 downto 0);
        ADD_WR_IN       : in     vl_logic_vector(4 downto 0);
        DATA_OUT        : out    vl_logic_vector(31 downto 0);
        ADD_WR_OUT      : out    vl_logic_vector(4 downto 0)
    );
end Writeback;
