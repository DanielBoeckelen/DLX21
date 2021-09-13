library verilog;
use verilog.vl_types.all;
entity RCA_N4_4 is
    port(
        A               : in     vl_logic_vector(3 downto 0);
        B               : in     vl_logic_vector(3 downto 0);
        Ci              : in     vl_logic;
        S               : out    vl_logic_vector(3 downto 0);
        Co              : out    vl_logic
    );
end RCA_N4_4;
