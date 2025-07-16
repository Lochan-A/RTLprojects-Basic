`timescale 1ns/1ps
`include "alu.v"

module alu_tb();

parameter N = 8;

reg  [N-1:0] num1, num2;
reg  [4:0] operation;
reg  reset;
wire [N-1:0] results;
wire [2*N-1:0] xresults;
wire carryflag, overflow;

// Instantiate ALU
alu #(N) dut (
    .num1(num1),
    .num2(num2),
    .operation(operation),
    .reset(reset),
    .results(results),
    .xresults(xresults),
    .carryflag(carryflag),
    .overflow(overflow)
);

// Task to apply test and display result
task run_test;
    input [N-1:0] a, b;
    input [4:0] op;
    begin
        num1 = a;
        num2 = b;
        operation = op;
        #5;
        $display("OPCODE = %b | num1 = %d | num2 = %d | results = %d | xresults = %d | carry = %b | overflow = %b", 
                  op, a, b, results, xresults, carryflag, overflow);
    end
endtask

initial begin
    $display("==== ALU Test Started ====");

    reset = 1; #5;
    reset = 0;

    // Arithmetic
    run_test(8'd100, 8'd28, 5'b00000);  // Add
    run_test(8'd100, 8'd200, 5'b00000); // Add with overflow
    run_test(8'd100, 8'd28, 5'b00001);  // Sub
    run_test(8'd5,   8'd0,  5'b00010);  // Inc
    run_test(8'd5,   8'd0,  5'b00011);  // Dec
    run_test(8'd10,  8'd20, 5'b00100);  // Mul

    // Logical
    run_test(8'b10101010, 8'b11001100, 5'b00101); // OR
    run_test(8'b10101010, 8'b11001100, 5'b00110); // AND
    run_test(8'b10101010, 8'b11001100, 5'b00111); // XOR
    run_test(8'b10101010, 8'b11001100, 5'b01000); // NOR
    run_test(8'b10101010, 8'b11001100, 5'b01001); // NAND
    run_test(8'b10101010, 8'b11001100, 5'b01010); // XNOR
    run_test(8'b10101010, 8'b00000000, 5'b01011); // NOT

    // Shift / Rotate
    run_test(8'b10010011, 8'd0, 5'b01100); // LSL
    run_test(8'b10010011, 8'd0, 5'b01101); // LSR
    run_test(8'b10010011, 8'd0, 5'b01110); // ASR
    run_test(8'b10010011, 8'd0, 5'b01111); // Rotate Left
    run_test(8'b10010011, 8'd0, 5'b10000); // Rotate Right

    // Comparisons
    run_test(8'd20, 8'd20, 5'b10001); // ==
    run_test(8'd30, 8'd20, 5'b10010); // >
    run_test(8'd10, 8'd20, 5'b10011); // <
    run_test(8'd25, 8'd25, 5'b10100); // >=
    run_test(8'd10, 8'd20, 5'b10101); // <=

    $display("==== ALU Test Completed ====");
    $finish;
end
  initial 
     begin
    $dumpfile("alu.vcd");
    $dumpvars(0,alu_tb);
    end

endmodule
