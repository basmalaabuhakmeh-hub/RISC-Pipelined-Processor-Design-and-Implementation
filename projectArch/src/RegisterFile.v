//Register File module
module RegFile(src1,src2, RegDest, data_in,WE,clk, Reg1,Reg2);
  input [3:0] src1, src2, RegDest;
  input [31:0] data_in;
  input WE, clk;
  output reg [31:0] Reg1,Reg2;
  reg [31:0] Registers[15:0];
  
  always @(posedge clk)
	  #1fs
    if(WE) Registers[RegDest] <= data_in;
  
  assign Reg1 = Registers[src1];
  assign Reg2 = Registers[src2];
  
  initial begin $monitor("at time = %0d:\nR0 = %0d\nR1 = %0d\nR2 = %0d\nR3 = %0d\nR4 = %0d\nR5 = %0d\nR6 = %0d\nR7 = %0d\nR8 = %0d\nR9 = %0d\nR10 = %0d\nR11 = %0d\nR12 = %0d\nR13 = %0d\nR14 = %0d\nR15 = %0d"
	  ,$time,Registers[0],Registers[1],Registers[2],Registers[3],Registers[4],Registers[5],Registers[6],Registers[7], Registers[8],Registers[9],Registers[10],Registers[11],Registers[12],Registers[13],Registers[14],Registers[15]);  
	  
  	
  end
  initial begin
	  Registers[0] <= 32'h00000000;
	  Registers[1] <= 32'h00000000;
	  Registers[2] <= 32'h00000000;
	  Registers[3] <= 32'h00000000;
	  Registers[4] <= 32'h00000000;
	  Registers[5] <= 32'h00000000;
	  Registers[6] <= 32'h00000000;
	  Registers[7] <= 32'h00000000;		  
	  Registers[8] <= 32'h00000000;
	  Registers[9] <= 32'h00000000;
	  Registers[10] <= 32'h00000000;
	  Registers[11] <= 32'h00000000;
	  Registers[12] <= 32'h00000000;
	  Registers[13] <= 32'h00000000;
	  Registers[14] <= 32'h00000000;
	  Registers[15] <= 32'h00000000;
  end
endmodule

//test Register File
module RegFile_test();
  reg [3:0] src1, src2, RegDest;
  reg [31:0] data_in;
  reg WE, clk;
  wire [31:0] Reg1,Reg2;
  
  RegFile RF(src1,src2, RegDest, data_in,WE,clk, Reg1,Reg2);
  
  initial begin 
	  clk = 0;
	  $monitor("From Testing:\nSrc1 = %0d, Src2 = %0d, Destenation = %0d, Data_in = %0h, Write Enable = %b\nRead Registers: R[%0d] = %h, R[%0d] = %h"
	  ,src1,src2,RegDest,data_in,WE,src1,Reg1,src2,Reg2);
	  //read R0, R1
	  #10; src1 = 0; src2 = 1; WE = 0;
	  //write on register 7
	  #10; WE = 1; RegDest = 7; data_in = 32'h0000000A;
	  #10; $finish;
	  
  end
  always #5 clk = ~clk;
endmodule
  