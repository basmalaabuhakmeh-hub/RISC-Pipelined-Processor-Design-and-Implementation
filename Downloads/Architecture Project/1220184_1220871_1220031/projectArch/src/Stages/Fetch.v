module FetchStage(
    input clk, stall, kill,
    input [31:0] PC_D, Reg, RR,  
    input [13:0] Imm,
    input signed [1:0] CMPresult,
    input [1:0] PC_sel, J_OR_B_Flag,
    output reg [31:0] Instruction, NPC,
    output reg [31:0] currentPC  
);								
  
    reg [31:0] PC;
    wire [31:0] Inst, NextPC;
    
    // Instruction memory instance 
    Inst_MEM readInstruction(.address(PC), .inst(Inst));
    
    // PC control unit
    PC_CU PC_controlUnit(
        .currentPC(PC), 
        .PC_D(PC_D), 
        .Imm(Imm), 
        .J_OR_B_Flag(J_OR_B_Flag), 
        .RR(RR), 
        .Reg(Reg), 
        .CMPresult(CMPresult), 
        .PC_sel(PC_sel), 
        .NextPC(NextPC)
    );	
	
	//initial $monitor("at time:%0d:\nPC_sel = %0d\nPC_D = %0d"
	  //,$time, PC_sel,PC_D);
    
    // Initialize PC to 0
    initial begin
        PC = 32'h00000000;
        Instruction = 32'hFFFFFFFF; // NOP
        NPC = 32'h00000000;
        currentPC = 32'h00000000;
    end
always @(posedge clk) begin
    if (!stall) begin
        PC <= NextPC;							  
        NPC <= NextPC;
        currentPC <= PC;

        if (!kill)
            Instruction <= Inst;
        else
            Instruction <= 32'hFFFFFFFF;
    end
    // If stall do not update PC or Instruction
end

    
endmodule