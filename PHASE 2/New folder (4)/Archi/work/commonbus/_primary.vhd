library verilog;
use verilog.vl_types.all;
entity commonbus is
    generic(
        wsize           : integer := 16;
        addr            : integer := 12
    );
    port(
        s               : in     vl_logic_vector(2 downto 0);
        ac              : in     vl_logic_vector;
        ar              : in     vl_logic_vector;
        ir              : in     vl_logic_vector;
        pc              : in     vl_logic_vector;
        memo            : in     vl_logic_vector;
        dr              : in     vl_logic_vector;
        tr              : in     vl_logic_vector;
        \bus\           : out    vl_logic_vector
    );
end commonbus;
