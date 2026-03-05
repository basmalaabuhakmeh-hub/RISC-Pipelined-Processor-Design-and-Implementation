//The buffer between fetch and decode stage 
module IF_ID(clk,Instruction_F, PC_F, stall, kill, Instruction_D, PC_D);
  input clk,stall,kill;
  input [31:0] Instruction_F,PC_F;
  output reg [31:0] Instruction_D, PC_D;
  
  always@(posedge clk) begin
    if(~stall) begin
	  if(kill) Instruction_D = 32'hFFFFFFFF;
	  else Instruction_D = Instruction_F;
      PC_D = PC_F;
    end
	else Instruction_D = Instruction_D; 
  end
endmodule