//PC control Unit 

module PC_CU(currentPC, PC_D, Imm, J_OR_B_Flag, RR, Reg, CMPresult , PC_sel, NextPC);
  input [31:0] currentPC, PC_D, RR, Reg;	//PC_D is PC of the instruction in the decode stage 
  input [13:0] Imm;	  
  input [1:0] J_OR_B_Flag;
  input [1:0] CMPresult;
  input [1:0] PC_sel;
  output reg [31:0]NextPC;
  

  always @(*) begin
    case(PC_sel)
      2'b00: NextPC <= currentPC + 1;	
	  2'b01: NextPC <= Reg;
      2'b10: if(J_OR_B_Flag == 0) NextPC <= PC_D  + {{18{Imm[13]}},Imm};   // if IN  J PC + IMM
      else if (J_OR_B_Flag == 1 && CMPresult == 0 ) NextPC <= PC_D  + {{18{Imm[13]}},Imm};    // BZ 
	  else if (J_OR_B_Flag == 2 && CMPresult == 1 ) NextPC <= PC_D  + {{18{Imm[13]}},Imm};    // BGZ 
	  else if (J_OR_B_Flag == 3 && CMPresult != 1 && CMPresult != 0) NextPC <= PC_D  + {{18{Imm[13]}},Imm};    // BLZ 
      else NextPC <= currentPC + 1;
	  2'b11: NextPC <= PC_D;	  
     default: NextPC <= 32'h00000000; 
    endcase
  end 
  //initial $monitor("at time pc control unit:%0d:\nNextPC = %0d\nImm = %0d\nPC_D = %0d\nJ_OR_B_Flag = %0d"
	  //,$time, NextPC, Imm,PC_D ,J_OR_B_Flag);
endmodule

 