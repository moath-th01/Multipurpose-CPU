library verilog;
use verilog.vl_types.all;
entity ALU is
    generic(
        A               : integer := 16
    );
    port(
        CLK             : in     vl_logic;
        op1             : in     vl_logic_vector;
        op2             : in     vl_logic_vector;
        ALUOP           : in     vl_logic_vector(3 downto 0);
        data            : out    vl_logic_vector;
        E               : out    vl_logic
    );
end ALU;
