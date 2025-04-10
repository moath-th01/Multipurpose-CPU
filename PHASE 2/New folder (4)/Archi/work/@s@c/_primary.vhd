library verilog;
use verilog.vl_types.all;
entity SC is
    port(
        clk             : in     vl_logic;
        inr             : in     vl_logic;
        clr             : in     vl_logic;
        ss              : out    vl_logic_vector(3 downto 0)
    );
end SC;
