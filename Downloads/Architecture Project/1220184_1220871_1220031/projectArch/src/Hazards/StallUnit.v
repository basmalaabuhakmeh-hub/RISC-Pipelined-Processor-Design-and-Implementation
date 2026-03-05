module Stall( 
input [5:0] OPCode,
  input MEMR_EX,
  input [1:0] ForwardA,ForwardB,
  input isSecondCycle,Rd,
  output reg stallSignal
); 

initial stallSignal = 1'b0;
	
 always @(*) begin 
    if ((MEMR_EX ==1 && ((ForwardA == 1) || (ForwardB == 1))) || (((OPCode == 6'd8 || OPCode == 6'd9) && isSecondCycle == 0) && !Rd))
      	stallSignal = 1; 
	else  stallSignal = 0;
		  
  end  
  //initial $monitor(" from stall unit at time:%0d:\nForward A = %0d,\nForward B = %0d"
	  //,$time, ForwardA,ForwardB); 
	    
endmodule