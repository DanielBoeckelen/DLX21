library verilog;
use verilog.vl_types.all;
entity mux5to1_numBit32_2 is
    port(
        IN1             : in     vl_logic_vector(31 downto 0);
        IN2             : in     vl_logic_vector(31 downto 0);
        IN3             : in     vl_logic_vector(31 downto 0);
        IN4             : in     vl_logic_vector(31 downto 0);
        IN5             : in     vl_logic_vector(31 downto 0);
        SEL_in          : in     vl_logic_vector(2 downto 0);
        Z               : out    vl_logic_vector(31 downto 0)
    );
end mux5to1_numBit32_2;
