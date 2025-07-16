module alu #(
    parameter N = 8
)(
    input  [N-1:0] num1,
    input  [N-1:0] num2,
    input  [4:0] operation,
    input         reset,
    output reg signed [N-1:0] results,
    output reg [2*N-1:0] xresults,
    output reg carryflag,
    output reg overflow
);

reg signed[N:0]  temp;

always @(*) begin
    // Default reset state
    if (reset) begin
        results   = 0;
        xresults  = 0;
        carryflag = 0;
        overflow  = 0;
    end else begin
        // Clear before execution
        results   = 0;
        xresults  = 0;
        carryflag = 0;
        overflow  = 0;

        case (operation)
            // Arithmetic
            5'b00000 : begin 
                temp = num1 + num2; 
                results = temp[N-1:0]; 
                carryflag = temp[N]; 
                overflow = (num1[N-1] == num2[N-1]) && (results[N-1] != num1[N-1]);
            end 

            5'b00001 : begin 
                temp = num1 - num2; 
                results = temp[N-1:0]; 
                carryflag = temp[N]; 
                overflow = (num1[N-1] != num2[N-1]) && (results[N-1] != num1[N-1]);
            end 

            5'b00010 : results = num1 + 1;
            5'b00011 : results = num1 - 1;
            5'b00100 : xresults = num1 * num2;

            // Logical
            5'b00101 : results = num1 | num2;
            5'b00110 : results = num1 & num2;
            5'b00111 : results = num1 ^ num2;
            5'b01000 : results = ~(num1 | num2);
            5'b01001 : results = ~(num1 & num2);
            5'b01010 : results = ~(num1 ^ num2);
            5'b01011 : results = ~num1;

            // Shift and Rotate
            5'b01100 : results = num1 << 1;                        // Logical shift left
            5'b01101 : results = num1 >> 1;                        // Logical shift right
            5'b01110 : results = $signed(num1) >>> 1;              // Arithmetic shift right
            5'b01111 : results = {num1[N-2:0], num1[N-1]};         // Rotate left
            5'b10000 : results = {num1[0], num1[N-1:1]};           // Rotate right

            // Comparisons (zero-extended)
            5'b10001 : results = { { (N-1){1'b0} }, (num1 == num2) };
            5'b10010 : results = { { (N-1){1'b0} }, (num1 >  num2) };
            5'b10011 : results = { { (N-1){1'b0} }, (num1 <  num2) };
            5'b10100 : results = { { (N-1){1'b0} }, (num1 >= num2) };
            5'b10101 : results = { { (N-1){1'b0} }, (num1 <= num2) };

            default: begin
                results   = 0;
                xresults  = 0;
                carryflag = 0;
                overflow  = 0;
            end
        endcase
    end
end


endmodule
