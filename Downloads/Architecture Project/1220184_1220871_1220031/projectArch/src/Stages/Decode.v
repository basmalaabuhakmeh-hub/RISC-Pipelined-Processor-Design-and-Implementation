module DecodeStage(input clk,
                      input [31:0] Instruction, ALUForward, MEMForward, PC_D,Data_in_WB,
                      input RegWr_WB, RegWr_EX, RegWr_MEM, MEMR_EX,
                      input [3:0] Rd_EX, Rd_MEM, Rd_WB,
                     output reg  MEM_read, MEM_write, RegW, CLL_E, isSecondCycle,
					 output reg [3:0] R_dest, 
					 output reg [1:0] PC_sel,J_OR_B_Flag, 
					 output reg [31:0] A,B,
                     output reg stallSignal, killSignal,
					 output reg [2:0] ALUOp,						   
					 output reg [1:0] CMPFlag, ALUSrc,WB_sel,
					 output reg [31:0] ExtendedImm,
					 output reg is_LDW_SDW);  
					 
  wire [1:0] RegToRead;	
  wire Extender;	
  wire [5:0] OPCode;
  wire [3:0] Rd, Rs, Rt;
  reg [31:0] BusA, BusB;
  
  reg [1:0] RegDest; // src2 = rt or rd ot rd+1
  wire [31:0] Reg1;
  reg [1:0] ForwardA, ForwardB;
  reg [31:0] temp,R2;
  wire WE_temp;	
  reg [3:0] Rt_or_Rd; 
  wire [3:0] Rd_plus_1;		
  wire [13:0] Imm; 
  assign Rd_plus_1 = Rd + 1;  
  reg isSecondCycle_reg;
wire nextIsSecondCycle;

  
  Split Split_I(Instruction,OPCode, Rd, Rs, Rt, Imm);
	
  ControlUnit CU(clk,OPCode, Rd[0],isSecondCycle_reg, RegW, MEM_read, MEM_write, Extender,nextIsSecondCycle,is_LDW_SDW ,CLL_E, ALUOp
  , PC_sel, WB_sel, RegDest,  J_OR_B_Flag, ALUSrc, RegToRead);
  
  always @(*) begin
	  
	// Mux to choose the destination register based on RegDest control signal 
    case (RegDest)
        2'b00: R_dest = Rd;
        2'b01: R_dest = Rd_plus_1;
        2'b10: R_dest = 4'd14; // R14 for CLL
        default: R_dest = 4'bxxxx; 
    endcase

    // Register to read 
    case (RegToRead)
        2'b00: Rt_or_Rd = Rt;
        2'b01: Rt_or_Rd = Rd;
        2'b10: Rt_or_Rd = Rd_plus_1;
        default: Rt_or_Rd = 4'bxxxx; 
    endcase
					 	
		
    
    case (ForwardA)
      2'b00: A = BusA;
      2'b01: A = ALUForward;
      2'b10: A = MEMForward;
      2'b11: A = Data_in_WB;
    endcase
   
    case (ForwardB)
      2'b00: B = BusB;
      2'b01: B = ALUForward;
      2'b10: B = MEMForward;
      2'b11: B = Data_in_WB;
    endcase	
	
	
	
  end
  
  // Register to store isSecondCycle
always @(posedge clk ) begin
        isSecondCycle_reg <= nextIsSecondCycle;
end
  Extend Ext(Extender,Imm,ExtendedImm);
  CompForB C(A, CMPFlag);
  
  Forwarding_Unit ForwardUnit_A(RegWr_EX, RegWr_MEM, RegWr_WB, Rs, Rd_EX, Rd_MEM, Rd_WB, ForwardA);
  Forwarding_Unit ForwardUnit_B(RegWr_EX, RegWr_MEM, RegWr_WB, Rt_or_Rd, Rd_EX, Rd_MEM, Rd_WB, ForwardB);
  	 						  
					 
  RegFile RF(Rs, Rt_or_Rd, Rd_WB, Data_in_WB,RegWr_WB,clk, BusA,BusB);  // Data_in_WB is for data to be written on register file from MEM_WB buffer 
  
  Hazard_CU HazardDetection(MEMR_EX, ForwardA, ForwardB,CMPFlag, OPCode,isSecondCycle_reg,Rd[0],stallSignal, killSignal); 
  
  always @(posedge clk) begin
    isSecondCycle_reg <= nextIsSecondCycle;
  end
  
  /*initial $monitor("at time from decode:%0d:\nForward A = %0d,\nForward B = %0d"
	  ,$time, ForwardA,ForwardB); 
	    
  initial $monitor("at time:%0d:\nCMPFlag = %0d"
	  ,$time, CMPFlag);	
  initial $monitor(" from decode at time:%0d:\nPC_sel = %0d\nPC_D = %0d\nstallSignal = %0d"
	  ,$time, PC_sel,PC_D,stallSignal);	
  initial $monitor("at time:%0d:\nisLoadDoubleWord = %0d"
	  ,$time, is_LDW_SDW);	*/
  
endmodule