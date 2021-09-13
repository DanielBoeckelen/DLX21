library verilog;
use verilog.vl_types.all;
entity ff_2 is
    port(
        D               : in     vl_logic;
        CLK             : in     vl_logic;
        EN              : in     vl_logic;
        RST             : in     vl_logic;
        Q               : out    vl_logic
    );
end ff_2;
