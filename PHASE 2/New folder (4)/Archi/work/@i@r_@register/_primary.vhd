library verilog;
use verilog.vl_types.all;
entity IR_Register is
    generic(
        m               : integer := 16
    );
    port(
        Data_in         : in     vl_logic_vector;
        LD              : in     vl_logic;
        CLK             : in     vl_logic;
        Data_out        : out    vl_logic_vector
    );
end IR_Register;
