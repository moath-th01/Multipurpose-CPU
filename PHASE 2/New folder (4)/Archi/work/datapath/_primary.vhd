library verilog;
use verilog.vl_types.all;
entity datapath is
    generic(
        wsize           : integer := 16;
        addr            : integer := 12
    );
    port(
        I               : in     vl_logic;
        s               : in     vl_logic_vector(2 downto 0);
        data_in         : in     vl_logic_vector;
        data_out        : out    vl_logic_vector;
        ldAR            : in     vl_logic;
        ldPC            : in     vl_logic;
        ldDR            : in     vl_logic;
        ldAC            : in     vl_logic;
        ldIR            : in     vl_logic;
        ldTR            : in     vl_logic;
        clrAR           : in     vl_logic;
        clrPC           : in     vl_logic;
        clrDR           : in     vl_logic;
        clrAC           : in     vl_logic;
        clrTR           : in     vl_logic;
        inrAR           : in     vl_logic;
        inrPC           : in     vl_logic;
        inrDR           : in     vl_logic;
        inrAC           : in     vl_logic;
        inrTR           : in     vl_logic;
        memwrite        : in     vl_logic;
        memread         : in     vl_logic;
        CLK             : in     vl_logic;
        aluop           : in     vl_logic_vector(3 downto 0)
    );
end datapath;
