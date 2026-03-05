module CompForB(input signed [31:0] A,
                     output reg signed [1:0] flag);
  
  always @(*) begin
    if(A == 0) flag = 0;
    else if(A > 0) flag =1;
	else flag = -1;
  end
endmodule 														

module CompForB_test();
	reg [31:0] A;
	wire [1:0] flag;
	
	CompForB C(A, flag);
	
	initial begin
		A = 1;
		$monitor("time = %0d, A = %0d===> flag = %b",$time, A, flag);
		#10; A = 3;
	end			   
endmodule
	
	