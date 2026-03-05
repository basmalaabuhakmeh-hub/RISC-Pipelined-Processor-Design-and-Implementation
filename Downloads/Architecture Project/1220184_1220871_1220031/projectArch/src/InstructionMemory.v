//Module for instruction memory
module Inst_MEM(address, inst);
  input [31:0] address;
  output reg [31:0] inst;
  
  reg [31:0] ROM[0:255]; //256 intsructions
  
  initial begin 
    $readmemb("InstructionMemory.dat", ROM);
  end
  
  always @(*) begin 
    inst = ROM[address]; 
	end
endmodule

//test bench for the Instructions Memory
module InstructionMemory_test(); 
	reg [31:0] address;
	wire [31:0] inst;
	
	Inst_MEM MEM(address, inst);
	
	initial begin
		address = 0;
		$monitor("time = %0d,		Address = %b ===> 		MEM[address] = Instruction = %b",$time, address, inst);
		repeat(4) begin
			#(10);
			address = address + 1;
		end	
	end	   
endmodule