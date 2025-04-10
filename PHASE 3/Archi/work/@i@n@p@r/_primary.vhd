library verilog;
use verilog.vl_types.all;
entity INPR is
    generic(
        u               : integer := 8
    );
    port(
        Data_in         : in     vl_logic_vector;
        Data_out        : out    vl_logic_vector
    );
end INPR;
