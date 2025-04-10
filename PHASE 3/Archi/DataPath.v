module datapath
#(
    parameter wsize = 16,    // Data width
    parameter addr = 12,
    parameter IRDECODER = 8,
    parameter SCDECODER = 4  // Address width
)

( 
    input CLK,            
    input [IRDECODER-1:0] datain,         
    output [IRDECODER-1:0] dataout   
);
 
    wire [2:0] s;
    wire ldINPR;
    wire ldOUTR;
    wire ldAR;
    wire ldPC;
    wire ldDR;
    wire ldAC;
    wire ldIR;
    wire ldTR;
    wire IEN;
    wire FGI;
    wire FGO;
    wire set_IEN;
    wire set_FGI;
    wire set_FGO;
    wire clrIEN;
    wire clrFGI;
    wire clrFGO; 
    wire clrAR;
    wire clrPC;
    wire clrDR;
    wire clrAC;
    wire clrTR;
    wire inrAR;
    wire inrPC;
    wire inrDR;
    wire inrAC;
    wire inrTR; 
    wire memwrite;
    wire memread;                                                     
    wire [3:0] aluop;
    wire [wsize-1:0] ac_out, dr_out, ir_out, pc_out, tr_out, mem_out, alu_out;
    wire [addr-1:0] ar_out;
    wire [IRDECODER-1:0] outr_out;
    wire [IRDECODER-1:0] inpr_out;
    reg [wsize-1:0] commonbus;
    wire E; 
    wire IR_15;
    wire CLR;
    wire [2:0] Opcode;
    wire [7:0] D_OUT;
    wire [15:0] T_OUT;
    wire [3:0] SC;  
    wire I_bit;
    wire inc;
    wire [11:0] ir0_11;
    wire [3:0] Bout;
    wire DZ;
    wire AF;
    wire AZ;
    wire EZ;

    memory #(.A(addr), .m(wsize)) memo1 (
        .CLK(CLK),
        .address(ar_out),
        .data_in(commonbus),
        .data_out(mem_out),
        .write_enable(memwrite),
        .read_enable(memread)
    );
    
    
    assign AF = (ac_out[15] == 0); // AF=1 means AC is positive 
    assign ir0_11 = ir_out[11:0];
    assign IR_15 = ir_out[15];
    assign Opcode = ir_out[14:12];
    assign DZ = (dr_out == 16'b0); // DZ=1 means DR equals zero
    assign AZ = (ac_out == 16'b0); // AZ=1 means AC equals zero
    assign EZ = (E == 0);

    CU #( .ADDR_WIDTH(addr), .DATA_WIDTH(wsize)) cu(
        .CLK(CLK),
        .I_bit(I_bit),
        .IEN(IEN),
        .FGI(FGI),
        .FGO(FGO),
        .set_IEN(set_IEN),
        .set_FGI(set_IEN),
        .set_FGO(set_IEN),
        .clrIEN(clrIEN),
        .clrFGI(clrFGI),
        .clrFGO(clrFGO),
        .CLR(CLR),
        .INC(inc),
        .ldINPR(ldINPR),
        .ldOUTR(ldOUTR),
        .ldAR(ldAR),
        .ldPC(ldPC),
        .ldDR(ldDR),
        .ldAC(ldAC),
        .ldIR(ldIR),
        .ldTR(ldTR), 
        .clrAR(clrAR),
        .clrPC(clrPC),
        .clrDR(clrDR),
        .clrAC(clrAC),
        .clrTR(clrTR), 
        .inrAR(inrAR),
        .inrPC(inrPC),
        .inrDR(inrDR),
        .inrAC(inrAC),
        .inrTR(inrTR),
        .memwrite(memwrite),
        .memread(memread),                
        .aluop(aluop),
        .s(s),
        .Opcode(Opcode),
        .D(D_OUT),
        .T(T_OUT),
        .B(Bout),
        .DR_ZERO(DZ),
        .A_ZERO(AZ),
        .A_Flag(AF),
        .E_ZERO(EZ)
    );
	
    IR0_11ENCODER#(.m(addr)) ENCODER1(.IR0_11(ir0_11), .B(Bout));
    I_module i_module (.IR(IR_15), .I_bit(I_bit)); 
    IR_Decoder#(.m(IRDECODER)) ir_decoder(.Data_IN(Opcode), .D(D_OUT));
    SequenceCounter#(.m(SCDECODER)) seq_counter(.CLR(CLR), .INC(inc), .CLK(CLK), .SC_OUT(SC));
    
    TDECODER#(.m(wsize)) seq_decoder(.Data_IN(SC), .T(T_OUT));
    
	
    // Register modules
    AR_Register #(.m(wsize), .A(addr)) AR1 (.Data_in(commonbus), .LD(ldAR), .INR(inrAR), .CLR(clrAR), .CLK(CLK), .Data_out(ar_out));
    PC_Register #(.m(wsize)) PC1 (.Data_in(commonbus), .LD(ldPC), .INR(inrPC), .CLR(clrPC), .CLK(CLK), .Data_out(pc_out));
    DR_Register #(.m(wsize)) DR1 (.Data_in(commonbus), .LD(ldDR), .INR(inrDR), .CLR(clrDR), .CLK(CLK), .Data_out(dr_out));
    AC_Register #(.m(wsize)) AC1 (.Data_in(alu_out), .LD(ldAC), .INR(inrAC), .CLR(clrAC), .CLK(CLK), .Data_out(ac_out));
    IR_Register #(.m(wsize)) IR1 (.Data_in(commonbus), .LD(ldIR), .CLK(CLK), .Data_out(ir_out));
    TR_Register #(.m(wsize)) TR1 (.Data_in(commonbus), .LD(ldTR), .INR(inrTR), .CLR(clrTR), .CLK(CLK), .Data_out(tr_out));
    
    OUTR #(.u(IRDECODER)) OUTR1 (.Data_in(commonbus), .CLK(CLK), .Data_out(dataout),.LD(ldOUTR));
	
    INPR #(.u(IRDECODER)) INPR1 (.Data_in(datain), .CLK(CLK), .Data_out(inpr_out),.LD(ldINPR));
    
    ALU #(.A(wsize)) ALU1 (.op1(ac_out), .op2(dr_out), .op3(inpr_out), .ALUOP(aluop), .data(alu_out), .CLK(CLK), .E(E));
	
    E_Register E1 (.updateE(), .newE(E), .CLK(CLK), .E());

    // Instantiate IEN flip-flop
    IEN_FF ien_inst (.CLK(CLK), .SET(set_IEN), .CLR(clrIEN), .IEN(IEN));

    // Instantiate FGI flip-flop
    FGI_FF fgi_inst (.CLK(CLK), .SET(set_FGI), .CLR(clRFGI), .FGI(FGI));

    // Instantiate FGO flip-flop
    FGO_FF fgo_inst (.CLK(CLK), .SET(set_FGO), .CLR(clrFGO), .FGO(FGO));
    
    // MUX for the common bus
    always @(*) begin
        case (s)
            3'b001: commonbus = {4'b0000, ar_out};  
            3'b010: commonbus = pc_out;            
            3'b011: commonbus = dr_out;             
            3'b100: commonbus = ac_out;             
            3'b101: commonbus = ir_out;             
            3'b110: commonbus = tr_out;             
            3'b111: commonbus = mem_out;           
            default: commonbus = {wsize{1'bz}}; 
        endcase
    end

endmodule