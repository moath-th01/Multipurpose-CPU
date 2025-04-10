library verilog;
use verilog.vl_types.all;
entity OUTR is
    generic(
        u               : integer := 8
    );
    port(
        Data_in         : in     vl_logic_vector;
        LD              : in     vl_logic;
        CLK             : in     vl_logic;
        Data_out        : out    vl_logic_vector
    );
end OUTR;
