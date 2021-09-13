library verilog;
use verilog.vl_types.all;
entity PG_net_10 is
    port(
        a               : in     vl_logic;
        b               : in     vl_logic;
        p               : out    vl_logic;
        g               : out    vl_logic
    );
end PG_net_10;
