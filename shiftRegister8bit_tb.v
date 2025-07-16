`timescale 1ns/1ps
`include "shiftRegister8bit.v"
module shiftRegister8bit_tb();
reg clk,reset,mov;
reg data_in;
wire [7:0] data_out;

shiftRegister8bit sst(clk,reset,mov,data_in,data_out);

initial clk=0;
always #5 clk=~clk;

initial 
  begin
    reset=1;
    #10
    reset=0;
    mov=0;
   data_in = 1; #10;
        data_in = 0; #10;
        data_in = 1; #10;
        data_in = 0; #10;
        data_in = 1; #10;
        data_in = 0; #10;
        data_in = 1; #10;
        data_in = 0; #10;
   mov=1;#10;
       data_in = 1; #10;
        data_in = 1; #10;
        data_in = 0; #10;
        data_in = 1; #10;
        data_in = 1; #10;
        data_in = 0; #10;
        data_in = 1; #10;
        data_in = 1; #10;
       
   
      
   #10 ; reset=1; #10;
$finish;

end
initial 
     begin
    $dumpfile("shiftRegister8bit.vcd");
    $dumpvars(0,shiftRegister8bit_tb);
    end
endmodule

