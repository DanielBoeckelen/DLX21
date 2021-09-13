library verilog;
use verilog.vl_types.all;
entity ALU_NBIT32 is
    port(
        OP1             : in     vl_logic_vector(31 downto 0);
        OP2             : in     vl_logic_vector(31 downto 0);
        ALU_OPC         : in     vl_logic_vector(4 downto 0);
        ALU_RES         : out    vl_logic_vector(31 downto 0)
    );
end ALU_NBIT32;
