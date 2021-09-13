library verilog;
use verilog.vl_types.all;
entity instruction_type is
    port(
        INST_IN         : in     vl_logic_vector(31 downto 0);
        Rtype           : out    vl_logic;
        Itype           : out    vl_logic;
        Jtype           : out    vl_logic
    );
end instruction_type;
