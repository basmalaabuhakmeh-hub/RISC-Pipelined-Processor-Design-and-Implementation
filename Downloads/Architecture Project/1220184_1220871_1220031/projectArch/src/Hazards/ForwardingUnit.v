//Forwarding Control Unit
module Forwarding_Unit(input RegWr_EX, RegWr_MEM, RegWr_WB, 
                       input [3:0] Rs, Rd_EX, Rd_MEM, Rd_WB,
                       output reg [1:0] Forward);
  always @(*) begin
    if(RegWr_EX == 1'b1 && Rs == Rd_EX) Forward = 2'b01;
    else if(RegWr_MEM == 1'b1 && Rs == Rd_MEM) Forward = 2'b10;
    else if(RegWr_WB == 1'b1  && Rs == Rd_WB) Forward = 2'b11;
    else Forward = 2'b00;
  end 	    
endmodule