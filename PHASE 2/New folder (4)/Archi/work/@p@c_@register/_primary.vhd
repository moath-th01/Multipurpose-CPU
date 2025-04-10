library verilog;
use verilog.vl_types.all;
entity PC_Register is
    generic(
        m               : integer := 16
    );
    port(
        Data_in         : in     vl_logic_vector;
        LD              : in     vl_logic;
        INR             : in     vl_logic;
        CLR             : in     vl_logic;
        CLK             : in     vl_logic;
        Data_out        : out    vl_logic_vector
    );
end PC_Register;
