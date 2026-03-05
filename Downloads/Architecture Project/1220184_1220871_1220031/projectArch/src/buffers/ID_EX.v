//The buffer between decode and execution stage 
module ID_EX(
  input clk,
  input stall,
  input RegW_D, MEMR_D, MEMW_D,
  input [31:0] A_D, B_D, nextPC_D, ExtendedImm_D,
  input [3:0] Rd2_D,
  input [2:0] ALUOp_D,
  input [1:0] WB_D, ALUSrc_D,
  input is_LDW_SDW,
  output reg RegW_EX, MEMR_EX, MEMW_EX,
  output reg [31:0] A_EX, B_EX, nextPC_EX, ExtendedImm_EX,
  output reg [3:0] Rd2_EX,
  output reg [2:0] ALUOp_EX,
  output reg [1:0] WB_EX, ALUSrc_EX
);

reg latched_LDW_SDW;   

always @(posedge clk) begin
  if (!stall || is_LDW_SDW) begin
    // Update buffer normally (if no stall or LDW entering)
    RegW_EX <= RegW_D;
    MEMR_EX <= MEMR_D;
    MEMW_EX <= MEMW_D;
    WB_EX <= WB_D;
    A_EX <= A_D;
    B_EX <= B_D;
    nextPC_EX <= nextPC_D;
    ExtendedImm_EX <= ExtendedImm_D;
    Rd2_EX <= Rd2_D;
    ALUOp_EX <= ALUOp_D;
    ALUSrc_EX <= ALUSrc_D;

    // Save if we just passed an LDW during a stall
    latched_LDW_SDW <= is_LDW_SDW;
  end
  else if (stall && latched_LDW_SDW) begin
    // Hold the LDW in buffer, do not overwrite
    RegW_EX <= RegW_EX;
    MEMR_EX <= MEMR_EX;
    MEMW_EX <= MEMW_EX;
    WB_EX <= WB_EX;
    A_EX <= A_EX;
    B_EX <= B_EX;
    nextPC_EX <= nextPC_EX;
    ExtendedImm_EX <= ExtendedImm_EX;
    Rd2_EX <= Rd2_EX;
    ALUOp_EX <= ALUOp_EX;
    ALUSrc_EX <= ALUSrc_EX;
  end
  else begin
    // Normal stall, not LDW 
   RegW_EX = 1'b0;
      MEMR_EX = 1'b0;
      MEMW_EX = 1'b0;
      WB_EX = 2'b0;
      A_EX = A_D;
      B_EX = B_D;
  end

  // Reset the LDW flag when stall ends
  if (!stall)
    latched_LDW_SDW <= 0;
end

initial begin
  latched_LDW_SDW = 0;
end

endmodule
