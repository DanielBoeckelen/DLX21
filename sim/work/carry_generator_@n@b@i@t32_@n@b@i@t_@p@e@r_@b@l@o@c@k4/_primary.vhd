library verilog;
use verilog.vl_types.all;
entity carry_generator_NBIT32_NBIT_PER_BLOCK4 is
    port(
        A               : in     vl_logic_vector(32 downto 1);
        B               : in     vl_logic_vector(32 downto 1);
        Cin             : in     vl_logic;
        Co              : out    vl_logic_vector(7 downto 0)
    );
end carry_generator_NBIT32_NBIT_PER_BLOCK4;
