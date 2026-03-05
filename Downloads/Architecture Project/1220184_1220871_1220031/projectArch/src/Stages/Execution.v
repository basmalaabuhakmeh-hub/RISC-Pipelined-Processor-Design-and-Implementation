module ExecutionStage(input [2:0] ALUOp, 
	input [31:0] BusA, BusB, ExtendedImm,
	input [1:0] ALUSrc,
                      output reg signed [1:0] CMPflag, 
					  output reg ZeroFlag,
                      output reg [31:0]  Result);
  reg [31:0] ALUInput2;
  ALU execution(BusA,ALUInput2,ALUOp,Result,ZeroFlag,CMPflag);
  
  always @(*) begin
  // ALU Input MUX
  ALUInput2 = (ALUSrc == 2'b00) ? ExtendedImm :
                (ALUSrc == 2'b01) ? BusB :
                (ALUSrc == 2'b10) ? 0 : // for branch instructions cmp with 0
                 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx; 
  
				 
  end
  
  
endmodule  
