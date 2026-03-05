//The buffer between execution and memory stage 
module EX_MEM(input clk,RegW_EX, MEMR_EX, MEMW_EX,  
	input [3:0] Rd3_EX,
	input [1:0] WB_EX, 
	input signed [1:0] CMPflag_EX,
    input [31:0] ALURes_EX ,nextPC_EX ,DataIn_EX,
             output reg RegW_MEM, MEMR_MEM, MEMW_MEM, 
             output reg [3:0] Rd3_MEM, 
			 output reg [1:0]  WB_MEM,
			 output reg signed [1:0] CMPflag_MEM ,
             output reg [31:0]  ALURes_MEM, nextPC_MEM, DataIn_MEM);
  
  always @(posedge clk) begin
    RegW_MEM = RegW_EX; 
    MEMR_MEM = MEMR_EX; 
    MEMW_MEM = MEMW_EX;
    CMPflag_MEM = CMPflag_EX; 
    WB_MEM = WB_EX;
    Rd3_MEM = Rd3_EX;
	nextPC_MEM=nextPC_EX;
	DataIn_MEM=	DataIn_EX;
    ALURes_MEM = ALURes_EX;
  end
endmodule