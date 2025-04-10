library verilog;
use verilog.vl_types.all;
entity datApath_tb is
    generic(
        wsize           : integer := 16;
        addr            : integer := 12
    );
end datApath_tb;
