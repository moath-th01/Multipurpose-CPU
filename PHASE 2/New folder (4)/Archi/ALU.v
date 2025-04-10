module ALU
#(
    parameter A = 16
)
(
    input CLK,                     // Clock signal
    input [A-1:0] op1, op2,        // Operands
    input [3:0] ALUOP,             
    output reg [A-1:0] data,   
    output E                       
);
    // Internal signals
    reg updateE;                   
    reg newE;                     
    parameter
        AND = 4'b0000,
        ADD = 4'b0001,
        CLA = 4'b0010,
        CMA = 4'b0011,
        CIR = 4'b0100,
        CIL = 4'b0101,
        INC = 4'b0110,
        CLE = 4'b0111,
        CME = 4'b1000,
        SPA = 4'b1001,
        SNA = 4'b1010,
        SZA = 4'b1011,
        SZE = 4'b1100,
        LDA = 4'b1101;

    // Instantiate E_Register
    E_Register e_reg (
        .CLK(CLK),
        .updateE(updateE),
        .newE(newE),
        .E(E) // Output from the E_Register
    );

    // ALU logic
    always @(*) begin
        data = {A{1'bx}};
        updateE = 1'b0; 
        newE = 1'bx;    

        case (ALUOP)
            AND: begin
                data = op1 & op2;
            end
            ADD: begin
                {newE, data} = op1 + op2; 
                updateE = 1'b1;           
            end
            CLA: begin
                data = {A{1'b0}};
            end
            CMA: begin
                data = ~op1;
            end
            CIR: begin
                {data, newE} = {op1, E} >> 1; // Shift right with E
                updateE = 1'b1;               // Signal to update E
            end
            CIL: begin
                {newE, data} = {E, op1} << 1; // Shift left with E
                updateE = 1'b1;               // Signal to update E
            end
            INC: begin
                data = op1 + 1;
            end
            CLE: begin
                newE = 1'b0;                  // Clear E
                updateE = 1'b1;               // Signal to update E
            end
            CME: begin
                newE = ~E;                    // Complement E
                updateE = 1'b1;               // Signal to update E
            end
            SPA, SNA, SZA, SZE: begin
                // No changes to data or E here; handle based on control logic
                data = {A{1'b0}};
            end
            LDA: begin
                data = op1;
            end
            default: begin
                data = {A{1'bx}};
            end
        endcase
    end
endmodule



module E_Register (
    input CLK,                 // Clock signal
    input updateE,             // Control signal to update E
    input newE,                // New value for E
    output reg E               // Current value of E
);
    always @(posedge CLK) begin
        if (updateE) begin
            E <= newE;         // Update E on control signal
        end
    end
endmodule

