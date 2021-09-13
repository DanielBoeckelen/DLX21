library verilog;
use verilog.vl_types.all;
entity Branch_Cond_Unit_NBIT32 is
    port(
        RST             : in     vl_logic;
        A               : in     vl_logic_vector(31 downto 0);
        ALU_OPC         : in     vl_logic_vector(4 downto 0);
        JUMP_TYPE       : in     vl_logic_vector(1 downto 0);
        PC_SEL          : out    vl_logic_vector(1 downto 0);
        ZERO            : out    vl_logic
    );
end Branch_Cond_Unit_NBIT32;
