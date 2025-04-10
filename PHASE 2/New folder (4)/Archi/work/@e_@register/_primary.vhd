library verilog;
use verilog.vl_types.all;
entity E_Register is
    port(
        CLK             : in     vl_logic;
        updateE         : in     vl_logic;
        newE            : in     vl_logic;
        E               : out    vl_logic
    );
end E_Register;
