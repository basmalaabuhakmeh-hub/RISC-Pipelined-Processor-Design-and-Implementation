//module to Split the instruction into OpCode, Registers, ...
module Split(Inst,OPCode, Rd, Rs, Rt, Imm);
  input [31:0] Inst;
  output [5:0] OPCode;
  output [3:0] Rd, Rs, Rt;		  
  output [13:0] Imm;
  
  assign OPCode = Inst[31:26];
  assign Rd = Inst[25:22];
  assign Rs = Inst[21:18];
  assign Rt = Inst[17:14];
  assign Imm = Inst[13:0];
  
endmodule

//Test the Splitter of the instruction
module Splitter_test();
  reg [31:0] Inst;
  wire [5:0] OPCode;
  wire [3:0] Rd, Rs, Rt;
  wire [13:0] Imm;
  
  Split SP(Inst,OPCode, Rd, Rs, Rt, Imm);
  
  initial begin
	 Inst = 32'b01010101010100001100011100110110;
	#10 $display("Instruction:");
	$display("Instruction : ADD R0, R1, R2 ==> %h",Inst);
	$display("OPCode : %b, Rd = %b, Rs = %b, Rt = %b, Imm = %b",OPCode, Rd, Rs, Rt, Imm);
	#10 $finish;
  end
endmodule

  
	  