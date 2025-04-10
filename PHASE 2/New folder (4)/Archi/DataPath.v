module commonbus
#(
    parameter wsize = 16,    
    parameter addr = 12     
)
(
    input [2:0] s,                    
    input [wsize-1:0] ac,              
    input [addr-1:0] ar,               
    input [wsize-1:0] ir,              
    input [wsize-1:0] pc,        
    input [wsize-1:0] memo,     
    input [wsize-1:0] dr,            
    input [wsize-1:0] tr,              
    output reg [wsize-1:0] bus     
);

    always @(*) begin
        case (s)
            3'b001: bus = {4'b0000, ar};  
            3'b010: bus = pc;            
            3'b011: bus = dr;             
            3'b100: bus = ac;             
            3'b101: bus = ir;             
            3'b110: bus = tr;             
            3'b111: bus = memo;           
            default: bus = {wsize{1'bz}}; 
        endcase
    end

endmodule



module datapath
#(
    parameter wsize = 16,    // Data width
    parameter addr = 12      // Address width
)
(
    input I,
    input [2:0] s,                     // Bus selector
    input [wsize-1:0] data_in,         // Input data
    output [wsize-1:0] data_out,   // Output data
    input ldAR,
    input ldPC,
    input ldDR,
    input ldAC,
    input ldIR,
    input ldTR, // Register load signals
    input clrAR,
    input clrPC,
    input clrDR,
    input clrAC,
    input clrTR, // Clear signals
    input inrAR,
    input inrPC,
    input inrDR,
    input inrAC,
    input inrTR, // Increment signals
    input memwrite,
    input memread,                    // Memory write enable
    input CLK,                         // clock                        
    input [3:0] aluop  // ALU operation selector               
);

    // output wires
    wire [wsize-1:0] ac_out, dr_out, ir_out, pc_out, tr_out, mem_out, alu_out;
    wire [addr-1:0] ar_out;
    wire [wsize-1:0] commonbus;
    wire E;
 
    memory #(.A(addr), .m(wsize)) memo1 (
        .CLK(CLK),
        .address(ar_out),
        .data_in(commonbus),
        .data_out(mem_out),
        .write_enable(memwrite),
        .read_enable(memread)
    );
    initial begin
        $readmemh("memory_init.txt", memo1.mem);
        $display("\nMemory initialized from memory_init.txt.");
    end
    AR_Register #(.m(wsize), .A(addr)) AR1 (
        .Data_in(commonbus),
        .LD(ldAR),
        .INR(inrAR),
        .CLR(clrAR),
        .CLK(CLK),
        .Data_out(ar_out)
    );

    PC_Register #(.m(wsize)) PC1 (
        .Data_in(commonbus),
        .LD(ldPC),
        .INR(inrPC),
        .CLR(clrPC),
        .CLK(CLK),
        .Data_out(pc_out)
    );

    DR_Register #(.m(wsize)) DR1 (
        .Data_in(commonbus),
        .LD(ldDR),
        .INR(inrDR),
        .CLR(clrDR),
        .CLK(CLK),
        .Data_out(dr_out)
    );

    AC_Register #(.m(wsize)) AC1 (
        .Data_in(alu_out),
        .LD(ldAC),
        .INR(inrAC),
        .CLR(clrAC),
        .CLK(CLK),
        .Data_out(ac_out)
    );

    IR_Register #(.m(wsize)) IR1 (
        .Data_in(commonbus),
        .LD(ldIR),
        .CLK(CLK),
        .Data_out(ir_out)
    );

    TR_Register #(.m(wsize)) TR1 (
        .Data_in(commonbus),
        .LD(ldTR),
        .INR(inrTR),
        .CLR(clrTR),
        .CLK(CLK),
        .Data_out(tr_out)
    );

    ALU #(.A(wsize)) ALU1 (
        .op1(ac_out),
        .op2(dr_out),
        .ALUOP(aluop),
        .data(alu_out),
        .CLK(CLK),
        .E(E)
    
);
    E_Register E1(
        .updateE(),
        .newE(E),
        .CLK(CLK),
        .E()
    );

    commonbus #(.wsize(wsize), .addr(addr)) CB1(
        .s(s), 
        .ac(ac_out), 
        .ar(ar_out), 
        .ir(ir_out), 
        .pc(pc_out), 
        .memo(mem_out), 
        .dr(dr_out), 
        .tr(tr_out), 
        .bus(commonbus) // Drive the internal commonbus signal
    );

endmodule
