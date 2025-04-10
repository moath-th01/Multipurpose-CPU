library verilog;
use verilog.vl_types.all;
entity datapath_tb is
    generic(
        wsize           : integer := 16;
        addr            : integer := 12
    );
end datapath_tb;
