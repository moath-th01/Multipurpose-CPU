module path_tb;

    // Parameters
    parameter wsize = 16;        // Data width
    parameter addr = 12;         // Address width
    parameter IRDECODER = 8;     // IR Decoder width
    parameter SCDECODER = 4;     // Sequence Counter width
    
    // Inputs
    reg CLK;
    reg [2:0] s;                // Selector for the common bus

    // Internal signals for monitoring
    wire [wsize-1:0] ac_out, dr_out, ir_out, pc_out, tr_out, commonbus;
    wire [addr-1:0] ar_out;
    wire [IRDECODER-1:0] outr_out;
    wire [IRDECODER-1:0] inpr;

    // Instantiate the datapath module
    datapath #(
        .wsize(wsize),
        .addr(addr),
        .IRDECODER(IRDECODER),
        .SCDECODER(SCDECODER)
    ) uut (
        .CLK(CLK),
        .datain(inpr), // No longer using data_in and data_out
        .dataout(outr_out)         // data_out is not needed in this testbench
    );

    // Clock Generation
    initial begin
        CLK = 1;
        forever #5 CLK = ~CLK; // 10ns clock period (50MHz)
    end
  initial begin
  
  
  
        // Monitoring register outputs
        $monitor("At time %t, AR: %h, PC: %h, DR: %h, AC: %h, IR: %h, TR: %h, E: %h",
                 $time,uut.ar_out, uut.pc_out, uut.dr_out, uut.ac_out, uut.ir_out, uut.tr_out,uut.E1.newE);
      
        #2500 $stop;



   end
endmodule