module  shiftRegister8bit(input clk,reset,mov,
                          input  data_in,
                          output reg [7:0] data_out);

always@(posedge clk or posedge reset)
begin 
   if(reset) begin data_out <= 8'b0; end 
   else begin 
    if (mov)begin data_out <={data_in,data_out[7:1]}; end
    else begin data_out <={data_out[6:0],data_in};end
end 
end 
endmodule 
  