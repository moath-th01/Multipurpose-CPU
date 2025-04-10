library verilog;
use verilog.vl_types.all;
entity memory is
    generic(
        A               : integer := 12;
        m               : integer := 16
    );
    port(
        CLK             : in     vl_logic;
        address         : in     vl_logic_vector;
        data_in         : in     vl_logic_vector;
        write_enable    : in     vl_logic;
        read_enable     : in     vl_logic;
        data_out        : out    vl_logic_vector
    );
end memory;
