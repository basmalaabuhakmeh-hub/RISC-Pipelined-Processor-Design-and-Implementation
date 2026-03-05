//Module Extender ==> Immediate Extender
module Extend(sel,Imm,out);
  input sel; // to select signed extend or zero extend
  input [13:0] Imm;
  output reg [31:0] out;
  
  always @(*) begin
    if(!sel) out = {18'b0,Imm};
    else out = {{18{Imm[13]}},Imm};
  end
  
endmodule

module Extender_test();
	reg sel;
	reg [13:0] Imm;
	wire [31:0] out;
	
	Extend D(sel,Imm,out);
	
	initial begin
		$monitor("time = %0d, Mode(Signed,Zero) = %b, Immidiate = %b, Extender_out = %b",
		$time, sel, Imm, out);
		
		#10; sel = 0; Imm = 14'b11010111100010; //zero extension 
		#10; sel = 1; Imm = 14'b11010111100010; //sign extension
	end
endmodule
	