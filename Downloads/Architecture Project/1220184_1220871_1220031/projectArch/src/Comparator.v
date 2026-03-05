module Comparator(input signed [31:0] A, B,
                     output reg signed [1:0] flag);
  
  always @(*) begin
    if(A == B) flag = 0;
    else if(A > B) flag =1;
	else flag = -1;
  end
endmodule 

module comparator_test();
	reg [31:0] A,B;
	wire [1:0] flag;
	
	Comparator C(A, B, flag);
	
	initial begin
		A = 1;
		B = 1;
		$monitor("time = %0d, A = %0d, B = %0d ===> flag = %b",$time, A, B, flag);
		#10; A = 3;
	end			   
endmodule
	
	