module memory 
#(
    parameter A = 12,  // Address width
    parameter m = 16   // Data width
)
(
    input CLK,                   // Clock signal
    input [A-1:0] address,       // Memory address
    input [m-1:0] data_in,       // Data to write into memory
    input write_enable,          // Enable signal for write operation
    input read_enable,           // Enable signal for read operation
    output reg [m-1:0] data_out  // Data read from memory
);
    localparam D = (1 << A);  
    reg [m-1:0] mem [0:D-1];
    
    always @(posedge CLK)
     begin
       if (address != 0) begin
            if (write_enable) begin
                mem[address] <= data_in;  
            end

            if (read_enable) begin
                data_out <= mem[address]; 
            end
        end
     else begin
            
            if (write_enable) begin
                data_out <= 16'b0; 
            end
            if (read_enable) begin
                data_out <= 16'b0; 
            end
        end
     end
endmodule

