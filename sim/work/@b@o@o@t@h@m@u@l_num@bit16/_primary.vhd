library verilog;
use verilog.vl_types.all;
entity BOOTHMUL_numBit16 is
    port(
        A               : in     vl_logic_vector(15 downto 0);
        B               : in     vl_logic_vector(15 downto 0);
        P               : out    vl_logic_vector(31 downto 0)
    );
end BOOTHMUL_numBit16;
