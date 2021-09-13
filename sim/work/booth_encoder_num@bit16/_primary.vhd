library verilog;
use verilog.vl_types.all;
entity booth_encoder_numBit16 is
    port(
        B               : in     vl_logic_vector(15 downto 0);
        SEL_out         : out    vl_logic_vector(23 downto 0)
    );
end booth_encoder_numBit16;
