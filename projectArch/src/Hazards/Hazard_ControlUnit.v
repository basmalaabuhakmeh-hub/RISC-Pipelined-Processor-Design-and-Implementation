//Hazard control unit (kill and stall)
module Hazard_CU(input MEMR_EX, 
				input [1:0] ForwardA, ForwardB,CMPresult ,
				input [5:0] OPCode,
				input isSecondCycle,Rd,
                output reg stallSignal, killSignal);
  
  Stall S(OPCode, MEMR_EX, ForwardA, ForwardB,isSecondCycle,Rd, stallSignal); //check stall
  
  kill KILL(OPCode,CMPresult , killSignal);	// check kill
  
endmodule
