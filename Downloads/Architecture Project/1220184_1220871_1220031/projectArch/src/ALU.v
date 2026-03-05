//Mdoule For ALU 
module ALU(IN1,IN2,ALU_OP,Result,ZeroFlag,CMPflag);
  input [31:0] IN1, IN2;
  input [2:0] ALU_OP; 
  wire signed [1:0] flag;
  output reg [31:0] Result;
  output reg ZeroFlag;
  output reg signed [1:0] CMPflag;
  
  // Instantiate Comparator
  Comparator C(IN1, IN2, flag);
  
  always @(*) begin
    case (ALU_OP)
      3'b000: Result <= IN1 | IN2;
      3'b001: Result <= IN1 + IN2;
      3'b010: Result <= IN1 - IN2;
      3'b011: begin
	  CMPflag <= flag;
	  Result <= {{30{flag[1]}}, flag};  
	  end
      3'b100: Result <= IN1 + IN2 + 1; 
      default: Result <= 0;
    endcase
  end
  assign ZeroFlag = ~|Result;
endmodule

//test the ALU component
module ALU_test();
  reg [31:0] IN1, IN2;
  reg [2:0] ALU_OP;
  wire [31:0] Result;
  wire ZeroFlag;
  wire [1:0] CMPflag;
  ALU test(IN1,IN2,ALU_OP,Result,ZeroFlag,CMPflag);
  initial begin
	  IN1 = 16'd2; IN2 = 16'd3;
	  $monitor("time = %0d, Input1 = %0d, Input2 = %0d, ALU_OP = %0d ===> Result = %b, ZeroFlag = %b, CMPFlag = %b"
	  ,$time,IN1, IN2, ALU_OP, Result, ZeroFlag,CMPflag);
	  #10; $display("OR"); ALU_OP = 0;
	  #10; $display("ADD"); ALU_OP = 1;
	  #10; $display("SUB"); ALU_OP = 2;
	  #10; $display("CMP"); ALU_OP = 3;
	  #10; $display("dataMEMaddress"); ALU_OP = 4;
	  #10; $finish;
  end
endmodule
