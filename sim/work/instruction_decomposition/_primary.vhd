library verilog;
use verilog.vl_types.all;
entity instruction_decomposition is
    port(
        INST_IN         : in     vl_logic_vector(31 downto 0);
        Rtype           : in     vl_logic;
        Itype           : in     vl_logic;
        Jtype           : in     vl_logic;
        ADD_RS1         : out    vl_logic_vector(4 downto 0);
        ADD_RS2         : out    vl_logic_vector(4 downto 0);
        ADD_WR          : out    vl_logic_vector(4 downto 0);
        IMM             : out    vl_logic_vector(31 downto 0);
        RD1             : out    vl_logic;
        RD2             : out    vl_logic
    );
end instruction_decomposition;
